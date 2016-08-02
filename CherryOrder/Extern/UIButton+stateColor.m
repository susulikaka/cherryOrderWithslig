//
//  UIButton+stateColor.m
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "UIButton+stateColor.h"

@implementation UIButton (stateColor)

+ (UIImage *)imageWithcolor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithcolor:backgroundColor] forState:state];
}

@end
