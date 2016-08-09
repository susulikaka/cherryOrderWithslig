//
//  SZCalendarCell.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSBustomBtn.h"

typedef void(^tapBtnBlock)();

@interface SZCalendarCell : UICollectionViewCell

@property (nonatomic , strong) UILabel *dateLabel;
@property (nonatomic, strong) SSBustomBtn * dateBtn;
@property (nonatomic, copy) tapBtnBlock tapBlock;

@end
