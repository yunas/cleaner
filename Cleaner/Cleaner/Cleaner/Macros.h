//
//  Macros.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#ifndef Cleaner_Macros_h
#define Cleaner_Macros_h

#ifdef UI_USER_INTERFACE_IDIOM//()
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif


#endif
