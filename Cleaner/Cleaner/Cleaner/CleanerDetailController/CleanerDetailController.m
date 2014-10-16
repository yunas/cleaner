//
//  ViewController.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "CleanerDetailController.h"
#import "PLPartyTime.h"
#import "UIFont+Cleaner.h"


@interface CleanerDetailController () <PLPartyTimeDelegate>{
    
    __weak IBOutlet UILabel *lblHeader;
    __weak IBOutlet UILabel *lblGateName;
    __weak IBOutlet UILabel *lblStationNumber;
    __weak IBOutlet UITextField *tfPlateNumber;
    __weak IBOutlet UILabel *lblReason;
    __weak IBOutlet UIView *detailView;
}

@property (nonatomic, strong) PLPartyTime *partyTime;

@end

@implementation CleanerDetailController

- (IBAction)donePressed:(id)sender {
    [detailView setHidden:YES];
}

#pragma mark - 

- (IBAction)leaveParty:(id)sender
{
    [self.partyTime leaveParty];
}

#pragma mark - Standard Life Cycle
-(void) initMultiPeerConnectivity{
    self.partyTime = [PLPartyTime instance];
    self.partyTime.delegate = self;
    [self.partyTime joinRoom:self.gate withName:nil];
    
}

-(void) initContentView{
    [detailView setHidden:YES];
    [lblHeader setFont:[UIFont AppFontWithType:FontType_Medium andSize:lblHeader.font.pointSize]];
    [lblGateName setFont:[UIFont AppFontWithType:FontType_Medium andSize:lblGateName.font.pointSize]];
    [lblStationNumber setFont:[UIFont AppFontWithType:FontType_Medium andSize:lblStationNumber.font.pointSize]];
    [lblReason setFont:[UIFont AppFontWithType:FontType_Medium andSize:lblReason.font.pointSize]];
    [tfPlateNumber setFont:[UIFont AppFontWithType:FontType_Medium andSize:tfPlateNumber.font.pointSize]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initContentView];
    [self initMultiPeerConnectivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void) presentDetail:(NSDictionary*)dict{
    [lblGateName setText:self.gate];
    [tfPlateNumber setText:dict[@"plateNumber"]];
    [lblStationNumber setText:dict[@"station"]];
    [lblReason setText:dict[@"reason"]];
//    @"customMessage"

    [detailView setHidden:NO];
}

#pragma mark - Party Time Delegate

- (void)partyTime:(PLPartyTime *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID
{
    
    

    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSString *str = [NSString stringWithFormat:@"%@,%@,%@",dict[@"plateNumber"],dict[@"station"],dict[@"reason"]];
    
    [[[UIAlertView alloc]initWithTitle:@"Message Received"
                              message:str
                             delegate:nil
                    cancelButtonTitle:@"Ok"
                    otherButtonTitles:nil, nil]show];

    [self presentDetail:dict];
    NSLog(@"Received some data!");
}

- (void)partyTime:(PLPartyTime *)partyTime
             peer:(MCPeerID *)peer
     changedState:(MCSessionState)state
     currentPeers:(NSArray *)currentPeers
{
    if (state == MCSessionStateConnected)
    {
        NSLog(@"Connected to %@", peer.displayName);
    }
    else if (state == MCSessionStateConnecting){
        NSLog(@"connecting to %@", peer.displayName);
    }
    else
    {
        NSLog(@"Peer disconnected: %@", peer.displayName);
    }
    
    NSLog(@"Current peers: %@", currentPeers);

}

- (void)partyTime:(PLPartyTime *)partyTime failedToJoinParty:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error localizedFailureReason]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
