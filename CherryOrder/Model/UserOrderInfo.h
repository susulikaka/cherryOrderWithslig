//
//  UserOrderInfo.h
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKJSonModel.h"
#import "LKUser.h"

@interface UserOrderInfo : LKJSonModel

@property (nonatomic, strong) LKUser   * user;
@property (nonatomic, strong) NSString * agent;

@end
