//
//  RefreshFootView.h
//  CherryOrder
//
//  Created by admin on 16/8/4.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshFootView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

- (void)setMsgName:(NSString *)name;

@end
