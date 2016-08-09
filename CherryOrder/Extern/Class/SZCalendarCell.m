//
//  SZCalendarCell.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarCell.h"

@implementation SZCalendarCell

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.7,self.bounds.size.height * 0.7)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        _dateLabel.layer.cornerRadius = _dateLabel.frame.size.height/2;
        _dateLabel.layer.masksToBounds = YES;
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (SSBustomBtn *)dateBtn {
    if (!_dateBtn) {
        _dateBtn = ({
            SSBustomBtn * btn = [[SSBustomBtn alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.7,self.bounds.size.height * 0.7) title:@"" cordius:0 Type:0 tapBlock:^{
                self.tapBlock();
            }];
            [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:MAIN_COLOR forState:UIControlStateSelected];
            [self.contentView addSubview:btn];
//            [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _dateBtn;
}

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
