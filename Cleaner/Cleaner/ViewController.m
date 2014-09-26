//
//  ViewController.m
//  Cleaner
//
//  Created by Muhammad Rashid on 24/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionManager.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ViewController () <ConnectionManagerDelegate>
{
    ConnectionManager *manager;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UIButton *messageutton;
    __weak IBOutlet UILabel *peernameLabel;
}
@end

@implementation ViewController


#pragma mark - Init Process

-(void) initProcess{
 
    if ( IS_IPAD()) {
        [manager startBrowsingWithDelegate:self];
    }
    else{
        [manager connectWithDelegate:self withType:ConnectionTypeAdvertiser];
    }
}

#pragma mark - XCODE Standard Methods



- (void)viewDidLoad
{
    [super viewDidLoad];

    manager = [ConnectionManager sharedConnectionManager];

    [self performSelector:@selector(initProcess) withObject:nil afterDelay:3.0];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ACTIONS

- (IBAction)didStartAdvertising:(id)sender {
    
}

- (IBAction)browse:(id)sender {
    
}

#pragma mark - Delegate methods
- (void)willConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    messageutton.enabled = YES;
    
    MCSessionState state = [stateDic[@"state"] integerValue];
    
    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
        peernameLabel.text = peer.displayName;
    }
}

- (void)didConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    messageutton.enabled = YES;
    
    MCSessionState state = [stateDic[@"state"] integerValue];
    
    if (state == MCSessionStateConnected) {
        MCPeerID *peer = stateDic[@"peerID"];
        peernameLabel.text = peer.displayName;
    }
}

- (void)connectionManager:(id)connectionManager receivedString:(NSString *)received {
    
    if ([received hasPrefix:@"IGNORE"]) {
        return;
    }
    
    
    messageLabel.text = [NSString stringWithFormat:@"%@ \n %@",messageLabel.text ,received];
    
    if (!-IS_IPAD()) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:received delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [manager sendMessage:@"ok. I have recieved your message"];
}

- (IBAction)sendMessage:(id)sender {
    
    [manager sendMessage:@"Hello this is test message."];
}

@end
