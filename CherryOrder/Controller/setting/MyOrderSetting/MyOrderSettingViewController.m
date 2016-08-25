//
//  MyOrderSettingViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "MyOrderSettingViewController.h"
#import "SZCalendarPicker.h"
#import "OrderInfoViewController.h"

@interface MyOrderSettingViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong)SZCalendarPicker * calendarPicker;

@property (weak, nonatomic) IBOutlet UIButton *noOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (strong, nonatomic) NSMutableArray * selectedDate;

@end

@implementation MyOrderSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私人订制";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.selectedDate = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initInterface];
}

- (void)initInterface {
    self.calendarPicker = [SZCalendarPicker showOnView:self.view];
    self.calendarPicker.orderHistory.hidden = YES;
    self.calendarPicker.feeHistory.hidden = YES;
    self.calendarPicker.canSelected = YES;
    self.calendarPicker.today = [NSDate date];
    self.calendarPicker.date = self.calendarPicker.today;
    CGFloat statHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.calendarPicker.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+statHeight,
                                           self.view.frame.size.width, self.view.frame.size.height * 0.618);
    @weakify(self);
    self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        @strongify(self);
        NSString * timeStr = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
        NSLog(@"day--------%ld",day);
        [self.selectedDate addObject:timeStr];
    };
    
    self.noOrderBtn.backgroundColor = MAIN_COLOR;
    self.orderBtn.backgroundColor = MAIN_COLOR;
    self.noOrderBtn.layer.cornerRadius = 5;
    self.noOrderBtn.layer.masksToBounds = YES;
    self.orderBtn.layer.cornerRadius = 5;
    self.orderBtn.layer.masksToBounds = YES;
}

#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // to do
        NSLog(@"确定");
    }
}

#pragma mark - action

- (IBAction)noOrderAction:(id)sender {
    [self.selectedDate sortUsingSelector:@selector(compare:)];
    NSMutableString * msg = [NSMutableString stringWithString:@"不订餐的时间:\n"];
    NSString * str = [self.selectedDate componentsJoinedByString:@"\n"];
    [msg appendString:str];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请确认您选择的日期:" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.view addSubview:alert];
    [alert show];
}

- (IBAction)orderAction:(id)sender {
    [self.selectedDate sortUsingSelector:@selector(compare:)];
    NSMutableString * msg = [NSMutableString stringWithString:@"订餐的时间:\n"];
    NSString * str = [self.selectedDate componentsJoinedByString:@"\n"];
    [msg appendString:str];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"请确认您选择的日期:" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [self.view addSubview:alert];
    [alert show];
}


#pragma mark - private method

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
