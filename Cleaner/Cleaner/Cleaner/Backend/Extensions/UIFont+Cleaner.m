//
//  UIFont+Cleaner.m
//  Cleaner
//
//  Created by Yunas Qazi on 10/14/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "UIFont+Cleaner.h"

#define kCleanerFont_Agenda_Bold            @"Agenda-Bold"
#define kCleanerFont_Agenda_BoldCondensed   @"Agenda-BoldCondensed"
#define kCleanerFont_Agenda_Medium          @"Agenda-Medium"
#define kCleanerFont_Agenda_MediumCondensed @"Agenda-MediumCondensed"

@implementation UIFont (Cleaner)

+(UIFont*) AppFontWithType:(FontType)type andSize:(float)size{
 
    UIFont *font = [UIFont fontWithName:kCleanerFont_Agenda_Bold size:size];
    if (type == FontType_BoldCondensed){
        font = [UIFont fontWithName:kCleanerFont_Agenda_BoldCondensed size:size];
    }
    else if (type == FontType_Medium)
    {
        font = [UIFont fontWithName:kCleanerFont_Agenda_Medium size:size];
    }
    else if (type == FontType_MediumCondensed)
    {
        font = [UIFont fontWithName:kCleanerFont_Agenda_MediumCondensed size:size];
    }

    return font;
}

@end
