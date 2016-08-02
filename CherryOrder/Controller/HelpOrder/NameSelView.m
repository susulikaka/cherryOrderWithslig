//
//  PublishCommodityPicView.m
//  lukou
//
//  Created by ZHAOYU on 15/6/25.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "NameSelView.h"

@implementation NameSelView

- (void)awakeFromNib {
    self.layer.borderWidth = 0.f;
}

- (void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (enabled) {
        self.name.alpha = 1.f;
    } else {
        self.name.alpha = 0.5f;
    }
}

- (void)renderWithName:(NSString *)name enabled:(BOOL)enabled {
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
    self.name.textColor = LK_BACK_COLOR_LIGHT_GRAY;
    self.name.text = name;
    self.enabled = enabled;
    if (self.enabled) {
        self.layer.borderColor = DARK_MAIN_COLOR.CGColor;
        self.backgroundColor = DARK_MAIN_COLOR;
        self.name.textColor = [UIColor whiteColor];
    } else {
        self.layer.borderColor = LK_BACK_COLOR_LIGHT_GRAY.CGColor;
    }
}

@end
