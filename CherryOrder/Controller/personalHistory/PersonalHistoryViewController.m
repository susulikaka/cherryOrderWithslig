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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.calendarPicker hide];
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
        self.calendarPicker.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.width+70);
        self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        };
    } errorHandler:^(LKAPIError *engineError) {
        self.calendarPicker = [SZCalendarPicker showOnView:self.view];
        [self.calendarPicker refreshViewWIthOrderDataArr:self.orderHistoryArr];
        
        self.calendarPicker.today = [NSDate date];
        self.calendarPicker.date = self.calendarPicker.today;
        self.calendarPicker.frame = CGRectMake(0, 0,
                                               self.view.frame.size.width, self.view.frame.size.width+70);
        self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        };
        [LKUIUtils showError:engineError.message];
        
    }];
}

- (void)initInterface {
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search-btn"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(search)];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"本月"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(backToToday)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
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

- (void)search {
    
}

- (void)backToToday {
    self.calendarPicker.today = [NSDate date];
    [self requestDate];
}

@end
