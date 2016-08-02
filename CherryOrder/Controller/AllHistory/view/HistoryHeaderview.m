//
//  historyHeaderview.m
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "HistoryHeaderview.h"

@interface HistoryHeaderview ()

@end

@implementation HistoryHeaderview

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = DARK_MAIN_COLOR;
    self.dateLabel.text = @"";
    self.countLabel.text = @"";
    self.dateLabel.textColor = [UIColor whiteColor];
    self.countLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.font = [UIFont systemFontOfSize:14];
}

@end
