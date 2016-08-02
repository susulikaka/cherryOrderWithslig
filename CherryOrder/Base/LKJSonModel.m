//
//  LKJSonModel.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKJSonModel.h"

@implementation LKJSonModel

+ (id)objectWithDictionary:(NSDictionary *)jsonObj {
    if (jsonObj) {
        id jsonModel = [[self alloc] initWithDictionary:jsonObj];
        return jsonModel;
    }
    return nil;
}

- (id)initWithDictionary:(NSDictionary *)jsonObj {
    if ((self = [super init])) {
        [self setValuesForKeysWithDictionary:jsonObj];
    }
    return self;
}

- (BOOL)allowKeyedCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    LKJSonModel *newModel = [[LKJSonModel allocWithZone:zone] init];
    return newModel;
}

- (id)copyWithZone:(NSZone *)zone {
    LKJSonModel *newModel = [[LKJSonModel allocWithZone:zone] init];
    return newModel;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *exception) {
        NSLog(@"fail to set value");
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"uid"];
    }
}

- (NSDictionary *)persistantDic {
    return nil;
}

@end
