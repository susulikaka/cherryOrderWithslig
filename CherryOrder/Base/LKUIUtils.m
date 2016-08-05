//
//  LKUOUtils.m
//  CherryOrder
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKUIUtils.h"

@implementation LKUIUtils

+ (void)showProgressDialog:(NSString *)title {
    [SVProgressHUD showWithStatus:title maskType:SVProgressHUDMaskTypeClear];
    SVProgressHUD.minimumDismissTimeInterval = 0.5;
}

+ (void)dismissProgressDialog {
    [SVProgressHUD dismiss];
    SVProgressHUD.minimumDismissTimeInterval = 0.5;
}

+ (void)showToast:(NSString *)title {
    [SVProgressHUD showSuccessWithStatus:title];
    SVProgressHUD.minimumDismissTimeInterval = 0.5;
}

+ (void)showError:(NSString *)errorMessage {
    [SVProgressHUD showErrorWithStatus:errorMessage];
    SVProgressHUD.minimumDismissTimeInterval = 0.5;
}

@end
