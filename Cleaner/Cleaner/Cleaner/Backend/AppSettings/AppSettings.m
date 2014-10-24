//
//  IOUtility.h
//  IFFT2014
//
//  Created by Yunas Qazi on 3/25/14.
//  Copyright (c) 2014 AppsFoundry. All rights reserved.
//


#import "AppSettings.h"


@implementation AppSettings

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.isfirstLaunch  =   [decoder decodeBoolForKey:@"isfirstLaunch"];
        self.userSelectedGate = [decoder decodeObjectForKey:@"userSelectedGate"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeBool:self.isfirstLaunch forKey:@"isfirstLaunch"];
    [encoder encodeObject:self.userSelectedGate forKey:@"userSelectedGate"];
    
}


+(AppSettings *) loadAppSettings{

    NSData *archivedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppSettings"];
    
    if (archivedObject)
        return (AppSettings *)[NSKeyedUnarchiver unarchiveObjectWithData: archivedObject];
    else{
        
        AppSettings *appSettings = [AppSettings new];
        appSettings.isfirstLaunch = YES;
        appSettings.userSelectedGate = @"";
        return appSettings;
    }
}

-(void)saveTheAppSetting{
    
    NSData *archivedObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:archivedObject forKey:@"AppSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

@end
