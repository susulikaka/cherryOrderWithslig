//
//  SSBustomBtn.m
//  CherryOrder
//
//  Created by admin on 16/7/28.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "SSBustomBtn.h"

@implementation SSBustomBtn


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                        image:(UIImage *)image
                       selImg:(UIImage *)selImg
                      cordius:(CGFloat)cordius
                         Type:(SSButtonType)type
                     tapBlock:(tapBtnBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = cordius;
        self.layer.masksToBounds = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selImg forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        self.tapBlock = block;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.bounds.size.height+10, -self.imageView.bounds.size.width, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, -self.titleLabel.bounds.size.width)];
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                      cordius:(CGFloat)cordius
                         Type:(SSButtonType)type
                     tapBlock:(tapBtnBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = cordius;
        self.layer.masksToBounds = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:LK_TEXT_COLOR_GRAY forState:UIControlStateNormal];
        [self setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        self.tapBlock = block;
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAction {
    if (self.tapBlock) {
        self.tapBlock();
    }
}

@end
