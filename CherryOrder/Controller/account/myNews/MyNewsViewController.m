//
//  MyNewsViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "MyNewsViewController.h"

@interface MyNewsViewController ()

@end

@implementation MyNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
