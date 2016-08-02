//
//  LKJSonModel.h
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKJSonModel : NSObject<NSCopying, NSCoding, NSMutableCopying>

@property (nonatomic, readonly) NSDictionary * persistantDic;

+ (id)objectWithDictionary:(NSDictionary *)jsonObj;
- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
