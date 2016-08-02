//
//  UIView+Nib.m
//  lukou
//
//  Created by ZHAOYU on 15/8/15.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass(self) bundle:nil];
}

+ (instancetype)viewFromNib {
    return [[[self nib] instantiateWithOwner:self options:nil] firstObject];
}

@end
