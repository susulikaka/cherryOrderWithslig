//
//  SearchWordsCell.h
//  lukou
//
//  Created by XuFeiFeng on 15/6/29.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchWordsCell : UITableViewCell

- (void)initWithDataSource:(NSArray *)words
                     onTap:(void(^)(NSString *name))tapBlock;

@end
