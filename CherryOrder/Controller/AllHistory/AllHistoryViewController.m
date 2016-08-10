//
//  AllHistoryViewController.m
//  CherryOrder
//
//  Created by admin on 16/8/10.
//  Copyright © 2016年 SupingLi. All rights reserved.
//

#import "AllHistoryViewController.h"
#import "AllOrderHistoryViewController.h"
#import "AllCouldExpenseViewController.h"
#import "JYSlideSegmentController.h"
#import "SearchUserViewController.h"

@interface AllHistoryViewController ()<JYSlideSegmentDelegate,JYSlideSegmentDataSource>

@property (strong, nonatomic) JYSlideSegmentController * segmentVC;
@property (strong, nonatomic) NSArray * titleArr;
@property (strong, nonatomic) NSArray * VCs;

@end

@implementation AllHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArr = @[@"订餐历史",@"可报销历史",@"查询"];
    [self setUpSegment];
}

- (void)setUpSegment {
    CGRect frame = self.view.bounds;
    self.segmentVC.view.frame = frame;
    self.segmentVC.indicator.backgroundColor = MAIN_COLOR;
    [self.view addSubview:self.segmentVC.view];
    [self addChildViewController:self.segmentVC];
    [self.segmentVC didMoveToParentViewController:self];
}

#pragma mark - segment

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section {
    return self.VCs.count;
}

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYSegmentBarItem * item = [segmentBar dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JYSegmentBarItem class]) forIndexPath:indexPath];
    
    [self configSegmentItem:item withTitle:self.titleArr[indexPath.row] atIndexPath:indexPath];
    return item;
}

- (void)configSegmentItem:(JYSegmentBarItem *)item
                withTitle:(NSString *)title
              atIndexPath:(NSIndexPath *)indexPath{
    item.titleLabel.layer.borderColor = LK_BACK_COLOR_LIGHT_GRAY.CGColor;
    item.titleLabel.layer.borderWidth = 1;
    item.titleLabel.layer.cornerRadius = 5;
    item.titleLabel.layer.masksToBounds = YES;
    item.titleLabel.highlightedTextColor = MAIN_COLOR;
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    item.titleLabel.text = title;
    if (indexPath.row == self.segmentVC.selectedIndex) {
        item.titleLabel.textColor = MAIN_COLOR;
    } else {
        item.titleLabel.textColor = LK_TEXT_COLOR_GRAY;
    }
}

#pragma mark - getter

- (NSArray *)VCs {
    if (!_VCs) {
        _VCs = ({
            AllOrderHistoryViewController * orderVC = [[AllOrderHistoryViewController alloc] initWithNibName:nil bundle:nil];
            AllCouldExpenseViewController * expenseVC = [[AllCouldExpenseViewController alloc] initWithNibName:nil bundle:nil];
            SearchUserViewController * searchVC = [[SearchUserViewController alloc] initWithNibName:nil bundle:nil];
            NSArray * arr = [NSArray arrayWithObjects:orderVC,expenseVC,searchVC,nil];
            arr;
        });
    }
    return _VCs;
}

- (JYSlideSegmentController *)segmentVC {
    if (!_segmentVC) {
        _segmentVC = ({
            JYSlideSegmentController * vc = [[JYSlideSegmentController alloc] initWithViewControllers:self.VCs];
            vc.delegate = self;
            vc.dataSource = self;
            vc;
        });
    }
    return _segmentVC;
}

@end
