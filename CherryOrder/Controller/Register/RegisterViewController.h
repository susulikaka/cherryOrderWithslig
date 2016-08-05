//
//  RegisterViewController.h
//  CherryOrder
//
//  Created by admin on 16/8/5.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic, readonly) UITextField * mailText;
@property (weak, nonatomic, readonly) UITextField * nameText;
@property (weak, nonatomic, readonly) UIButton    * doneBtn;
@property (weak, nonatomic, readonly) UIButton    * isManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstriants;

@end
