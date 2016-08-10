//
//  VotingForRestaurantViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "VotingForRestaurantViewController.h"

@interface VotingForRestaurantViewController ()

@end

@implementation VotingForRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我要投票";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
