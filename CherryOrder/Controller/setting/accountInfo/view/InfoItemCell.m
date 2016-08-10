//
//  InfoItemCell.m
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "InfoItemCell.h"

@implementation InfoItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.aTitleLabel.textColor = LK_TEXT_COLOR_GRAY;
    self.aDetailLabel.textColor = LK_TEXT_COLOR_GRAY;
}

@end
