//
//  SZCalendarPicker.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarPicker.h"
#import "SZCalendarCell.h"
#import "UIColor+ZXLazy.h"
#import "UserHistory.h"
#import "ReactiveCocoa.h"
#import "NameSelView.h"

NSString *const SZCalendarCellIdentifier = @"cell";

@interface SZCalendarPicker ()
@property (nonatomic , weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic , weak) IBOutlet UILabel *monthLabel;
@property (nonatomic , weak) IBOutlet UIButton *previousButton;
@property (nonatomic , weak) IBOutlet UIButton *nextButton;
@property (nonatomic , strong) NSArray *weekDayArray;
@end

@implementation SZCalendarPicker

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self addTap];
    [self addSwipe];
    [self show];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[SZCalendarCell class] forCellWithReuseIdentifier:SZCalendarCellIdentifier];
    [_collectionView registerNib:[NameSelView nib] forCellWithReuseIdentifier:NSStringFromClass([NameSelView class])];
     _weekDayArray = @[@"S",@"M",@"T",@"W",@"T",@"F",@"S"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSelNoti:) name:@"addSelNoti" object:nil];
}

- (void)addSelNoti:(NSNotification *)noti {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSInteger day = [noti.userInfo[@"day"] integerValue];
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}

- (void)customInterface
{
    CGFloat itemWidth = _collectionView.frame.size.width / 7;
    CGFloat itemHeight = _collectionView.frame.size.height / 7;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    [_collectionView setCollectionViewLayout:layout animated:YES];
    
    [self.orderHistory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.feeHistory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.orderHistory setTitleEdgeInsets:UIEdgeInsetsMake(0, self.orderHistory.imageView.bounds.size.width, 0, 0)];
    [self.feeHistory setTitleEdgeInsets:UIEdgeInsetsMake(0, self.feeHistory.imageView.bounds.size.width, 0, 0)];
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%i-%.2d",[self year:date],[self month:date]]];
    [_collectionView reloadData];
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SZCalendarCellIdentifier forIndexPath:indexPath];

    if (indexPath.section == 0) {
        [cell.dateBtn setTitle:_weekDayArray[indexPath.row] forState:UIControlStateNormal];
        [cell.dateBtn setTitleColor:DARK_MAIN_COLOR forState:UIControlStateNormal];
        [cell.dateBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        NSInteger daysInThisMonth = [self totaldaysInMonth:_date];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_date];
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            [cell.dateBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.dateBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            [cell.dateBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.dateBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            day = i - firstWeekday + 1;
            if (day < 10) {
                [cell.dateBtn setTitle:[NSString stringWithFormat:@"0%ld",day] forState:UIControlStateNormal];
            } else {
                [cell.dateBtn setTitle:[NSString stringWithFormat:@"%ld",day] forState:UIControlStateNormal];
            }
            NSString * time = [self.monthLabel.text stringByAppendingString:[NSString stringWithFormat:@"-%@",cell.dateBtn.titleLabel.text]];
            NSInteger isEqual = [self.orderDataArr indexOfObject:time];
            if (isEqual >= 0 && isEqual < self.orderDataArr.count && cell.dateBtn.titleLabel.text.length>0) {
                [cell.dateBtn setTitleColor:[UIColor colorWithHexString:@"#cbcbcb"] forState:UIControlStateNormal];
                [cell.dateBtn setBackgroundColor:MAIN_COLOR forState:UIControlStateNormal];
            } else {
                [cell.dateBtn setTitleColor:[UIColor colorWithHexString:@"#cbcbcb"] forState:UIControlStateNormal];
                [cell.dateBtn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            //this month   4898eb:lv   6f6f6f:black cbcbcb :gray
            if ([_today isEqualToDate:_date]) {
                if (day == [self day:_date]) {
                    [cell.dateBtn setTitleColor:[UIColor colorWithHexString:@"#4898eb"] forState:UIControlStateNormal];
                } else if (day > [self day:_date]) {
                    [cell.dateBtn setTitleColor:[UIColor colorWithHexString:@"#6f6f6f"] forState:UIControlStateNormal];
                }
            } else if ([_today compare:_date] == NSOrderedAscending) {
                [cell.dateBtn setTitleColor:[UIColor colorWithHexString:@"#6f6f6f"] forState:UIControlStateNormal];
            }
        }
    }
    
    cell.dateBtn.enabled = self.canSelected;
    if (self.canSelected) {
        cell.dateBtn.selected = NO;
        NSString * time = [self.monthLabel.text stringByAppendingString:[NSString stringWithFormat:@"-%@",cell.dateBtn.titleLabel.text]];
        NSString * curStr = [self getCurTimeStr];
        if (indexPath.section == 1 && [time compare:curStr] > 0) {
            cell.dateBtn.enabled = YES;
        } else {
            cell.dateBtn.enabled = NO;
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZCalendarCell *cell = (SZCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!self.canSelected) {
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
        NSInteger day = [cell.dateBtn.titleLabel.text integerValue];
        if (self.calendarBlock) {
            self.calendarBlock(day, [comp month], [comp year]);
        }
    }
}

- (IBAction)previouseAction:(UIButton *)sender
{
    if (self.canSelected) {
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
            self.date = [self lastMonth:self.date];
        } completion:nil];
        return;
    }
    
    [[LKAPIClient sharedClient] requestGETForOrderListHistoryOneMonth:@"user/orders" params:[self paramsWithCurDate:-1] modelClass:[UserHistory class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        UserHistory * dic;
        if ([aModelBaseObject isKindOfClass:[UserHistory class]]) {
            dic = (UserHistory *)aModelBaseObject;
        }
        self.orderDataArr = [self getOrderDataArr:dic.list];
        [self refreshViewWIthOrderDataArr:self.orderDataArr];
        self.previousButton.selected = !self.previousButton.selected;
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
            self.date = [self lastMonth:self.date];
        } completion:nil];
    } errorHandler:^(LKAPIError *engineError) {
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
            self.date = [self lastMonth:self.date];
        } completion:nil];
    }];
}

- (IBAction)nexAction:(UIButton *)sender
{
    if (self.canSelected) {
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
            self.date = [self nextMonth:self.date];
        } completion:nil];
        return;
    }
    
    [[LKAPIClient sharedClient] requestGETForOrderListHistoryOneMonth:@"user/orders" params:[self paramsWithCurDate:1] modelClass:[UserHistory class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        UserHistory * dic;
        if ([aModelBaseObject isKindOfClass:[UserHistory class]]) {
            dic = (UserHistory *)aModelBaseObject;
        }
        self.orderDataArr = [self getOrderDataArr:dic.list];
        [self refreshViewWIthOrderDataArr:self.orderDataArr];
        self.nextButton.selected = !self.nextButton.selected;
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
            self.date = [self nextMonth:self.date];
        } completion:nil];
    } errorHandler:^(LKAPIError *engineError) {
        [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
            self.date = [self nextMonth:self.date];
        } completion:nil];
    }];
}

+ (instancetype)showOnView:(UIView *)view
{
    SZCalendarPicker *calendarPicker = [[[NSBundle mainBundle] loadNibNamed:@"SZCalendarPicker" owner:self options:nil] firstObject];
    [view addSubview:calendarPicker];
    return calendarPicker;
}

- (void)show
{
    [self customInterface];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (NSString *)date:(NSInteger)monthChange day:(NSInteger)day {
    NSString * oldMonthStr;
    if (self.monthLabel.text.length == 0) {
        oldMonthStr = [self getCurTimeStr];
    } else {
        oldMonthStr = self.monthLabel.text;
    }
    
    NSString * tureYear = [NSString stringWithFormat:@"%@",[oldMonthStr substringWithRange:NSMakeRange(0, 5)]];
    NSString * monthStr = [NSString stringWithFormat:@"%@",[oldMonthStr substringWithRange:NSMakeRange(5, 2)]];
    NSInteger monthInt = [monthStr integerValue];
    NSString * truemonth;
    if (monthInt + monthChange > 10) {
        truemonth = [NSString stringWithFormat:@"%ld",monthInt + monthChange];
    } else {
        truemonth = [NSString stringWithFormat:@"0%ld",monthInt + monthChange];
    }
    
    NSString *dayStr;
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%ld",day];
    } else {
        dayStr = [NSString stringWithFormat:@"%ld",day];
    }
    NSString * timeStr = [NSString stringWithFormat:@"%@%@-01",tureYear,truemonth];
    return timeStr;
}

- (NSDictionary *)paramsWithCurDate:(NSInteger)monthChange {
    NSString * oldMonthStr;
    if (self.monthLabel.text.length == 0) {
        oldMonthStr = [self getCurTimeStr];
    } else {
        oldMonthStr = self.monthLabel.text;
    }
    
    NSString * tureYear = [NSString stringWithFormat:@"%@",[oldMonthStr substringWithRange:NSMakeRange(0, 5)]];
    NSString * monthStr = [NSString stringWithFormat:@"%@",[oldMonthStr substringWithRange:NSMakeRange(5, 2)]];
    NSInteger monthInt = [monthStr integerValue];
    NSString * truemonth = [NSString stringWithFormat:@"%ld",monthInt + monthChange];
    NSString * timeStr = [NSString stringWithFormat:@"%@%@-01",tureYear,truemonth];
    
    LKUser * user = [[UserInfoManager sharedManager] getUserInfo];
    return @{@"date":timeStr,@"name":user.name};
    
}

- (NSArray *)getOrderDataArr:(NSArray *)arr {
    NSMutableArray * resultArr = [NSMutableArray array];
    for (NSDictionary * dic in arr) {
        [resultArr addObject:dic[@"date"]];
    }
    return resultArr;
}

- (NSString *)getCurTimeStr {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString * str = [formatter stringFromDate:date];
    return str;
}

- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

- (void)refreshViewWIthOrderDataArr:(NSArray *)orderDataArr {
    self.orderDataArr = orderDataArr;
    NSLog(@"------orderData : %@",self.orderDataArr);
    [_collectionView reloadData];
}

@end
