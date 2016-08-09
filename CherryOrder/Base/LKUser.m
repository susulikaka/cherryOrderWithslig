//
//  LKUser.m
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "LKUser.h"

@implementation LKUser

+ (instancetype)sharedUser {
    static LKUser *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[LKUser alloc] init];
        if (user.historyOrder == nil) {
            user.historyOrder = [NSMutableDictionary dictionary];
        }
    });
    return user;
}

- (LKUser *)merge:(LKUser *)user {
    self.image = user.image;
    self.uid = user.uid;
    self.name = user.name;
    self.email = user.email;
    self.has_ordered = self.has_ordered;
    self.is_admin = self.is_admin;
    self.historyOrder = user.historyOrder;
    self.end_time = user.end_time;
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.image forKey:@"image"];
    [aCoder encodeBool:self.is_admin forKey:@"is_admin"];
    [aCoder encodeBool:self.has_ordered forKey:@"has_ordered"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.historyOrder forKey:@"historyOrder"];
    [aCoder encodeObject:self.end_time forKey:@"endTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        if ([aDecoder containsValueForKey:@"uid"]) {
            _uid = [aDecoder decodeIntegerForKey:@"uid"];
        }
        if ([aDecoder containsValueForKey:@"name"]) {
            _name = [aDecoder decodeObjectForKey:@"name"];
        }
        if ([aDecoder containsValueForKey:@"image"]) {
            _image = [aDecoder decodeObjectForKey:@"image"];
        }
        if ([aDecoder containsValueForKey:@"email"]) {
            _email = [aDecoder decodeObjectForKey:@"email"];
        }
        if ([aDecoder containsValueForKey:@"has_ordered"]) {
            _has_ordered = [aDecoder decodeBoolForKey:@"has_ordered"];
        }
        if ([aDecoder containsValueForKey:@"historyOrder"]) {
            _historyOrder = [aDecoder decodeObjectForKey:@"historyOrder"];
        }
        if ([aDecoder containsValueForKey:@"historyOrder"]) {
            _end_time = [aDecoder decodeObjectForKey:@"endTime"];
        }
        if ([aDecoder containsValueForKey:@"historyOrder"]) {
            _is_admin= [aDecoder decodeBoolForKey:@"is_admin"];
        }
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    [copy setEmail:[self.email copy]];
    [copy setName:[self.name copy]];
    [copy setHas_ordered:self.has_ordered];
    [copy setHistoryOrder:[self.historyOrder copy]];
    [copy setHistoryOrder:[self.end_time copy]];
    [copy setImage:[self.image copy]];
    return copy;
}

- (NSDictionary *)toDic {
    return @{@"name":self.name ? :@"",
             @"email":self.email ? :@"",
             @"image":self.image ?:@"",
             @"isOrdered":self.has_ordered ? @(self.has_ordered):@(!self.has_ordered),
             @"isAdmin":self.is_admin ? @(self.is_admin):@(self.is_admin),
             @"historyOrder":self.historyOrder ? :@"",
             @"endTime":self.end_time ?:@""};
}

@end
