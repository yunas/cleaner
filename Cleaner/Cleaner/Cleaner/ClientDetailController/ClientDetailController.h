//
//  ClientDetailController.h
//  Cleaner
//
//  Created by Yunas Qazi on 10/13/14.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientDetailController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) NSString *gate;

@end
