//
//  LKMUserStatus.h
//  lukou
//
//  Created by ZHAOYU on 15/7/1.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "LKJSONModel.h"

@class LKMStatusItem;

@interface LKMUserStatus : LKJSonModel

@property (nonatomic, strong) LKMStatusItem *raffle;

@end
