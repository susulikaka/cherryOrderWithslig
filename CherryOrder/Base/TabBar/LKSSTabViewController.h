//
//  LKSSTabViewController.h
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKSSTabViewController : UIViewController

@property (nonatomic, strong) NSArray * btnArr;
@property (nonatomic, strong) NSArray * VCArr;
@property (nonatomic, strong) UIViewController * currVC;
@property (nonatomic, assign) NSInteger currIndex;
@property (nonatomic, strong) NSArray * titleArr;
@property (nonatomic, strong) NSArray * imageArr;
@property (nonatomic, strong) NSArray * selImgArr;
@end
