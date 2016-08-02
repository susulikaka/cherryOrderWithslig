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
                      cordius:(CGFloat)cordius
                         Type:(SSButtonType)type
                     tapBlock:(tapBtnBlock)block {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MAIN_COLOR;
        self.layer.cornerRadius = cordius;
        self.layer.masksToBounds = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.text = title;
        
    }
    return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)btnWithType:(SSButtonType)type tapBlock:(tapBtnBlock)block {
    
}

@end
