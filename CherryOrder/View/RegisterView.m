//
//  RegisterView.m
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "RegisterView.h"
#import "LKAPIClient.h"
#import "UserInfoManager.h"
#import "LKUser.h"

@interface RegisterView ()

@property (weak, nonatomic) IBOutlet UIImageView * backGroudImg;
@property (weak, nonatomic) IBOutlet UITextField * mailText;
@property (weak, nonatomic) IBOutlet UITextField * nameText;
@property (weak, nonatomic) IBOutlet UIButton    * doneBtn;
@property (weak, nonatomic) IBOutlet UIButton    * isManager;
@property (weak, nonatomic) IBOutlet UIView      * backView;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;

@end

@implementation RegisterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = MAIN_COLOR;
    self.doneBtn.selected = NO;
    self.mailText.textColor = BLUE_COLOR;
    self.nameText.textColor = BLUE_COLOR;
    self.backView.backgroundColor = [UIColor whiteColor];
    
    self.imageView.image = [UIImage imageNamed:@"user-icon"];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    
    self.mailText.text = ((LKUser *)[[UserInfoManager sharedManager] getUserInfo]).email;
    self.nameText.text = ((LKUser *)[[UserInfoManager sharedManager] getUserInfo]).name;
    self.isManager.layer.cornerRadius = 3;
    self.isManager.layer.masksToBounds = YES;
    
    self.doneBtn.layer.cornerRadius = 5;
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.doneBtn.layer.borderWidth = 0.6;
    
    self.doneBtn.titleLabel.textColor = BLUE_COLOR;
    self.doneBtn.titleLabel.text = @"开始";
    self.doneBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"register_btn"]];
    self.doneBtn.backgroundColor = [UIColor whiteColor];
    
    self.widthConstriants.constant = SCREEN_WIDTH * 0.8;
}

#pragma mark - action

- (IBAction)doneAction:(id)sender {
    
    if (![self.mailText.text hasSuffix:@"@lukou.com"]) {
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"请输入正确的邮箱"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"取消"
                               otherButtonTitles:@"确定",
                               nil];
        [self addSubview:alert];
        [alert show];
        return;
    }
    
    self.doneBtn.selected = !self.doneBtn.selected;
    [[LKAPIClient sharedClient] requestPOSTForAddUser:@"register"
                                               params:[self paramsWithNameAndEmail]
                                           modelClass:[LKMSimpleMsg class]
                                    completionHandler:^(LKJSonModel *aModelBaseObject) {
        NSDictionary * dic = [NSDictionary dictionary];
        if ([aModelBaseObject isKindOfClass:[NSDictionary class]]) {
            dic = (NSDictionary *)aModelBaseObject;
        }
        [[LKAPIClient sharedClient] requestPOSTForGetUserInfo:@"user"
                                                       params:@{@"name":self.nameText.text}
                                                   modelClass:[LKUser class]
                                            completionHandler:^(LKJSonModel *aModelBaseObject) {
            LKUser * infoDic;
            if ([aModelBaseObject isKindOfClass:[LKUser class]]) {
                infoDic = (LKUser *)aModelBaseObject;
            }
            [self.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
                                                         ToPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*1.5)]
                              forKey:@"registerOut"];
            NSDictionary * dic = @{@"email":self.mailText.text,@"name":self.nameText.text,
                                   @"is_admin":@(infoDic.is_admin),
                                   @"has_ordered":@(infoDic.has_ordered)};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderBtn"
                                                                object:nil userInfo:dic];
        } errorHandler:^(LKAPIError *engineError) {
            [LKUIUtils showError:engineError.message];
        }];
    
    } errorHandler:^(LKAPIError *engineError) {
        [LKUIUtils showError:engineError.message];
    }];
}

- (NSDictionary *)paramsWithNameAndEmail {
    return @{@"eamil":self.mailText.text,@"name":self.nameText.text};
}

- (CABasicAnimation *)outAnimationFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint{
    CABasicAnimation * poiAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    poiAnim.duration = 0.5;
    poiAnim.repeatCount = 1;
    poiAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    poiAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    poiAnim.fillMode = kCAFillModeForwards;
    poiAnim.removedOnCompletion = NO;
    poiAnim.delegate = self;
    poiAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return poiAnim;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
     [self removeFromSuperview];
}

- (IBAction)isManagerBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1;
    } else {
        btn.layer.borderWidth = 0;
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.mailText resignFirstResponder];
    [self.nameText resignFirstResponder];
}

@end
