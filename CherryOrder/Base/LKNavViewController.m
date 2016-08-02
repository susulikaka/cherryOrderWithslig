//
//  LKNavViewController.m
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKNavViewController.h"

@interface LKNavViewController ()

@end

@implementation LKNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - action

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
