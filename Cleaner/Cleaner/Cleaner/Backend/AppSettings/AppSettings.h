//
//  IOUtility.h
//  IFFT2014
//
//  Created by Yunas Qazi on 3/25/14.
//  Copyright (c) 2014 AppsFoundry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject<NSCoding>

@property (nonatomic, assign) BOOL isfirstLaunch;
@property (nonatomic, strong) NSString* userSelectedGate;

+(AppSettings *) loadAppSettings;
-(void)saveTheAppSetting;

@end
