//
//  AllHistory.h
//  CherryOrder
//
//  Created by admin on 16/7/29.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKJSonModel.h"

@interface AllHistory : LKJSonModel

@property (nonatomic, assign) NSInteger     count;
@property (nonatomic, strong) NSString *    end_time;
@property (nonatomic, strong) NSArray  *    list;

@end
