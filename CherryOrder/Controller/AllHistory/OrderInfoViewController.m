//
//  OrderInfoViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "UserOrderInfo.h"

@interface OrderInfoViewController ()

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订餐详情";
    
    [[LKAPIClient sharedClient] requestPOSTForGetUserInfo:@"order" params:self.dataDic modelClass:[UserOrderInfo class] completionHandler:^(LKJSonModel *aModelBaseObject) {
        
        UserOrderInfo * dic;
        if ([aModelBaseObject isKindOfClass:[UserOrderInfo class]]) {
            dic = (UserOrderInfo *)aModelBaseObject;
        }
        self.orderName.text = self.dataDic[@"name"];
        self.orderTime.text = self.dataDic[@"date"];
        self.helperName.text = dic.agent;
        
    } errorHandler:^(LKAPIError *engineError) {
        [LKUOUtils showError:engineError.message];
    }];
    
}

- (void)initInterface {
    self.orderName.textColor = LK_TEXT_COLOR_GRAY;
    self.orderTime.textColor = LK_TEXT_COLOR_GRAY;
    self.helperName.textColor = LK_TEXT_COLOR_GRAY;
}

@end
