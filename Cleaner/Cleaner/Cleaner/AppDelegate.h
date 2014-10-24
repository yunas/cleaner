//
//  AppDelegate.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier bgTask;
    dispatch_block_t expirationHandler;
    BOOL background;
    BOOL jobExpired;
}
@property (strong, nonatomic) UIWindow *window;


@end

