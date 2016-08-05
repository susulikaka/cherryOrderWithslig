//
//  MainViewController.m
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "MainViewController.h"
#import "RegisterView.h"
#import "UIView+Nib.h"
#import "PureLayout.h"
#import "ColorConstants.h"
#import "ReactiveCocoa.h"
#import "MenuView.h"
#import "PersonalHistoryViewController.h"
#import "AllOrderHistoryViewController.h"
#import "HelpOrderViewController.h"

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet RegisterView *registerView;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (strong, nonatomic) IBOutlet MenuView *menuView;
@property (strong, nonatomic) UIPanGestureRecognizer * panGesture;
@property (strong, nonatomic) PersonalHistoryViewController *historyVC;
@property (strong, nonatomic) AllOrderHistoryViewController * allOrderHistoryVC;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) BOOL isManager;
@property (assign, nonatomic) BOOL isOrdered;
@property (assign, nonatomic) BOOL isFirstRun;
@property (strong, nonatomic) UILongPressGestureRecognizer *longGsture;
@property (strong, nonatomic) NSString *curDate;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self initInterface];
    [self refreshOrderBtn];
}

#pragma mark - init interface

- (void)initInterface {
    [self.view addGestureRecognizer:self.panGesture];
    [self.orderBtn addGestureRecognizer:self.longGsture];
//    [[UserInfoManager sharedManager] saveFirstRun:YES];
//    [[UserInfoManager sharedManager] removeUSerInfo];
    if ([[UserInfoManager sharedManager] getFirstRun] || [[UserInfoManager sharedManager] getUserInfo].name == nil || [[UserInfoManager sharedManager] getUserInfo].email == nil) {
        self.panGesture.enabled = NO;
        [self addRegisterView];
        [[UserInfoManager sharedManager] saveFirstRun:NO];
    } else {
        self.panGesture.enabled = YES;
    }
    LKUser * user = [[UserInfoManager sharedManager] getUserInfo];
    [[LKUser sharedUser] merge:user];
    
    self.dayLabel.textColor = [UIColor whiteColor];
    self.topLabel.textColor = [UIColor whiteColor];
    self.monthLabel.textColor = [UIColor whiteColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.view.backgroundColor = MAIN_COLOR;
    self.topLabel.backgroundColor = DARK_MAIN_COLOR;
    self.nameLabel.text = [[UserInfoManager sharedManager] getUserInfo].name;
    self.dayLabel.text = [self.curDate substringFromIndex:8];
    NSString * monthStr = [self.curDate substringWithRange:NSMakeRange(5, 2)];
    NSString * yearStr = [self.curDate substringWithRange:NSMakeRange(0, 4)];
    self.monthLabel.text = [NSString stringWithFormat:@"of %@ , %@",monthStr,yearStr];
    
    self.isManager = YES;
    self.orderBtn.layer.cornerRadius = self.orderBtn.frame.size.height / 2;
    self.orderBtn.layer.masksToBounds = YES;
    [self.orderBtn setTitle:@"取消" forState:UIControlStateSelected];
    [self.orderBtn setTitle:@"点餐" forState:UIControlStateNormal];
    [self.orderBtn setBackgroundColor:BLUE_COLOR forState:UIControlStateNormal];
    [self.orderBtn setBackgroundColor:LK_TEXT_COLOR_GRAY forState:UIControlStateSelected];
    
    [self addNoti];
    if ([self getWeek] >= START_WEEKDAY && [self getWeek] <= END_WEEKDAY) {
        self.orderBtn.enabled = YES;
    } else {
        self.orderBtn.enabled = NO;
        [self cancelNoti];
    }
    
    if (![LKUser sharedUser].has_ordered) {
        self.orderBtn.selected = NO;
        [self cancelNoti];
    } else {
        self.orderBtn.selected = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAndRefresh:) name:@"refreshOrderBtn" object:nil];
}

#pragma mark - private method

- (void)addNoti {
    [self setNotification];
    [self setNotiAt4];
    [self setNotiAt430];
}

- (void)cancelNoti {
    NSArray * arr = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification * noti in arr) {
        [[UIApplication sharedApplication] cancelLocalNotification:noti];
    }
}

- (void)setNotification {
    UIApplication * application=[UIApplication sharedApplication];
    if (IS_iOS8) {
        if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
            UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [application registerUserNotificationSettings:setting];
        }
    }
    [application cancelAllLocalNotifications];
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:END_TIME_4];
    noti.fireDate = notiDate;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.repeatInterval = NSDayCalendarUnit;
    NSDictionary * params = @{@"name":@"vv"};
    noti.userInfo = params;
    noti.alertBody=@"4点啦，还没有点餐的快开启点餐模式";
    noti.alertAction=@"解锁";
    noti.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)setNotiAt4 {
    UIApplication * application=[UIApplication sharedApplication];
    if (IS_iOS8) {
        if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
            UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [application registerUserNotificationSettings:setting];
        }
    }
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:END_TIME_430];
    noti.fireDate = notiDate;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.repeatInterval = NSDayCalendarUnit;
    noti.alertBody=@"最后十分钟，晚餐还没有着落的的快去点餐吧";
    noti.alertAction=@"解锁";
    noti.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)setNotiAt430 {
    UIApplication * application=[UIApplication sharedApplication];
    if (IS_iOS8) {
        if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
            UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [application registerUserNotificationSettings:setting];
        }
    }
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:END_TIME_440];
    noti.fireDate = notiDate;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.repeatInterval = NSDayCalendarUnit;
    NSDictionary * params = @{@"name":@"vv"};
    noti.userInfo = params;
    noti.alertBody=@"亲爱的，今天的点餐结束啦";
    noti.alertAction=@"解锁";
    noti.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)saveAndRefresh:(NSNotification *)noti {
    [LKUser sharedUser].email = noti.userInfo[@"email"];
    [LKUser sharedUser].name = noti.userInfo[@"name"];
    [LKUser sharedUser].end_time = nil;
    [LKUser sharedUser].has_ordered = [noti.userInfo[@"has_ordered"] boolValue];
    [LKUser sharedUser].is_admin = [noti.userInfo[@"is_admin"] boolValue];
    [LKUser sharedUser].historyOrder = [NSMutableDictionary dictionary];
    [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
    self.nameLabel.text = noti.userInfo[@"name"];
    [self refreshOrderBtn];
}

- (void)refreshOrderBtn {
    self.panGesture.enabled = YES;
    NSString * name = [[UserInfoManager sharedManager] getUserInfo].name;
    if (name.length != 0) {
        [[LKAPIClient sharedClient] requestPOSTForGetUserInfo:@"user" params:@{@"name":name} modelClass:[LKUser class] completionHandler:^(LKJSonModel *aModelBaseObject) {
            LKUser * infoDic;
            if ([aModelBaseObject isKindOfClass:[LKUser class]]) {
                infoDic = (LKUser *)aModelBaseObject;
            }
            [LKUser sharedUser].has_ordered = infoDic.has_ordered;
            [LKUser sharedUser].is_admin = infoDic.is_admin;
            [LKUser sharedUser].name = infoDic.name;
            [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
            self.nameLabel.text = infoDic.name;
            self.orderBtn.selected = [LKUser sharedUser].has_ordered;
            self.isManager = [LKUser sharedUser].is_admin;
        } errorHandler:^(LKAPIError *engineError) {
            [LKUIUtils showError:engineError.message];
        }];
    }
}

- (void)addRegisterView {
    NSArray * xibArr = [[NSBundle mainBundle] loadNibNamed:@"RegisterView" owner:nil options:nil];
    self.registerView = [xibArr firstObject];
    [self.view addSubview:self.registerView];
    [self.registerView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - action

- (IBAction)orderAction:(id)sender {
    // get current time
    NSDate * currentTime = [NSDate date];
     NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * currentTimeStr = [formatter stringFromDate:currentTime];
    NSComparisonResult result = [currentTimeStr compare:END_TIME options:NSNumericSearch];
    if (result >= 0) {
        self.orderBtn.enabled = NO;
        return;
    } else {
        self.orderBtn.enabled = YES;
    }
    if (self.orderBtn.selected) {
        [[LKAPIClient sharedClient] requestDELETEForCancelOrder:@"order"
                                                     modelClass:[LKMSimpleMsg class]
                                              completionHandler:^(LKJSonModel *aModelBaseObject) {
        [self addNoti];
        self.orderBtn.selected = !self.orderBtn.selected;
        NSDictionary * dic = [NSDictionary dictionary];
        if ([aModelBaseObject isKindOfClass:[NSDictionary class]]) {
            dic = (NSDictionary *)aModelBaseObject;
        }
        [[LKUser sharedUser].historyOrder setValue:@(self.orderBtn.selected) forKey:self.curDate];
        [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
        } errorHandler:^(LKAPIError *engineError) {
            [LKUIUtils showError:engineError.message];
        }];
    } else {
        [[LKAPIClient sharedClient] requestPOSTForOrder:@"order"
                                             modelClass:[LKMSimpleMsg class]
                                      completionHandler:^(LKJSonModel *aModelBaseObject) {
                                          
         // add noti
        [self cancelNoti];
        self.orderBtn.selected = !self.orderBtn.selected;
        NSDictionary * dic = [NSDictionary dictionary];
        if ([aModelBaseObject isKindOfClass:[NSDictionary class]]) {
            dic = (NSDictionary *)aModelBaseObject;
        }
        [[LKUser sharedUser].historyOrder setValue:@(self.orderBtn.selected) forKey:self.curDate];
        [[UserInfoManager sharedManager] saveUserInfo:[LKUser sharedUser]];
        } errorHandler:^(LKAPIError *engineError) {
            [LKUIUtils showError:engineError.message];
        }];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture {
    if (!self.menuView.superview) {
        NSArray *xibArr = [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:nil options:nil];
        self.menuView = [xibArr firstObject];
        [self.view addSubview:self.menuView];
        [self.menuView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
//        if (!self.isManager) {
//            self.menuView.allHistory.hidden = YES;
//        } else {
//            self.menuView.allHistory.hidden = NO;
//        }
        
        [RACObserve(self.menuView.accountChange, selected) subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                self.panGesture.enabled = NO;
                [self addRegisterView];
            }
        }];
        
        [RACObserve(self.menuView.accountHistory, selected) subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                if ([[UserInfoManager sharedManager] getUserInfo].name == nil) {
                    [LKUIUtils showError:@"请先进入账户"];
                } else {
                    self.panGesture.enabled = NO;
                    [self.navigationController pushViewController:self.historyVC animated:YES];
                }
                
            }
        }];
        
        [RACObserve(self.menuView.allHistory, selected) subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                if ([[UserInfoManager sharedManager] getUserInfo].name == nil) {
                    [LKUIUtils showError:@"请先进入账户"];
                } else {
                    self.panGesture.enabled = NO;
                    [self.navigationController pushViewController:self.allOrderHistoryVC animated:YES];
                }
            }
        }];
        
        [RACObserve(self.menuView.helpOrder, selected) subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                if ([[UserInfoManager sharedManager] getUserInfo].name == nil) {
                    [LKUIUtils showError:@"请先进入账户"];
                } else {
                    self.panGesture.enabled = NO;
                    HelpOrderViewController * vc = [[HelpOrderViewController alloc] initWithNibName:@"HelpOrderViewController" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }];
    }
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CABasicAnimation * scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.duration = 1;
        scaleAnim.repeatCount = 0;
        scaleAnim.autoreverses = YES;
        scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.1)];
        [self.orderBtn.layer addAnimation:scaleAnim forKey:@"scale-layer"];
    } if (gesture.state == UIGestureRecognizerStateEnded) {
        CABasicAnimation * scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.duration = 1;
        scaleAnim.repeatCount = 1;
        scaleAnim.autoreverses = NO;
        scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
        [self.orderBtn.layer addAnimation:scaleAnim forKey:@"scale-layer"];
    }
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

- (NSInteger) getWeek {
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate * date = [NSDate date];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday]-1;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getter

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        _panGesture.minimumNumberOfTouches = 1;
        _panGesture.maximumNumberOfTouches = 1;
    }
    return _panGesture;
}

- (UILongPressGestureRecognizer *)longGsture {
    if (!_longGsture) {
        _longGsture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
    }
    return _longGsture;
}

- (PersonalHistoryViewController *)historyVC {
    if (!_historyVC) {
        _historyVC = [[PersonalHistoryViewController alloc] initWithNibName:@"PersonalHistoryViewController" bundle:nil];
    }
    return _historyVC;
}

- (AllOrderHistoryViewController *)allOrderHistoryVC {
    if (!_allOrderHistoryVC) {
        _allOrderHistoryVC = [[AllOrderHistoryViewController alloc] initWithNibName:@"AllOrderHistoryViewController" bundle:nil];
    }
    return _allOrderHistoryVC;
}

- (NSString *)curDate {
    if (!_curDate) {
        NSDate * time = [NSDate date];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSString *timeStr = [formatter stringFromDate:time];
        _curDate = timeStr;
    }
    return _curDate;
}

@end
