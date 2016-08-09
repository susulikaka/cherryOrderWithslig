//
//  SSAlertView.h
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^okBlock)();
typedef void (^cancelBlock)();

@interface SSAlertView : UIView

@property (nonatomic, strong)NSString * curValue;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (nonatomic, copy) okBlock okBlock;
@property (nonatomic, copy) cancelBlock cancelBlock;

- (instancetype)initWithText:(NSString *)name
                       value:(NSString *)value
                     okBlock:(okBlock)okBlock
                 cancelBlock:(cancelBlock)cancelBlock;

- (instancetype)initWithDatePicker:(NSString *)name
                              date:(NSDate *)date
                           okBlock:(okBlock)okBlock
                       cancelBlock:(cancelBlock)cancelBlock;;

- (instancetype)initWithValuePicker:(NSString *)name
                            pickArr:(NSArray *)pickArr
                            okBlock:(okBlock)okBlock
                        cancelBlock:(cancelBlock)cancelBlock;;

@end
