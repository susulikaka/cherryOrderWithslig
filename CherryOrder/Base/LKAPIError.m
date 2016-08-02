//
//  LKAPIError.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKAPIError.h"

@implementation LKAPIError

- (instancetype)init {
    if ((self = [super init])) {
        return self;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.message forKey:@"message"];
    [aCoder encodeInteger:self.errorCode forKey:@"errorCode"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init])) {
        self.message = [aDecoder decodeObjectForKey:@"message"];
        self.errorCode = [aDecoder decodeIntegerForKey:@"errorCode"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    [copy setMessage:[self.message copy]];
    [copy setErrorCode:self.errorCode];
    return copy;
}

@end
