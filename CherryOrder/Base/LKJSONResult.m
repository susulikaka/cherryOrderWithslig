//
//  LKJSONResult.m
//  lukou
//
//  Created by feifengxu on 14/11/22.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import "LKJSONResult.h"

@implementation LKJSONResult

- (instancetype) initWithDictionary:(NSDictionary*) jsonObject modelClass:(Class)modelClass{
    if ((self = [super init])) {
        _code = [(NSNumber *)jsonObject[@"code"] integerValue];

        if (modelClass) {
            _result = [[modelClass alloc] initWithDictionary:jsonObject[@"data"]];
        }
        return self;
    }
    
    return self;
}
@end
