//
//  LocalNotificationManager.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/22/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject

+(void) generateNotificationWithText:(NSString *) text after:(float)secs;

@end
