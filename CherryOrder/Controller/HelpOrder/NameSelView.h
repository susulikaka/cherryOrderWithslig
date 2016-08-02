//
//  PublishCommodityPicView.h
//  lukou
//
//  Created by ZHAOYU on 15/6/25.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameSelView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel     * name;

@property (nonatomic, weak) IBOutlet UIImageView * mark;

//@property (nonatomic) BOOL isSelected;

@property (nonatomic) BOOL enabled;

- (void)renderWithName:(NSString *)name enabled:(BOOL)enabled;

@end
