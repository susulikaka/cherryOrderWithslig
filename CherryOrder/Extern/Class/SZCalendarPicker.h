//
//  SZCalendarPicker.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, strong) NSArray *orderDataArr;
@property (nonatomic , weak, readonly) UICollectionView *collectionView;
@property (nonatomic , weak, readonly) UIButton *previousButton;
@property (nonatomic , weak, readonly) UIButton *nextButton;
@property (nonatomic , weak, readonly) UILabel *monthLabel;
@property (nonatomic, assign) BOOL canSelected;// if = 1:btn.enable=1; if = 0:btn.enable=0
@property (weak, nonatomic) IBOutlet UIButton *orderHistory;
@property (weak, nonatomic) IBOutlet UIButton *feeHistory;


+ (instancetype)showOnView:(UIView *)view;
- (void)hide;

- (void)refreshViewWIthOrderDataArr:(NSArray *)orderDataArr;

@end
