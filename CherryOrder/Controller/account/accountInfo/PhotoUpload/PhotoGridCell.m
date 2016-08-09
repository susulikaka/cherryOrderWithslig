//
// Created by Zhao Yu on 12/24/14.
// Copyright (c) 2014 Lukou. All rights reserved.
//

#import <PureLayout/PureLayout.h>
#import "PhotoGridCell.h"

@implementation PhotoGridCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -5, -5)];
        [_checkButton setImage:[UIImage imageNamed:@"icon_check_gray_bordered"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"icon_check_blue_bordered"] forState:UIControlStateSelected];
        [self.contentView addSubview:_checkButton];
        
        [_imageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        [self.checkButton autoSetDimensionsToSize:CGSizeMake(frame.size.width / 2, frame.size.height / 2)];
        [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [self.checkButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    }
    return self;
}

@end
