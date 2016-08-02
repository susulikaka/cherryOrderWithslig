//
//  LKUIUtils.h
//  lukou
//
//  Created by ZHAOYU on 15/7/24.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "LKDropdownAlert.h"

@interface LKUIUtils : NSObject

+ (void)showDropdownAlert:(NSString *)title;
+ (void)showDropdownAlert:(NSString *)title message:(NSString *)message
                 delegate:(id<RKDropdownAlertDelegate>)delegate;
+ (void)showDropdownSuccess:(NSString *)title;
+ (void)showProgressDialog:(NSString *)title;
+ (void)dismissProgressDialog;
+ (void)showToast:(NSString *)title;
+ (void)showError:(NSString *)errorMessage;

+ (void)playPraiseAnimationWithPraiseButton:(UIButton *)praiseButton;

+ (UIView *)headerViewWithIcon:(UIImage *)icon
                         title:(NSString *)title
                 hasBottomLine:(BOOL)hasBottomLine;

+ (UIView *)headerViewWithIcon:(UIImage *)icon
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                 hasBottomLine:(BOOL)hasBottomLine;

+ (void)configHeaderView:(UIView *)headerView
                withIcon:(UIImage *)icon
                   title:(NSString *)title
           hasBottomLine:(BOOL)hasBottomLine;

+ (void)configHeaderView:(UIView *)headerView
                withIcon:(UIImage *)icon
                   title:(NSString *)title
                   subTitle:(NSString *)subTitle
           hasBottomLine:(BOOL)hasBottomLine
           hasEnterArrow:(BOOL)hasEnterArrow;

+ (void)configGroupFollowButton:(UIButton *)button;

+ (void)configGroupUnFollowButton:(UIButton *)button;

+ (void)configUserFollowButton:(UIButton *)button;

+ (void)configUserUnFollowButton:(UIButton *)button;

+ (void)configPrimaryButton:(UIButton *)button;

@end
