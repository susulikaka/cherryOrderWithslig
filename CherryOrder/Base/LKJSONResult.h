//
//  LKJSONResult.h
//  lukou
//
//  Created by feifengxu on 14/11/22.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKJSONModel.h"

@interface LKJSONResult : NSObject
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong)        id result;

- (instancetype)initWithDictionary:(NSDictionary*)jsonObject
                        modelClass:(Class)modelClass;
@end
