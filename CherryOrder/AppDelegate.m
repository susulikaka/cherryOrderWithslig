//
//  AppDelegate.m
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

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
    return YES;
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
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"点餐咯" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [alert show];
}

@end
