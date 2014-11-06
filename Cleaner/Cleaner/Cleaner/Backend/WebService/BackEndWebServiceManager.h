//
//  BackEndWebServiceManager.h
//  Cleaner
//
//  Created by Muhammad Rashid on 06/11/2014.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACTION              @"action"
#define DATE                @"date"
#define AREA                @"area"
#define ALTERNATESPACE      @"stellplatz"
#define PLATE               @"plate"
#define TASK                @"aufgabe"
#define STATUS_IN           @"status"
#define STATUS_OUT          @"Status"

@interface BackEndWebServiceManager : NSObject

+ (instancetype)sharedManager;
- (void)uploadDataToBackEndServer:(NSDictionary*)data WithSuccess:(void (^)(NSDictionary *response))success
                          failure:(void (^)(NSError *error))fail;
@end
