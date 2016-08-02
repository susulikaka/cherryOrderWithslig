//
//  UIButton+stateColor.h
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (stateColor)

+ (UIImage *)imageWithcolor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
