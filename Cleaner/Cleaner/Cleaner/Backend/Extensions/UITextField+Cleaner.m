//
//  UITextField+Cleaner.m
//  Cleaner
//
//  Created by Muhammad Rashid on 07/11/2014.
//  Copyright (c) 2014 metadesign. All rights reserved.
//

#import "UITextField+Cleaner.h"

@implementation MRTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
   
    if (self) {
        self.edgeInsets = UIEdgeInsetsZero;
        
        self.top = self.left = self.bottom = self.right = 0.0;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
   
    self = [super initWithFrame:frame];
    
    if (self) {
        self.edgeInsets = UIEdgeInsetsZero;
        self.top = self.left = self.bottom = self.right = 0.0;
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.top, self.left, self.bottom, self.right))];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.top, self.left, self.bottom, self.right))];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(self.top, self.left, self.bottom, self.right))];
}


@end
