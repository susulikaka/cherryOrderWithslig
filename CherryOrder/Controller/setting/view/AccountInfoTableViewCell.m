//
//  AccountInfoTableViewCell.m
//  CherryOrder
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AccountInfoTableViewCell.h"

@implementation AccountInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accountImg.layer.cornerRadius = self.accountImg.bounds.size.height/2;
    self.accountImg.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
