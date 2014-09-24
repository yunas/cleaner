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

- (void)viewDidLoad
{
    [super viewDidLoad];

    manager = [ConnectionManager sharedConnectionManager];
    
    messageutton.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didStartAdvertising:(id)sender {
    [manager connectWithDelegate:self withType:ConnectionTypeAdvertiser];
}

- (IBAction)browse:(id)sender {
    [manager startBrowsingWithDelegate:self];
}

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
    messageLabel.text = received;
    
    if ([[UIDevice currentDevice].model isEqualToString:@"iPhone Simulator"] && ![received hasPrefix:@"IGNORE"]) {
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
