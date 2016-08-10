//
//  SSAlertView.h
//  CherryOrder
//
//  Created by admin on 16/8/9.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^okBlock)(NSString * value);
typedef void (^cancelBlock)();

@interface SSAlertView : UIView

@property (nonatomic, strong)NSString * curValue;
@property (nonatomic, strong)NSArray * pickArr;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (nonatomic, copy) okBlock okBlock;
@property (nonatomic, copy) cancelBlock cancelBlock;

- (void)rendWithText:(NSString *)name
                       value:(NSString *)value
           superView:(UIView *)superView
                     okBlock:(okBlock)okBlock
                 cancelBlock:(cancelBlock)cancelBlock;

- (void)rendWithDatePicker:(NSString *)name
                              date:(NSDate *)date
                         superView:(UIView *)superView
                           okBlock:(okBlock)okBlock
                       cancelBlock:(cancelBlock)cancelBlock;;

- (void)rendWithValuePicker:(NSString *)name
                            pickArr:(NSArray *)pickArr
                          superView:(UIView *)superView
                            okBlock:(okBlock)okBlock
                        cancelBlock:(cancelBlock)cancelBlock;;

@end
