//
//  RegisterViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "RegisterViewController.h"
#import "MainViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * backGroudImg;
@property (weak, nonatomic) IBOutlet UITextField * mailText;
@property (weak, nonatomic) IBOutlet UITextField * nameText;
@property (weak, nonatomic) IBOutlet UIButton    * doneBtn;
@property (weak, nonatomic) IBOutlet UIView      * backView;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInterface];
}

- (void)initInterface {
    self.view.backgroundColor = MAIN_COLOR;
    self.doneBtn.selected = NO;
    self.mailText.textColor = BLUE_COLOR;
    self.nameText.textColor = BLUE_COLOR;
    self.backView.backgroundColor = [UIColor whiteColor];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDissMissAction:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowAction:) name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)doneAction:(id)sender {
    if (![self.mailText.text hasSuffix:@"@lukou.com"]) {
        UIAlertView * alert = [[UIAlertView alloc]
                               initWithTitle:@"请输入正确的邮箱"
                               message:@""
                               delegate:self
                               cancelButtonTitle:@"取消"
                               otherButtonTitles:@"确定",
                               nil];
        [self.view addSubview:alert];
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
        
        NSDictionary * aDic = @{@"email":self.mailText.text,
                               @"name":self.nameText.text};
        [self saveUser:aDic];
        MainViewController * vc = [[MainViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
                       
    } errorHandler:^(LKAPIError *engineError) {
        [LKUIUtils showError:engineError.message];
        
        NSDictionary * aDic = @{@"email":self.mailText.text,
                                @"name":self.nameText.text};
        [self saveUser:aDic];
        MainViewController * vc = [[MainViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)saveUser:(NSDictionary *)userInfo {
    [LKUser sharedUser].email = userInfo[@"email"];
    [LKUser sharedUser].name = userInfo[@"name"];
    [LKUser sharedUser].end_time = nil;
    [LKUser sharedUser].has_ordered = [userInfo[@"has_ordered"] boolValue];
    [LKUser sharedUser].is_admin = [userInfo[@"is_admin"] boolValue];
    [LKUser sharedUser].historyOrder = [NSMutableDictionary dictionary];
    [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
}

- (NSDictionary *)paramsWithNameAndEmail {
    return @{@"eamil":self.mailText.text,@"name":self.nameText.text};
}

- (CABasicAnimation *)outAnimationFromPoint:(CGPoint)fromPoint ToPoint:(CGPoint)toPoint duration:(NSTimeInterval)duration {
    CABasicAnimation * poiAnim = [CABasicAnimation animationWithKeyPath:@"position"];
    poiAnim.duration = duration;
    poiAnim.repeatCount = 1;
    poiAnim.fromValue = [NSValue valueWithCGPoint:fromPoint];
    poiAnim.toValue = [NSValue valueWithCGPoint:toPoint];
    poiAnim.fillMode = kCAFillModeBoth;
    poiAnim.removedOnCompletion = NO;
    poiAnim.delegate = self;
    poiAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return poiAnim;
}

#pragma mark - keyboard

- (void)keyboardShowAction:(NSNotification *)noti {
    CGRect keyBoardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardBounds];
    NSNumber * duration = [noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber * curve = [noti.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
//    keyBoardBounds.size.height
    [self.backView.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) ToPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60) duration:[duration doubleValue]] forKey:@"upAnimation"];
}

- (void)keyboardDissMissAction:(NSNotification *)noti {
    CGRect keyBoardBounds;
    [[noti.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardBounds];
    NSNumber * duration = [noti.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self.backView.layer addAnimation:[self outAnimationFromPoint:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-60) ToPoint:CGPointMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2) duration:[duration doubleValue]] forKey:@"upAnimation"];

}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.mailText resignFirstResponder];
    [self.nameText resignFirstResponder];
}


@end
