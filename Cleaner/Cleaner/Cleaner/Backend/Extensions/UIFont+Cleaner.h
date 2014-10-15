//
//  UIFont+Cleaner.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/14/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    FontType_Bold,
    FontType_BoldCondensed,
    FontType_Medium,
    FontType_MediumCondensed,
}FontType;

@interface UIFont (Cleaner)

+(UIFont*) AppFontWithType:(FontType)type andSize:(float)size;

@end
