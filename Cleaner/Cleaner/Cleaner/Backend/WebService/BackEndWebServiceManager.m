//
//  BackEndWebServiceManager.m
//  Cleaner
//
//  Created by Muhammad Rashid on 06/11/2014.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "BackEndWebServiceManager.h"

static const NSString *baseURL = @"http://192.168.2.102/api/controller.php?";

@implementation BackEndWebServiceManager

+ (instancetype)sharedManager {
    
    static BackEndWebServiceManager *obj = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [BackEndWebServiceManager new];
    });
    
    return obj;
}

- (void)uploadDataToBackEndServer:(NSDictionary*)data WithSuccess:(void (^)(NSDictionary *response))success
                          failure:(void (^)(NSError *error))fail {
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@",baseURL];

    [urlString appendFormat:@"action=%@&area=%@&stellplatz=%@&plate=%@&aufgabe=%@&status=%@",
                                    data[ACTION],
                                    data[AREA],
                                    data[ALTERNATESPACE],
                                    data[PLATE],
                                    data[TASK],
                                    data[STATUS_IN]
    ];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data && !connectionError) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            success(dic);
        }
        else {
            fail(connectionError);
        }
    }];
}

@end
