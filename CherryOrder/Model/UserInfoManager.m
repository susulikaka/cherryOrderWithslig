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

- (NSDictionary *)getUserList {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userList"] != nil) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:@"userList"];
    } else {
        return [NSDictionary dictionary];
    }
}

- (void)addUserList:(NSString *)userInfo {
    
    NSMutableDictionary * userDic = [[self getUserList] mutableCopy];
    if (userDic == nil) {
        userDic = [NSMutableDictionary dictionary];
    }
    NSMutableArray * arr;
    if (![userDic.allKeys containsObject:[self getUserInfo].name ]) {
        arr = [NSMutableArray array];
    } else {
        arr = [[userDic objectForKey:[self getUserInfo].name] mutableCopy];
    }
    if (![arr containsObject:userInfo]) {
        [arr addObject:userInfo];
    }
    [userDic setObject:arr forKey:[self getUserInfo].name];

    [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userList"];
}

- (void)removeUserList {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userList"];
}

@end
