//
//  AcountService.h
//  lukou
//
//  Created by feifengxu on 14/11/22.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

@import Foundation;
#import "LKMUser.h"

@class AccountService;

@protocol AccountService <NSObject>

/**
 * 用户是否登录
 */
- (BOOL)isLogin;

/**
 * 获取完整的用户账户信息
 * <p>
 * 没有登录时返回null <br>
 */
- (LKMUser *)loginUser;

/** 没有登录时返回0 */
- (NSInteger)uid;

/** 没有登录时返回null */
- (NSString *)token;

typedef void (^LoginSuccessBlock)(id<AccountService> accountService);
typedef void (^LoginCancelBlock)();
typedef void (^RefreshOnSuccessBlock)(LKMUser *user);

- (void)logout;

/**
 * <p>
 * 已登录时，更新当前账号信息
 * <p>
 * 只更新增量字段，如传入的profile只包含Avatar，则只更新Avatar字段，其他字段值不受影响。<br>
 * 如传入的profile中带有Token，则Token被忽略<br>
 * 如传入的profile中带有UserID，则必须与当前的UserID一致，否则忽略<br>
 *
 */
- (void)update:(LKMUser *)user;

- (void)refreshOnSuccessBlock:(RefreshOnSuccessBlock)refreshOnSuccessBlock;

@end
