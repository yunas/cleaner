//
//  ViewController.m
//  Cleaner
//
//  Created by Muhammad Rashid on 24/09/2014.
//  Copyright (c) 2014 Muhammad Rashid. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionManager.h"
#import "BorderButton.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVER_TAG  104
#define CLIENT_TAG  105


@interface ViewController () <ConnectionManagerDelegate>
{
    ConnectionManager *manager;
    
    
    __weak IBOutlet BorderButton *browseButton;
    __weak IBOutlet BorderButton *messageButton;
    __weak IBOutlet BorderButton *disconnectButton;
    
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UILabel *peerNameLabel;
    
    __weak IBOutlet UISwitch *availabilitySwitch;
    
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

- (void)setDefaultStatus
{
    if (IS_IPAD()) {
        peerNameLabel.text = @"Searching ...";
    }
    else {
        peerNameLabel.text = @"Listening ...";
    }
    
    messageLabel.text = @"";
    
    browseButton.enabled = YES;
    messageButton.enabled = NO;
    disconnectButton.hidden = YES;
    
}

- (void)setConnectedStatus:(NSString *)peerName {
    
    if (IS_IPAD()) {
        peerNameLabel.text = [NSString stringWithFormat:@"Connected With Cleaner: %@",peerName];
    }
    else {
        peerNameLabel.text = [NSString stringWithFormat:@"Connected With Client: %@",peerName];
    }
    
    browseButton.enabled = NO;
    messageButton.enabled = YES;
    disconnectButton.hidden = NO;
}

#pragma mark - XCODE Standard Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setDefaultStatus];

    manager = [ConnectionManager sharedConnectionManager];

    [self performSelector:@selector(initProcess) withObject:nil afterDelay:0.5];
    
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
    [manager startBrowsingWithDelegate:self];
}

#pragma mark - Delegate methods

- (void)willConntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    MCSessionState state = [stateDic[@"state"] integerValue];
    
    if (state == MCSessionStateConnected) {
        
        NSString *peerName = ((MCPeerID*)stateDic[@"peerID"]).displayName;

        [self performSelectorOnMainThread:@selector(setConnectedStatus:)
                               withObject:peerName
                            waitUntilDone:YES];
        
    }
}

- (void)didDisconntectedWithManager:(id)connectionManager status:(NSDictionary*)stateDic {
    
    
    [self performSelectorOnMainThread:@selector(setDefaultStatus)
                           withObject:nil
                        waitUntilDone:YES];
}

- (void)connectionManager:(id)connectionManager receivedString:(NSString *)received {
    
    if ([received hasPrefix:@"IGNORE"]) {
        return;
    }
    
    
    messageLabel.text = [NSString stringWithFormat:@"%@",received];
    
    if (!-IS_IPAD()) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Client Request"
                                                        message:received
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        alert.tag = SERVER_TAG;
        [alert show];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cleaner's Response"
                                                        message:received
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        alert.tag = CLIENT_TAG;
        [alert show];
        
        [manager disconnectWithServer];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==SERVER_TAG) {
        [manager sendMessage:@"Ok. The help is on the way."];
    }
}

- (IBAction)sendMessage:(id)sender {
    
    [manager sendMessage:@"Hello! I need help."];
}

- (IBAction)disconnect:(id)sender {
    
//    if (IS_IPAD()) {
//        [manager stopPeer2PeerService];
//    }
//    else {
//        [manager disconnectWithServer];
//    }
    
    [manager stopPeer2PeerService];
    
    if (!IS_IPAD()) {
        [self initProcess];
    }
}
- (IBAction)toggleAvailability:(UISwitch*)sender {
    
    if (sender.isOn) {
        [self initProcess];
    }
    else {
        [manager stopPeer2PeerService];
    }
}

@end
