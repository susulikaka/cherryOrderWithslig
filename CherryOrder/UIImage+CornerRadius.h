//
//  UIImage+CornerRadius.h
//  CherryOrder
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
+ (UIImage*)imageAddCornerWithRadius:(CGFloat)radius andSize:(CGSize)size fileMode:(CGPathDrawingMode)mode;

@end
