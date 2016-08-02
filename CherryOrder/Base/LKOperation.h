//
//  LKOperation.h
//  CherryOrder
//
//  Created by admin on 16/7/27.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <MKNetworkKit/MKNetworkKit.h>
#import "LKAPIError.h"

@interface LKOperation : MKNetworkOperation

@property (nonatomic, strong) LKAPIError * resError;

@end
