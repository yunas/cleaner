//
//  LocalNotificationManager.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/22/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "LocalNotificationManager.h"
#import "AJNotificationView.h"
#import <UIKit/UIKit.h>

@implementation LocalNotificationManager


+(NSDate*) dateByAddingSecs:(float)secs{
    NSDate *mydate = [NSDate date];
    //    NSTimeInterval secs = secs;//8 * 60 * 60; => 8 hours
    NSDate *newDate = [mydate dateByAddingTimeInterval:secs];
    return newDate;
}

+(void) generateNotificationWithText:(NSString *) text after:(float)secs{
    
    if (IS_IPAD())return;
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                        type:AJNotificationTypeGreen
                                       title:text
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:1.5f];
    }
    else{
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [self dateByAddingSecs:secs];
        localNotification.alertBody = [NSString stringWithFormat:@" %@", text];
        localNotification.alertAction = @"Show me the item";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = 0;//[[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    
}

@end
