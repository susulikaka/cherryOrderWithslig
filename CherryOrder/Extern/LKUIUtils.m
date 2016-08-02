//
//  LKUIUtils.m
//  lukou
//
//  Created by ZHAOYU on 15/7/24.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "LKUIUtils.h"

//#import "RCTBridgeModule.h"
#import "LKDropdownAlert.h"
#import "SVProgressHUD.h"
#import "PureLayout.h"
#import "ColorConstants.h"

//@interface LKUIUtils () <RCTBridgeModule>
@interface LKUIUtils ()

@end

@implementation LKUIUtils

//RCT_EXPORT_MODULE()

+ (void)showDropdownAlert:(NSString *)title {
    [LKDropdownAlert title:title time:3];
}

+ (void)showDropdownSuccess:(NSString *)title {
    [LKDropdownAlert title:title
           backgroundColor:LK_COLOR_GREEN
                 textColor:[UIColor whiteColor]
                      time:3];
}

+ (void)showDropdownAlert:(NSString *)title
                  message:(NSString *)message
                 delegate:(id<RKDropdownAlertDelegate>)delegate {
    [LKDropdownAlert title:title
                   message:message
                      time:5
                  delegate:delegate];
}

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

+ (void)playPraiseAnimationWithPraiseButton:(UIButton *)praiseButton {
    if (!praiseButton.selected) {
        CGRect originalFrame = [praiseButton convertRect:praiseButton.imageView.frame toView:AppDelegate.window];
        CGSize originalSize = originalFrame.size;
        CGPoint originalPoint = originalFrame.origin;
        UIImageView *animationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_praise_selected"]];
        animationImageView.frame = originalFrame;
        [AppDelegate.window addSubview:animationImageView];
        [UIView animateWithDuration:0.5
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [animationImageView setFrame:CGRectMake(originalPoint.x - originalSize.width,
                                                                     originalPoint.y - originalSize.height * 3,
                                                                     originalSize.width * 3,
                                                                     originalSize.height * 3)];
                             animationImageView.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [animationImageView removeFromSuperview];
                             }
                         }];
    }
}

+ (UIView *)headerViewWithIcon:(UIImage *)icon
                         title:(NSString *)title
                 hasBottomLine:(BOOL)hasBottomLine {
    UIView *headerView = [[UIView alloc] init];
    [self configHeaderView:headerView
                  withIcon:icon
                     title:title
             hasBottomLine:hasBottomLine];
    return headerView;
}

+ (UIView *)headerViewWithIcon:(UIImage *)icon
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                 hasBottomLine:(BOOL)hasBottomLine {
    UIView *headerView = [[UIView alloc] init];
    [self configHeaderView:headerView
                  withIcon:icon
                     title:title
                  subTitle:subTitle
             hasBottomLine:hasBottomLine
             hasEnterArrow:NO];
    return headerView;
}

+ (void)configHeaderView:(UIView *)headerView
                withIcon:(UIImage *)icon
                   title:(NSString *)title
           hasBottomLine:(BOOL)hasBottomLine {
    [self configHeaderView:headerView
                  withIcon:icon
                     title:title
                  subTitle:nil
             hasBottomLine:hasBottomLine
             hasEnterArrow:NO];
}

+ (void)configHeaderView:(UIView *)headerView
                withIcon:(UIImage *)icon
                   title:(NSString *)title
                subTitle:(NSString *)subTitle
           hasBottomLine:(BOOL)hasBottomLine
           hasEnterArrow:(BOOL)hasEnterArrow {
    
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView removeAllSubViews];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = LK_COLOR_BLACK_MINOR;
    label.text = title;
    [headerView addSubview:label];
    [label autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [label autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    if (icon) {
        UIImageView *headerIcon = [[UIImageView alloc] init];
        headerIcon.contentMode = UIViewContentModeCenter;
        headerIcon.image = icon;
        [headerView addSubview:headerIcon];
        [headerIcon autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, PADDING, 0, 0)
                                             excludingEdge:ALEdgeRight];
        [headerIcon autoSetDimension:ALDimensionWidth toSize:18.f];
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:headerIcon withOffset:PADDING_4];
    } else {
        label.textColor = UIColorFromRGB(0x999999);
        headerView.backgroundColor = [UIColor clearColor];
        [label autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:PADDING];
    }
    
    if (subTitle) {
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightButton setTitleColor:UIColorFromRGB(0xb5b5b5) forState:UIControlStateNormal];
        [rightButton setTitle:subTitle forState:UIControlStateNormal];
        rightButton.userInteractionEnabled = NO;
        rightButton.tag = 1;
        [headerView addSubview:rightButton];
        if (hasEnterArrow) {
            rightButton.userInteractionEnabled = YES;
            [rightButton setImage:[UIImage imageNamed:@"icon_arrow"] forState:UIControlStateNormal];
            rightButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            rightButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
            rightButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        }
        [rightButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, PADDING)
                                              excludingEdge:ALEdgeLeft];
    }
    
    if (hasBottomLine) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [headerView addSubview:bottomLine];
        [bottomLine autoSetDimension:ALDimensionHeight toSize:PX_1];
        [bottomLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                             excludingEdge:ALEdgeTop];
    }
}

+ (void)configGroupFollowButton:(UIButton *)button {
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"＋关注" forState:UIControlStateNormal];
    button.layer.borderColor = LK_COLOR_RED.CGColor;
    button.layer.borderWidth = PX_2;
    button.layer.cornerRadius = 3;
    [button setTitleColor:LK_COLOR_RED forState:UIControlStateNormal];
    [button setTitleColor:LK_COLOR_RED_HIGHLIGHT
                            forState:UIControlStateHighlighted];
}

+ (void)configGroupUnFollowButton:(UIButton *)button {
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"已关注" forState:UIControlStateNormal];
    [button setTitleColor:UNFOLLOWTEXTCOLOR forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x999999)
                            forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = UNFOLLOWTEXTCOLOR.CGColor;
    button.layer.borderWidth = PX_2;
    button.layer.cornerRadius = 3;
}

+ (void)configUserFollowButton:(UIButton *)button {
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"＋关注" forState:UIControlStateNormal];
    button.layer.borderColor = LK_COLOR_RED.CGColor;
    button.layer.borderWidth = PX_2;
    button.layer.cornerRadius = 3;
    [button setTitleColor:LK_COLOR_RED forState:UIControlStateNormal];
    [button setTitleColor:LK_COLOR_RED_HIGHLIGHT
                 forState:UIControlStateHighlighted];
}

+ (void)configUserUnFollowButton:(UIButton *)button {
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [button setTitle:@"已关注" forState:UIControlStateNormal];
    [button setTitleColor:UNFOLLOWTEXTCOLOR forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x999999)
                 forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderColor = UNFOLLOWTEXTCOLOR.CGColor;
    button.layer.borderWidth = PX_2;
    button.layer.cornerRadius = 3;
}

+ (void)configPrimaryButton:(UIButton *)button {
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = LK_COLOR_RED;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
}

RCT_EXPORT_METHOD(showProgressDialog:(NSString *)title) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.class showProgressDialog:title];
    });
}

RCT_EXPORT_METHOD(dismissProgressDialog) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.class dismissProgressDialog];
    });
}

RCT_EXPORT_METHOD(showToast:(NSString *)title) {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.class showToast:title];
    });
}

@end
