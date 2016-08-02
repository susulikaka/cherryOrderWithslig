//
//  SearchWordsCell.m
//  lukou
//
//  Created by XuFeiFeng on 15/6/29.
//  Copyright (c) 2015年 lukou. All rights reserved.
//

#import "SearchWordsCell.h"

#import "PureLayout.h"

@interface SearchWordsCell() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView    * collectionView;
@property (nonatomic, strong) NSArray                    * orderUserList;
@property (nonatomic, copy) void(^tapWordBlock)(NSString * name);

@end

@implementation SearchWordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

- (void)initWithDataSource:(NSArray *)words
                  onTap:(void(^)(NSString *name))tapBlock {
    self.orderUserList = words;
    self.tapWordBlock = tapBlock;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.orderUserList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *name = [self.orderUserList objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])
                                                                                     forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, NAME_COLLECTION_CELL_WIDTH, NAME_COLLECTION_CELL_WIDTH);
    label.layer.borderWidth = 0.5;
    label.layer.borderColor = DARK_MAIN_COLOR.CGColor;
    label.layer.cornerRadius = label.bounds.size.height/2;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = LK_TEXT_COLOR_GRAY;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [UIColor whiteColor];
    if (name.length > 2) {
        label.text = [name substringWithRange:NSMakeRange(name.length - 2, 2)];
    } else {
        label.text = name;
    }
    
    for (int i = (int)cell.contentView.subviews.count - 1; i >= 0; i --) {
        UIView *subView = [cell.contentView.subviews lastObject];
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:label];
    [label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *word = [self.orderUserList objectAtIndex:indexPath.row];
    if (self.tapWordBlock) {
        self.tapWordBlock(word);
    }
}

@end
