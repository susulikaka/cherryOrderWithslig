//
//  OrderInfoViewController.h
//  CherryOrder
//
//  Created by admin on 16/8/1.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField * orderName;
@property (strong, nonatomic) IBOutlet UITextField * orderTime;
@property (strong, nonatomic) IBOutlet UITextField * helperName;

@property (nonatomic, strong) NSDictionary * dataDic;

@end
