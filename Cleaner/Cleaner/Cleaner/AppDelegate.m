//
//  AppDelegate.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "AppDelegate.h"
#import "PLPartyTime.h"
#import "AppSettings.h"
#import "CleanerDetailController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


#pragma mark - FOR EVER RUNNING METHODS
-(void) testBackground:(float)sec{
    
//    SingletonClass *instance = [SingletonClass instance];
//    [instance generateNotificationWithText:@"Running in background" after:sec];
    [[PLPartyTime instance] stayAlive];
}

-(void) startMonitoringBackgroundTask{
    background = YES;
    [self startBackgroundTask];
}

- (void)startBackgroundTask
{
    NSLog(@"Restarting task");
    
    // Start the long-running task.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // When the job expires it still keeps running since we never exited it. Thus have the expiration handler
        // set a flag that the job expired and use that to exit the while loop and end the task.
        
        NSLog(@"Outside loop");
        NSLog(@"BACKGROUND => %d",background);
        NSLog(@"JOB EXPIRED => %d",jobExpired);
        
        while(background && !jobExpired)
        {
            NSLog(@"Background process");
            NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
            
            float sec = 1;
            [self testBackground:sec];
            [NSThread sleepForTimeInterval:sec];
        }
        jobExpired = NO;
    });
}

#pragma mark - 
-(void) askForPermissions:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    application.applicationIconBadgeNumber = 0;
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    

}

-(void) keepAppAliveForEver{
    
    if(IS_IPAD()){
        return;
    }
    
    UIApplication* app = [UIApplication sharedApplication];
    
    expirationHandler = ^{
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
        NSLog(@"Expired");
        jobExpired = YES;
        while(jobExpired) {
            // spin while we wait for the task to actually end.
            [NSThread sleepForTimeInterval:1];
        }
        // Restart the background task so we can run forever.
        [self startMonitoringBackgroundTask];
    };
    bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    
    // Assume that we're in background at first since we get no notification from device that we're in background when
    // app launches immediately into background (i.e. when powering on the device or when the app is killed and restarted)
    [self startMonitoringBackgroundTask];
}


#pragma mark - STANDARD METHODS
-(void) setRootController{
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    if(IS_IPAD())return;

    AppSettings *appSettings = [AppSettings loadAppSettings];
    if(![appSettings isfirstLaunch]){
        UIStoryboard *MainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        CleanerDetailController *cdController =[MainStoryboard instantiateViewControllerWithIdentifier:@"CleanerDetailController"];
        [cdController setGate: appSettings.userSelectedGate];
        self.window.rootViewController=cdController;
    }


}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self askForPermissions:application didFinishLaunchingWithOptions:launchOptions];
    [self keepAppAliveForEver];
    [self setRootController];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    if (IS_IPAD())return;

    [self startMonitoringBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0;
        application.idleTimerDisabled = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"App is active");
    background = NO;
    application.idleTimerDisabled = YES;

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PLPartyTime instance] leaveParty];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    
    // Request to reload table view data
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

@end
