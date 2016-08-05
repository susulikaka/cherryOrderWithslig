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
    
    self.name.textColor = LK_BACK_COLOR_LIGHT_GRAY;
    self.name.text = name;
    self.enabled = enabled;
    if (self.enabled) {
        self.backImgView.image = [UIImage imageAddCornerWithRadius:self.bounds.size.height/2 andSize:self.bounds.size fileMode:kCGPathFillStroke];
        self.name.textColor = [UIColor whiteColor];
    } else {
        self.backImgView.image = [UIImage imageAddCornerWithRadius:self.bounds.size.height/2 andSize:self.bounds.size fileMode:kCGPathStroke];
    }
    [self bringSubviewToFront:self.mark];
}

@end
