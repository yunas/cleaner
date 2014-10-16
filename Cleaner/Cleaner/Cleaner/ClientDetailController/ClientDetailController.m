//
//  ClientDetailController.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "ClientDetailController.h"
#import "PLPartyTime.h"
#import "NSMutableAttributedString+Attributes.h"
#import "UIFont+Cleaner.h"


@interface ClientDetailController ()<PLPartyTimeDelegate>{

    __weak IBOutlet UITextField *tfPlate;
    __weak IBOutlet UIPickerView *pickerStations;
    __weak IBOutlet UIPickerView *pickerReasons;
    __weak IBOutlet UITextField *tfCustomMsg;
    __weak IBOutlet UILabel *lblHeader;
    NSArray *stationids ;
    NSArray *reasonsArr;
}

@property (nonatomic, strong) PLPartyTime *partyTime;

@end

@implementation ClientDetailController

#pragma mark - Actions

- (IBAction)sendData:(id)sender {
    if(self.partyTime.connectedPeers.count){
        MCPeerID *peerID = [self.partyTime.connectedPeers objectAtIndex:0];
        
        NSDictionary *dictionary = @{@"plateNumber":tfPlate.text,
                                     @"station":stationids[[pickerStations selectedRowInComponent:0]],
                                     @"reason":reasonsArr[[pickerReasons selectedRowInComponent:0]],
                                     @"customMessage":tfCustomMsg.text
                                     };
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        
        [self.partyTime sendData:data
                         toPeers:@[ peerID ]
                        withMode:MCSessionSendDataReliable
                           error:nil];
    }
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
//    Cleaner-Ruf zu Gate absetzen
    stationids = @[@"120",@"121",@"122",@"123",@"124",@"125",@"126",@"127",@"128",@"129",@"130"];
    reasonsArr = @[@"Reason 1",
                   @"Reason 2",
                   @"Reason 3",
                   @"Reason 4",
                   @"Reason 5",
                   @"Reason 6",
                   @"Reason 7",
                   @"Reason 8",
                   @"Reason 9",
                   @"Reason 10"];

    NSString *string = [[NSString alloc]initWithFormat:@"Cleaner-Ruf zu Gate %@ absetzen",self.gate];
    NSMutableAttributedString *stringAtt = [[NSMutableAttributedString alloc]initWithString:string];
    [stringAtt addColor:[UIColor colorWithRed:39/255.0 green:194.0/255.0 blue:225.0 alpha:1.0] substring:self.gate];
    [stringAtt addFont:[UIFont AppFontWithType:FontType_Medium andSize:lblHeader.font.pointSize+40] substring:self.gate];

    [lblHeader setAttributedText:stringAtt];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return stationids.count;
    }
    return reasonsArr.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return stationids[row];
    }
    return reasonsArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //TODO: whatsup !
}

#pragma mark - Party Time Delegate

- (void)partyTime:(PLPartyTime *)partyTime
   didReceiveData:(NSData *)data
         fromPeer:(MCPeerID *)peerID
{
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
