//
//  DOUPhotoCameraView.m
//  Lukou
//
//  Created by Zhao Yu on 12/29/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import <PureLayout/PureLayout.h>

#import "PhotoCameraView.h"

@implementation PhotoCameraView {
    UIImageView *_backgroundView;
    UIImageView *_cameraView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) ) {
        self.clipsToBounds = YES;
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_backgroundView];
        _cameraView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_take_photo"]];
        [_backgroundView addSubview:_cameraView];
        [_cameraView autoCenterInSuperview];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.origin.y = self.contentOffsetY;
    self.contentView.frame = frame;
}

- (void)setCompact:(BOOL)compact
{
    if (compact) {
        _backgroundView.image = nil;
        _backgroundView.backgroundColor = UIColorFromRGBWithAlpha(0x000000, 0.1);
        _cameraView.image = [UIImage imageNamed:@"icon_take_photo"];
    } else {
        //_backgroundView.image = [UIImage imageNamed:@"blur_bg"];
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _cameraView.image = [UIImage imageNamed:@"icon_take_photo"];
    }
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY
{
    contentOffsetY = MAX(0, MIN(contentOffsetY, self.bounds.size.height));
    
    if (_contentOffsetY != contentOffsetY) {
        _contentOffsetY = contentOffsetY;
        
        CGRect frame = self.bounds;
        frame.origin.y = self.contentOffsetY;
        self.contentView.frame = frame;
    }
}

@end
