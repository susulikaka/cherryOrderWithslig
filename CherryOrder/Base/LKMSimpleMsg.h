//
//  SimpleMsg.h
//  lukou
//
//  Created by feifengxu on 14/11/26.
//  Copyright (c) 2014年 lukou. All rights reserved.
//

#import "LKJSONModel.h"

@interface LKMSimpleMsg : LKJSonModel

@property (nonatomic, assign) NSInteger  code;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * url;
@end
