//
//  LKAPIError.h
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR"

@interface LKAPIError : NSError

@property (nonatomic, strong) NSString * message;
@property (nonatomic, assign) NSInteger errorCode;

@end
