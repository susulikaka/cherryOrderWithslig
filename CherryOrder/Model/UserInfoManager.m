//
//  ContentManager.m
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "UserInfoManager.h"
#import "LKUser.h"

#define USER_DIRETORY_NAME @"UserInfo"
#define USER_STORE_NAME @"userInfo.arch"

@implementation UserInfoManager

static UserInfoManager *sharedInstance = nil;

+ (UserInfoManager *)sharedManager {
    static  dispatch_once_t once;
    dispatch_once(&once,^{
        sharedInstance = [[UserInfoManager alloc] init];
    });
    return sharedInstance;
}

- (BOOL)saveUserInfo:(LKUser *)user {
    return [NSKeyedArchiver archiveRootObject:user toFile:[self pathForDataFile]];
}

- (LKUser *)getUserInfo {
    LKUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];
    if (user.historyOrder == nil) {
        user.historyOrder = [NSMutableDictionary dictionary];
    }
    return user;
}

- (NSString *)pathForDataFile {
    NSArray*  documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = nil;
    if (documentDir) {
        path = [documentDir objectAtIndex:0];
    }
    BOOL isDir;
    NSString* userDir = [path stringByAppendingPathComponent:USER_DIRETORY_NAME];
    if(![[NSFileManager defaultManager] fileExistsAtPath:userDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [userDir stringByAppendingPathComponent:USER_STORE_NAME];
}

- (void)saveFirstRun:(BOOL)run {
    [[NSUserDefaults standardUserDefaults] setBool:run forKey:@"firstRuns"];
}

- (BOOL)getFirstRun {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"firstRuns"];
}

- (void)removeUSerInfo {
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForDataFile] error:nil];
}

- (NSArray *)getUserList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
}

- (void)addUserList:(NSString *)userInfo {
    NSMutableArray * arr = [[self getUserList] mutableCopy];
    if (arr.count == 0) {
        arr = [NSMutableArray array];
    }
    [arr addObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"userList"];
}

- (void)removeUserList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userList"];
}

@end
