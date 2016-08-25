//
//  SSBustomBtn.h
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapBtnBlock)();

typedef NS_ENUM(NSUInteger,SSButtonType)
{
    SSBtnCordiusType = 0,
    SSBtnRendType
};

@interface SSBustomBtn : UIButton

@property (nonatomic, assign) CGFloat cordius;
@property (nonatomic, copy) tapBtnBlock tapBlock;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        image:(UIImage *)image
                       selImg:(UIImage *)selImg
                      cordius:(CGFloat)cordius
                         Type:(SSButtonType)type
                     tapBlock:(tapBtnBlock)block;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      cordius:(CGFloat)cordius
                         Type:(SSButtonType)type
                     tapBlock:(tapBtnBlock)block;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      cordius:(CGFloat)cordius;

@end
