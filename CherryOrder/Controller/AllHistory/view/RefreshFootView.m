//
//  RefreshFootView.m
//  CherryOrder
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "RefreshFootView.h"

@implementation RefreshFootView

- (void)awakeFromNib {
    self.msgLabel.textColor = LK_BACK_COLOR_LIGHT_GRAY;
    self.msgLabel.text = @"没有更多数据啦...";
}

- (void)setMsgName:(NSString *)name {
    self.msgLabel.text = name;
}

@end
