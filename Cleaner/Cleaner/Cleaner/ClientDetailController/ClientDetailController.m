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
#import "ProgressHUD.h"


typedef void (^SucessBlock)(id response, BOOL status);
typedef void(^FailureBlock) (NSError *error);


@interface ClientDetailController ()<PLPartyTimeDelegate>{

    __weak IBOutlet UITextField *tfPlate;
    __weak IBOutlet UIPickerView *pickerStations;
    __weak IBOutlet UIPickerView *pickerReasons;
    __weak IBOutlet UITextField *tfCustomMsg;
    __weak IBOutlet UILabel *lblHeader;
    NSMutableArray *stationids ;
    NSArray *reasonsArr;
    SucessBlock multiPeerConnection;
    FailureBlock multiPeerConnectionFailure;
}

@property (nonatomic, strong) PLPartyTime *partyTime;

@end

@implementation ClientDetailController

#pragma mark - Actions
-(void) resetAllViewsContent{
    [tfPlate setText:@""];
    [pickerStations selectRow:0 inComponent:0 animated:YES];
    [pickerReasons selectRow:0 inComponent:0 animated:YES];
    [tfCustomMsg setText:@""];

}


-(void) sendMessageRequestWithSuccess:(SucessBlock)messageSuccessBlock andFailed:(FailureBlock)messageFailureBlock{
    MCPeerID *peerID = nil;
    
    if (self.partyTime.connectedPeers.count) {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"displayName contains[c] 'Cleaner-'"];
        
        NSArray *cleaners = [self.partyTime.connectedPeers filteredArrayUsingPredicate:bPredicate];
        peerID = [cleaners lastObject];
    }
    
    if(peerID){
        
        NSDictionary *dictionary = @{@"plateNumber":tfPlate.text,
                                     @"station":stationids[[pickerStations selectedRowInComponent:0]],
                                     @"reason":reasonsArr[[pickerReasons selectedRowInComponent:0]],
                                     @"customMessage":tfCustomMsg.text
                                     };
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
        
        BOOL success=  [self.partyTime sendData:data
                                        toPeers:@[ peerID ]
                                       withMode:MCSessionSendDataReliable
                                          error:nil];
        if (success) {
            messageSuccessBlock (@"Sent",YES);
        }
        else {
            NSError *error = [NSError errorWithDomain:@"CLEANER-DEBUG" code:420 userInfo:@{@"message":@"Failed to send"}];
            messageFailureBlock (error);
        }
    }
    else{

        NSError *error = [NSError errorWithDomain:@"CLEANER-DEBUG" code:420 userInfo:@{@"message":@"Not connected to Cleaner"}];
        messageFailureBlock (error);
    }
}


-(void) resetBlocks{

    multiPeerConnection = nil;
    multiPeerConnectionFailure = nil;

}

-(void) disconnectParty{
    [self.partyTime leaveParty];

//    multiPeerConnection = ^(id response, BOOL state){
//      
//        [[[UIAlertView alloc] initWithTitle:@"DC"
//                                   message:@"Disconnected"
//                                  delegate:nil
//                         cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil, nil]show];
    [self performSelector:@selector(resetBlocks) withObject:nil afterDelay:0.5];
//       
//    };
}


-(void) messageSent{
    
    [ProgressHUD showSuccess:@"Sent" Interaction:YES];
    
    [self resetAllViewsContent];
    [self.partyTime leaveParty];

}

- (IBAction)sendData:(id)sender {
    
    [ProgressHUD show:@"Connecting" Interaction:NO];
    
    [self initMultiPeerConnectivity:^(id response, BOOL status) {
        [ProgressHUD show:@"Searching" Interaction:NO];
        NSLog(@"%@",response);
        
        if (status) {//Connected
            [self sendMessageRequestWithSuccess:^(id response, BOOL status) {
                NSLog(@"%@",response);
                [self performSelector:@selector(messageSent) withObject:nil afterDelay:0.5];

            } andFailed:^(NSError *error) {
            
                [[[UIAlertView alloc]initWithTitle:@"Please wait"
                                           message:error.userInfo[@"message"]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil, nil]show];
                [self performSelector:@selector(disconnectParty) withObject:nil afterDelay:1.0];
            }];

        }
    } failedToConnect:^(NSError *error) {
        [[[UIAlertView alloc]initWithTitle:@"Please wait"
                                   message:error.userInfo[@"message"]
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil, nil]show];
        [self performSelector:@selector(disconnectParty) withObject:nil afterDelay:1.0];

    }];
    
}

- (IBAction)backAction:(id)sender {
    [self.partyTime leaveParty];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark -


#pragma mark - Standard Life Cycle
-(void) initMultiPeerConnectivity:(SucessBlock)success failedToConnect:(FailureBlock)failBlock{

    self.partyTime = [PLPartyTime instance];
    self.partyTime.delegate = self;
    [self.partyTime joinRoom:self.gate withName:nil];
    multiPeerConnection = success;
    multiPeerConnectionFailure = failBlock;

}

-(void) initContentView{
//    Cleaner-Ruf zu Gate absetzen
    stationids = [NSMutableArray new];
    int startX = 0;
    int endX = 24;
    
    if([self.gate isEqualToString:@"B"]){
        startX = 25;
        endX = 47;
    }
    else if([self.gate isEqualToString:@"C"]){
        startX = 48;
        endX = 69;
    }

    for (int i = startX; i<=endX; i++) {
        [stationids addObject:[NSString stringWithFormat:@"%d",i]];
    }

    
    reasonsArr = @[@"Windschutzscheibe reinigen",
                   @"Fussmatten ersetzen",
                   @"Kratzer an Kotflügel",
                   @"Rückspiegel ist lose",
                   @"Reifendruck prüfen"];

    NSString *string = [[NSString alloc]initWithFormat:@"Cleaner-Ruf zu Gate %@ absetzen",self.gate];
    NSMutableAttributedString *stringAtt = [[NSMutableAttributedString alloc]initWithString:string];
//    [stringAtt addColor:[UIColor colorWithRed:39/255.0 green:194.0/255.0 blue:225.0 alpha:1.0] substring:[NSString stringWithFormat:@"%@ ",self.gate]];
//    [stringAtt addFont:[UIFont AppFontWithType:FontType_Medium andSize:lblHeader.font.pointSize+40] substring:[NSString stringWithFormat:@"%@ ",self.gate]];

    [lblHeader setAttributedText:stringAtt];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myKeyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:self];
}


-(void) viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:self];
    
    [super viewWillDisappear:animated];
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
        if (IS_IPAD()) {
            NSLog(@"stopAcceptingGuests");
            [partyTime stopAcceptingGuests];
        }
        multiPeerConnection(@"Connected",YES);
    }
    else if (state == MCSessionStateConnecting){
        NSLog(@"connecting to %@", peer.displayName);
        //multiPeerConnection(@"Connecting",NO);
    }
    else
    {
        NSLog(@"Peer disconnected: %@", peer.displayName);
        multiPeerConnection(@"Disconnected",NO);
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
    
    multiPeerConnectionFailure (error);
}


#pragma mark - TEXT FIELD
- (void) myKeyboardWillHideHandler:(NSNotification *)notification {

    if ([tfCustomMsg isFirstResponder]) {
        [self animateTextField:tfCustomMsg up:NO];
    }
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 999) {
        return;
    }
    [self animateTextField:textField up:YES];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField.tag != 999) {
        [self animateTextField:textField up:NO];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}



- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    float animatedDis = -(textField.superview.frame.origin.y);
    CGPoint temp = [textField.superview convertPoint:textField.frame.origin toView:nil];
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait){

        int moveUpValue = temp.y+textField.frame.size.height;
        if(up) {
            animatedDis = 264-(1004-moveUpValue-35);
        }
    }
    else if(orientation == UIInterfaceOrientationPortraitUpsideDown) {
        int moveUpValue = 1004-temp.y+textField.frame.size.height;
        if(up) {
            animatedDis = 264-(1004-moveUpValue-5);
        }
    }
    else if(orientation == UIInterfaceOrientationLandscapeLeft) {
        int moveUpValue = temp.x+textField.frame.size.height;
        if(up) {
            animatedDis = 352-(768-moveUpValue-5);
        }
    }
    else
    {
        int moveUpValue = 768-temp.x+textField.frame.size.height;
        if(up) {
            animatedDis = 352-(768-moveUpValue-5);
        }
        
    }
//    if(animatedDis>0)
    {
        const int movementDistance = animatedDis;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        if (orientation == UIInterfaceOrientationPortrait){
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        }
        else if(orientation == UIInterfaceOrientationPortraitUpsideDown) {
            
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        }
        else if(orientation == UIInterfaceOrientationLandscapeLeft) {
            
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        }
        else {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        }
        
        [UIView commitAnimations];
    }
}


@end
