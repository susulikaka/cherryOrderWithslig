//
//  DefaultAccountService.m
//  lukou
//
//  Created by feifengxu on 14/11/22.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import "DefaultAccountService.h"

#import <Zhugeio/Zhuge.h>
#import "TPEventLogger.h"
#import "LKLoginViewController.h"
#import "LKAppDelegate.h"
#import "LKDraftHelper.h"

#define USER_DIRETORY_NAME @"User"
#define USER_STORE_NAME @"user.arch"

@interface DefaultAccountService()
@property (nonatomic, copy) RefreshOnSuccessBlock refreshOnSuccessBlock;
@property (nonatomic, copy) LoginSuccessBlock loginSuccessBlock;
@property (nonatomic, copy) LoginCancelBlock loginCancelBlock;
@end

@implementation DefaultAccountService

static DefaultAccountService *sharedInstance = nil;

+ (DefaultAccountService *) sharedInstance {
    static  dispatch_once_t once;
    dispatch_once(&once,^{
        sharedInstance = [[DefaultAccountService alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loginUser = [self unarchiverFromDisk];
    }
    return self;
}

- (BOOL)isLogin {
    if (self.uid != 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)uid {
    return self.loginUser.uid;
}

- (NSString *)token {
    return self.loginUser.token;
}

- (void)logout {
    self.loginUser = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[self pathForDataFile] error:nil];
    [[LKAPIClient defaultClient] emptyCache];
    [[DefaultPushService sharedPushService] syncDeviceToken];
    [[DefaultPushService sharedPushService] clearPushData];
}

- (void)update:(LKMUser *)user {
    if(!self.loginUser) {
        self.loginUser = user;
        [[LKDraftHelper sharedDraftHelper] reset];
        [[DefaultPushService sharedPushService] syncDeviceToken];
        if (self.loginSuccessBlock) {
            self.loginSuccessBlock(self);
            self.loginSuccessBlock = nil;
        } 
    } else {
        [self.loginUser merge:user];
    }
    [self archiver2Disk:self.loginUser];
    
    [[Zhuge sharedInstance] identify:[@(self.loginUser.uid) stringValue]
                          properties:[self.loginUser toDict]];
}

- (void)refreshOnSuccessBlock:(RefreshOnSuccessBlock)refreshOnSuccessBlock {
    if([self isLogin]) {
        self.refreshOnSuccessBlock = refreshOnSuccessBlock;
        @weakify(self);
        [[LKAPIClient defaultClient] generatorGETLKOperationWithPath:@"user"
                                                              params:@{@"uid":@(self.uid)}
                                                          modelClass:[LKMUser class]
                                                   completionHandler:^(LKJSONModel *aModelBaseObject)
         {
             @strongify_return_if_nil(self);
             [self update:(LKMUser *)aModelBaseObject];
             if (self.refreshOnSuccessBlock) {
                 self.refreshOnSuccessBlock((LKMUser *)aModelBaseObject);
                 self.refreshOnSuccessBlock = nil;
             }
         } errorHandler:^(LKAPIError *engineError) {
             @strongify_return_if_nil(self);
             if (self.refreshOnSuccessBlock) {
                 self.refreshOnSuccessBlock(self.loginUser);
                 self.refreshOnSuccessBlock = nil;
             }
         }];
    }
}

- (BOOL)archiver2Disk:(LKMUser *)user {
    return [NSKeyedArchiver archiveRootObject:user toFile:[self pathForDataFile]];
}

- (LKMUser *)unarchiverFromDisk {
    LKMUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathForDataFile]];
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

@end
