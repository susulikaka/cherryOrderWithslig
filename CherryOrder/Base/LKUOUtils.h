//
//  LKUOUtils.h
//  CherryOrder
//
//  Created by admin on 16/8/3.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

@interface LKUOUtils : NSObject

+ (void)showProgressDialog:(NSString *)title;
+ (void)dismissProgressDialog;
+ (void)showError:(NSString *)errorMessage;

@end
