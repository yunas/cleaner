//
//  UIColour+Cleaner.m
//  Cleaner
//
//  Created by Muhammad Rashid on 06/11/2014.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "UIColor+Cleaner.h"

@implementation UIColor (Cleaner)

+ (UIColor*) CleanerBorderColourForGate:(NSString*)gate {
    
    UIColor *color = [UIColor colorWithRed:223/255.0 green:233/255.0 blue:68/255.0 alpha:1.0];
    
    if ([gate isEqualToString:@"B"]) {
        color = [UIColor colorWithRed:39/255.0 green:194/255.0 blue:225/255.0 alpha:1.0];
    }
    else if ([gate isEqualToString:@"C"]) {
        color = [UIColor colorWithRed:1.0 green:138/255.0 blue:143/255.0 alpha:1.0];
    }
    
    return color;
}
@end
