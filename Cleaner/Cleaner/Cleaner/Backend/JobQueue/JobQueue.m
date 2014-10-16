//
//  JobQueue.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/16/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "JobQueue.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


static JobQueue *singletonInstance;


@interface JobQueue ()
{
    NSMutableArray *jobsArray;
}

@end

@implementation JobQueue

#pragma mark - Life Cycle
-(void) initContent{
    jobsArray = [NSMutableArray new];
}

+ (JobQueue*)sharedInstance{
    if(!singletonInstance)
    {
        singletonInstance=[[JobQueue alloc]init];
        [singletonInstance initContent];
    }
    return singletonInstance;
}

#pragma mark - PUBLIC METHODS
-(void) enqueueJob:(NSData*)data forPeer:(MCPeerID*)peerId{
    NSDictionary * dict = @{@"data":data, @"peerId":peerId};
    [jobsArray addObject:dict];
}

-(NSDictionary*) peek{
    if ([self isEmpty]) {
        return nil;
    }
    NSDictionary *dict = jobsArray[0];
    return dict;
}

-(NSDictionary*) dequeueJob{
    if ([self isEmpty]) {
        return nil;
    }
    NSDictionary *dict = jobsArray[0];
    [jobsArray removeObjectAtIndex:0];
    return dict;
}

-(BOOL) isEmpty{
    if (jobsArray.count) {
        return false;
    }
    return true;
}


@end
