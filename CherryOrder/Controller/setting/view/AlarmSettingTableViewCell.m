//
//  AlarmSettingTableViewCell.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AlarmSettingTableViewCell.h"

@implementation AlarmSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.switchView.onTintColor = MAIN_COLOR;
}

- (IBAction)alarmSettingAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"alarmNoti" object:nil userInfo:@{@"on":@(self.switchView.on)}];
}


@end
