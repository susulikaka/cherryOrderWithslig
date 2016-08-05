//
//  PersonalHistoryViewController.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "PersonalHistoryViewController.h"
#import "SZCalendarPicker.h"
#import "ReactiveCocoa.h"
#import "UserHistory.h"

@interface PersonalHistoryViewController ()

@property (nonatomic, strong)SZCalendarPicker *calendarPicker;
@property (nonatomic, strong)NSMutableArray *orderHistoryArr;
@end

@implementation PersonalHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"点餐历史";
    [self initInterface];
    [self requestDate];
}

- (void) requestDate {
    [[LKAPIClient sharedClient] requestGETForOrderListHistoryOneMonth:@"user/orders"
                                                               params:[self paramsWithCurDateFromOne:0]
                                                           modelClass:[UserHistory class]
                                                    completionHandler:^(LKJSonModel *aModelBaseObject) {
        UserHistory * dic;
        if ([aModelBaseObject isKindOfClass:[UserHistory class]]) {
            dic = (UserHistory *)aModelBaseObject;
        }
        self.orderHistoryArr = [[self getOrderDataArr:dic.list] mutableCopy];
        self.calendarPicker = [SZCalendarPicker showOnView:self.view];
        [self.calendarPicker refreshViewWIthOrderDataArr:self.orderHistoryArr];
        
        
        self.calendarPicker.today = [NSDate date];
        self.calendarPicker.date = self.calendarPicker.today;
        CGFloat statHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.calendarPicker.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+statHeight,
                                               self.view.frame.size.width, self.view.frame.size.height * 0.618);
        self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        };
    } errorHandler:^(LKAPIError *engineError) {
        self.calendarPicker = [SZCalendarPicker showOnView:self.view];
        [self.calendarPicker refreshViewWIthOrderDataArr:self.orderHistoryArr];
        
        self.calendarPicker.today = [NSDate date];
        self.calendarPicker.date = self.calendarPicker.today;
        CGFloat statHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.calendarPicker.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+statHeight,
                                               self.view.frame.size.width, self.view.frame.size.height * 0.618);
        self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        };
        [LKUIUtils showError:engineError.message];
        
    }];
}

- (void)initInterface {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"这个月"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(backToToday)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (NSDictionary *)paramsWithCurDateFromOne:(NSInteger)monthChange {
    NSString * oldMonthStr;
    if (self.calendarPicker.monthLabel.text.length == 0) {
        oldMonthStr = [self getCurTimeStrFomeOne];
    } else {
        oldMonthStr = self.calendarPicker.monthLabel.text;
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

- (NSString *)getCurTimeStrFomeOne {
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString * str = [formatter stringFromDate:date];
    NSString * resultStr = [str stringByAppendingString:@"-01"];
    return resultStr;
}

#pragma mark - action

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self.calendarPicker hide];
}

- (void)backToToday {
    self.calendarPicker.today = [NSDate date];
    [self requestDate];
}

@end
