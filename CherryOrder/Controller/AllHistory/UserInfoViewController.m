//
//  UserInfoViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/16.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = self.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
