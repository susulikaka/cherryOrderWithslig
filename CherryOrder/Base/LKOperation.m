//
//  LKOperation.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKOperation.h"

@implementation LKOperation

- (void)operationSucceeded {
    NSMutableDictionary * errorDic = [[self responseJSON] objectForKey:@"error"];
    if (errorDic) {
        self.resError = [[LKAPIError alloc] initWithDomain:kBusinessErrorDomain
                                                      code:[[errorDic objectForKey:@"code"] intValue]
                                                  userInfo:errorDic];
        [super operationFailedWithError:self.resError];
    } else {
        [super operationSucceeded];
    }
}

- (void)operationFailedWithError:(NSError *)error {
    NSMutableDictionary * errorDic = [[self responseJSON] objectForKey:@"error"];
    if (errorDic == nil) {
        self.resError = [[LKAPIError alloc] initWithDomain:kRequestErrorDomain
                                                      code:[error code]
                                                  userInfo:[error userInfo]];
    } else {
        self.resError = [[LKAPIError alloc] initWithDomain:kBusinessErrorDomain
                                                      code:[[errorDic objectForKey:@"code"] intValue]
                                                  userInfo:errorDic];
    }
    [super operationFailedWithError:error];
}

@end
