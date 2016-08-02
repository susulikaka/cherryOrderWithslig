//
//  LKUser.h
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKJSonModel.h"

@interface LKUser : LKJSonModel

@property (nonatomic, assign) NSInteger  uid;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, assign) BOOL       has_ordered;
@property (nonatomic, assign) BOOL       is_admin;
@property (nonatomic, strong) NSMutableDictionary * historyOrder;
@property (nonatomic, strong) NSString            * end_time;

+ (instancetype)sharedUser;
- (LKUser *)merge:(LKUser *)user;
- (NSDictionary *)toDic;

@end
