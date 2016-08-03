//
//  LKUOUtils.m
//  CherryOrder
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKUOUtils.h"

@implementation LKUOUtils

+ (void)showProgressDialog:(NSString *)title {
    [SVProgressHUD showWithStatus:title maskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismissProgressDialog {
    [SVProgressHUD dismiss];
}

+ (void)showToast:(NSString *)title {
    [SVProgressHUD showSuccessWithStatus:title];
}

+ (void)showError:(NSString *)errorMessage {
    [SVProgressHUD showErrorWithStatus:errorMessage];
}

@end
