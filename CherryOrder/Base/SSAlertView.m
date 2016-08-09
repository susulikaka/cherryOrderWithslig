//
//  SSAlertView.m
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SSAlertView.h"

@implementation SSAlertView

- (instancetype)initWithText:(NSString *)name value:(NSString *)value okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock{
    if (self = [super init]) {
        self.nameLabel.text = name;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

- (instancetype)initWithDatePicker:(NSString *)name date:(NSDate *)date okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock {
    if (self = [super init]) {
        self.nameLabel.text = name;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

- (instancetype)initWithValuePicker:(NSString *)name pickArr:(NSArray *)pickArr okBlock:(okBlock)okBlock cancelBlock:(cancelBlock)cancelBlock {
    if (self = [super init]) {
        self.nameLabel.text = name;
        self.okBlock = okBlock;
        self.cancelBlock = cancelBlock;
    }
    return self;
}

#pragma mark - add subview

-(void)addValueViewWithValue:(NSString *)value {
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame)+5, self.frame.size.width, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = value;
    [self addSubview:label];
}

@end
