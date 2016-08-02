//
//  DefaultAccountService.h
//  lukou
//
//  Created by feifengxu on 14/11/22.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountService.h"

static NSString * const kNotificationUserLoginSuccess = @"Notification.LKUserLoginSuccess";
static NSString * const kNotificationUserLoginCancelled = @"Notification.LKUserLoginCancelled";
static NSString * const kNotificationUserLoginNeedActivation = @"Notification.LKUserLoginNeedActivation";
static NSString * const kNotificationUserLoginActivated = @"Notification.LKUserLoginActivated";
static NSString * const kNotificationRegisterSuccess = @"Notification.RegisterSuccess";
static NSString * const kNotificationRegisterCancelUnactivated = @"Notification.RegisterCancelUnactivated";

@interface DefaultAccountService : NSObject<AccountService>

@property (nonatomic, strong) LKMUser *loginUser;

+ (DefaultAccountService *) sharedInstance;

@end
