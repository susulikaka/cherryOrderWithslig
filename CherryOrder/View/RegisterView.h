//
//  RegisterView.h
//  CherryOrder
//
//  Created by admin on 16/7/26.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property (weak, nonatomic, readonly) UITextField * mailText;
@property (weak, nonatomic, readonly) UITextField * nameText;
@property (weak, nonatomic, readonly) UIButton    * doneBtn;
@property (weak, nonatomic, readonly) UIButton    * isManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstriants;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrants;


@end
