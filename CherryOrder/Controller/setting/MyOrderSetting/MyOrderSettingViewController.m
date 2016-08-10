//
//  MyOrderSettingViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "MyOrderSettingViewController.h"
#import "SZCalendarPicker.h"

@interface MyOrderSettingViewController ()

@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong)SZCalendarPicker * calendarPicker;

@property (weak, nonatomic) IBOutlet UIButton *noOrderBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initInterface];
}

- (void)initInterface {
    self.calendarPicker = [SZCalendarPicker showOnView:self.view];
    self.calendarPicker.canSelected = YES;
    self.calendarPicker.today = [NSDate date];
    self.calendarPicker.date = self.calendarPicker.today;
    CGFloat statHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.calendarPicker.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height+statHeight,
                                           self.view.frame.size.width, self.view.frame.size.height * 0.618);
    self.calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        
    };
    
    self.noOrderBtn.backgroundColor = MAIN_COLOR;
    self.orderBtn.backgroundColor = MAIN_COLOR;
    self.noOrderBtn.layer.cornerRadius = 5;
    self.noOrderBtn.layer.masksToBounds = YES;
    self.orderBtn.layer.cornerRadius = 5;
    self.orderBtn.layer.masksToBounds = YES;
}

#pragma mark - action

- (IBAction)noOrderAction:(id)sender {

}

- (IBAction)orderAction:(id)sender {

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
