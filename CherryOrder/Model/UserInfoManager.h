//
//  ContentManager.h
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKUser;

@interface UserInfoManager : NSObject

@property (nonatomic, strong)NSArray * userList;

+ (UserInfoManager *)sharedManager;

- (BOOL)saveUserInfo:(LKUser *)user;
- (LKUser *)getUserInfo;

- (void)addUserList:(NSString *)userInfo;
- (NSArray *)getUserList;
- (void)removeUserList;

- (void)saveFirstRun:(BOOL)run;
- (BOOL)getFirstRun;

-(void)removeUSerInfo;

@end
