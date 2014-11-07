//
//  UITextField+Cleaner.h
//  Cleaner
//
//  Created by Muhammad Rashid on 07/11/2014.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface MRTextField : UITextField
@property (nonatomic) IBInspectable CGFloat top, left, bottom, right;
@property (nonatomic, assign) IBInspectable UIEdgeInsets edgeInsets;
@end
