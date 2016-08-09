//
//  photoGridCell.m
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "photoGridCell.h"

@implementation photoGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = MAIN_COLOR.CGColor;
    self.layer.borderWidth = 1;
    [self.checkBtn setImage:[UIImage imageNamed:@"icon_check_gray_bordered"] forState:UIControlStateNormal];
    [self.checkBtn setImage:[UIImage imageNamed:@"icon_check_blue_bordered"] forState:UIControlStateSelected];
}

@end
