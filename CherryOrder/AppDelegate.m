//
//  AppDelegate.m
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#define IS_iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MainViewController * vc = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController * nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = nvc;
    vc.navigationController.navigationBarHidden = YES;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self appearance];
    [self setNotification];
    [self setNotiAt4];
    [self setNotiAt430];
    return YES;
}

- (void)setNotification {
    UIApplication * application=[UIApplication sharedApplication];
    if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
        UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    [application cancelAllLocalNotifications];
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:@"11:35:00"];
    noti.fireDate = notiDate;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.repeatInterval = NSDayCalendarUnit;
    NSDictionary * params = @{@"name":@"vv"};
    noti.userInfo = params;
    noti.alertBody=@"4点啦，快开启点餐模式";
    noti.alertAction=@"解锁";
    noti.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)setNotiAt4 {
    UIApplication * application=[UIApplication sharedApplication];
    if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
        UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:@"11:40:00"];
    noti.fireDate = notiDate;
    noti.timeZone = [NSTimeZone defaultTimeZone];
    noti.repeatInterval = NSDayCalendarUnit;
    noti.alertBody=@"4:30咯，最后十分钟，晚餐还没有着落的的快去点餐吧";
    noti.alertAction=@"解锁";
    noti.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

- (void)setNotiAt430 {
    UIApplication * application=[UIApplication sharedApplication];
    if([application currentUserNotificationSettings].types==UIUserNotificationTypeNone){
        UIUserNotificationSettings * setting=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    UILocalNotification * noti=[[UILocalNotification alloc] init];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSDate * notiDate = [formatter dateFromString:@"11:45:00"];
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

- (void)appearance {
    [[UINavigationBar appearance] setBarTintColor:GRAY_COLOR];
    [[UINavigationBar appearance] setTintColor:LK_TEXT_COLOR_GRAY];
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:LK_TEXT_COLOR_GRAY,
                                                            NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0]}];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (IS_iOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }
}

@end
