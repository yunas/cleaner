//
//  JobQueue.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/16/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MCPeerID;

@interface JobQueue : NSObject

+ (JobQueue*)sharedInstance;


-(void) enqueueJob:(NSData*)data forPeer:(MCPeerID*)peerId;
-(NSDictionary*) dequeueJob;
-(NSDictionary*) peek;
-(BOOL) isEmpty;
-(void) emptyQueue;


@end
