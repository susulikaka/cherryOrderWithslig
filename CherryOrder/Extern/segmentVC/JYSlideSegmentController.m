//
//  JYSlideSegmentController.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "JYSlideSegmentController.h"
//#import "LKCustomTableViewController.h"
//#import "LKCollectionViewFlowController.h"
//#import "LKAnimationRefreshController.h"
#import "UIScrollView+AllowPanGestureEventPass.h"
#import "AppDelegate.h"

#define SEGMENT_BAR_HEIGHT 40
#define INDICATOR_HEIGHT 2

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString * const segmentBarItemID = @"JYSegmentBarItem";

@implementation JYSegmentBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.bounds = CGRectMake(0, 0, self.contentView.bounds.size.width * 0.6,  self.contentView.bounds.size.height * 0.6);
        _titleLabel.center = self.contentView.center;
        _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

@interface JYSlideSegmentController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong, readwrite) UIView *indicator;
@property (nonatomic, strong, readwrite) UIView *saparator;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;
@property (nonatomic, readonly) UIEdgeInsets segmentBarInsets;
@property (nonatomic, readonly) CGFloat segmentBarHeight;

- (void)reset;

@end

@implementation JYSlideSegmentController
@synthesize viewControllers = _viewControllers;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        _selectedIndex = NSNotFound;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubviews];
    [self layoutSubViews];
    [self reset];
    
    [RACObserve(self, slideView.contentSize) subscribeNext:^(id x) {
        [self adjustIndicatorFrame];
        CGFloat saparatorWidth = MAX(self.segmentBar.contentSize.width,
                                     self.segmentBar.frame.size.width);
        CGRect originFrame = self.saparator.frame;
        originFrame.size.width = saparatorWidth;
        self.saparator.frame = originFrame;
    }];
    
    UIGestureRecognizer *gestureRecognizer = ((AppDelegate *)[UIApplication sharedApplication].delegate).navigationVC.interactivePopGestureRecognizer;
    [self.slideView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
} 

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutSubViews];
    [self adjustIndicatorFrame];
    [self.segmentBar reloadData];
}

#pragma mark - Setup
- (void)setupSubviews {
    // iOS7 set layout
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self.view addSubview:self.segmentBar];
    [self.segmentBar addSubview:self.saparator];
    [self.segmentBar addSubview:self.indicator];
   
    [self.view addSubview:self.slideView];
    [self.segmentBar registerClass:[JYSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
}

- (void)layoutSubViews {
    CGRect segmentBarframe = self.view.bounds;
    segmentBarframe.size.height = self.segmentBarHeight;
    self.segmentBar.frame = segmentBarframe;
    CGRect indicatorFrame = CGRectMake(self.segmentBarInsets.left,
                                       self.segmentBar.frame.size.height - INDICATOR_HEIGHT,
                                       0,
                                       INDICATOR_HEIGHT);
    self.indicator.frame = indicatorFrame;
    self.saparator.frame = CGRectMake(0,
                                      segmentBarframe.size.height - 0.5,
                                      SCREEN_WIDTH,
                                      0.5);
    
    CGRect slideViewFrame = self.view.bounds;
    slideViewFrame.size.height -= _segmentBar.frame.size.height;
    slideViewFrame.origin.y = CGRectGetMaxY(_segmentBar.frame);
    self.slideView.frame = slideViewFrame;
    
    [self layoutSubviewsOfSlideView];
}

#pragma mark - Property
- (UIScrollView *)slideView {
    if (!_slideView) {
        _slideView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
        [_slideView setScrollsToTop:NO];
    }
    return _slideView;
}

- (UICollectionView *)segmentBar {
    if (!_segmentBar) {
        _segmentBar = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_segmentBar setShowsHorizontalScrollIndicator:NO];
        [_segmentBar setShowsVerticalScrollIndicator:NO];
        _segmentBar.bounces = NO;
        _segmentBar.scrollsToTop = NO;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
        
    }
    return _segmentBar;
}

- (UIView *)saparator {
    if (!_saparator) {
        _saparator = [[UIView alloc] init];
        _saparator.backgroundColor = UIColorFromRGB(0xdcdcdc);
    }
    return _saparator;
}

- (UIEdgeInsets)segmentBarInsets {
    return UIEdgeInsetsZero;
}

- (CGFloat)segmentBarHeight {
    return SEGMENT_BAR_HEIGHT;
}

- (UIView *)indicator {
    if (!_indicator) {
        _indicator = [[UIView alloc] initWithFrame:CGRectZero];
        _indicator.backgroundColor = [UIColor redColor];
    }
    return _indicator;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.sectionInset = self.segmentBarInsets;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);
    
    UIViewController *preSelectController = _selectedIndex == NSNotFound ? nil : [self.viewControllers objectAtIndex:_selectedIndex];
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * selectedIndex;
    toSelectController.view.frame = rect;
    
    // Update view controllers' scrollsToTop attribute if needed
//    if (preSelectController && [preSelectController isKindOfClass:[LKCustomTableViewController class]]) {
//        ((LKCustomTableViewController *)preSelectController).tableView.scrollsToTop = NO;
//    }
//    if (preSelectController && [preSelectController isKindOfClass:[LKCollectionViewFlowController class]]) {
//        ((LKCollectionViewFlowController *)preSelectController).collectionView.scrollsToTop = NO;
//    }
//    if ([toSelectController isKindOfClass:[LKCustomTableViewController class]]) {
//        ((LKCustomTableViewController *)toSelectController).tableView.scrollsToTop = YES;
//    }
//    if ([toSelectController isKindOfClass:[LKCollectionViewFlowController class]]) {
//        ((LKCollectionViewFlowController *)toSelectController).collectionView.scrollsToTop = YES;
//    }
    _selectedIndex = selectedIndex;

    [self.segmentBar reloadData];
}

- (void)layoutSubviewsOfSlideView {
    int i = 0;
    for (UIViewController *vc in self.viewControllers) {
        if (vc.parentViewController) {
            CGRect rect = self.slideView.bounds;
            rect.origin.x = rect.size.width * i;
            vc.view.frame = rect;
        }
        i++;
    }
    CGSize conentSize = CGSizeMake(SCREEN_WIDTH * self.viewControllers.count, 0);
    [self.slideView setContentSize:conentSize];
    if (self.selectedIndex != NSNotFound) {
        [self scrollToViewWithIndex:self.selectedIndex animated:YES];
    }
}

- (NSArray *)viewControllers
{
    return [_viewControllers copy];
}

- (UIViewController *)selectedViewController
{
    if (self.selectedIndex == NSNotFound) {
        return nil;
    }
    return self.viewControllers[self.selectedIndex];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
        return [_dataSource numberOfSectionsInslideSegment:collectionView];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
        return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
    }
    return self.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = self.fixedBarItemWidth;
    if (!itemWidth) {
        itemWidth = self.view.frame.size.width / self.viewControllers.count;
    }
    return CGSizeMake(itemWidth, self.segmentBarHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
        return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    JYSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID
                                                                                 forIndexPath:indexPath];
    UIViewController *vc = self.viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
        [_delegate slideSegment:collectionView didSelectedViewController:vc];
    }
    if (indexPath.row == self.selectedIndex) {
//        if ([self.selectedViewController isKindOfClass:[UITableViewController class]]) {
//            [((LKCustomTableViewController *)self.selectedViewController).tableView setContentOffset:CGPointZero
//                                                                                            animated:YES];
//        }
//        if ([self.selectedViewController isKindOfClass:[UICollectionViewController class]]) {
//            [((LKCollectionViewFlowController *)self.selectedViewController).collectionView setContentOffset:CGPointZero
//                                                                                                    animated:YES];
//        }
    }
    [self scrollToViewWithIndex:indexPath.row animated:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(slideSegment:shouldSelectViewController:)]) {
        flag = [_delegate slideSegment:collectionView shouldSelectViewController:vc];
    }
    return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.slideView) {
        [self adjustIndicatorFrame];
        
        NSInteger index = (self.slideView.contentOffset.x / self.slideView.contentSize.width) * self.viewControllers.count;
        if (index >= 0 && index < self.viewControllers.count) {
            if (index != self.selectedIndex) {
                [self setSelectedIndex:index];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.slideView) {
        [self adjustSegmentBarContentOffsetX];
    }
}

- (void)adjustSegmentBarContentOffsetX {
    CGPoint contentOffset = self.segmentBar.contentOffset;
    CGFloat barWidth = self.segmentBar.frame.size.width;
    
    BOOL indicatorOnTheRightEdge = (contentOffset.x + barWidth < CGRectGetMaxX(self.indicator.frame));
    
    BOOL indicatorOnTheLeftEdge = (contentOffset.x > CGRectGetMinX(self.indicator.frame));
    
    if (indicatorOnTheRightEdge) {
        contentOffset.x = MIN(self.indicator.frame.origin.x, self.segmentBar.contentSize.width - self.segmentBar.frame.size.width);
    } else if (indicatorOnTheLeftEdge) {
        contentOffset.x = CGRectGetMaxX(self.indicator.frame) - self.segmentBar.frame.size.width;
    }
    contentOffset.x = MAX(contentOffset.x, 0);
    [self.segmentBar setContentOffset:contentOffset animated:YES];
}

- (void)adjustIndicatorFrame {
    if (self.slideView.contentSize.width == 0) {
        return;
    }
    CGRect frame = self.indicator.frame;
    CGFloat n = (self.slideView.contentOffset.x / self.slideView.frame.size.width);
    CGFloat percent = n - (int)n;
   
    NSInteger index = (self.slideView.contentOffset.x / self.slideView.contentSize.width) * self.viewControllers.count;
    
    UICollectionViewCell *cell = [self collectionView:self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                                inSection:0]];
    CGFloat deltaOriginX = cell.frame.size.width * percent;
    frame.origin.x = cell.frame.origin.x + deltaOriginX;
    
    BOOL isLastPage = (index >= self.viewControllers.count - 1);
    if (!isLastPage) {
        UICollectionViewCell *nextCell = [self collectionView:self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index + 1
                                                                                                                        inSection:0]];
        CGFloat deltaWidth = cell.frame.size.width + (nextCell.frame.size.width - cell.frame.size.width) * percent;
        frame.size.width = deltaWidth;
    } else {
        frame.size.width = cell.frame.size.width;
    }
    self.indicator.frame = frame;
}

#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated {
    [self setSelectedIndex:index];
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * index;
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
   
    [self adjustSegmentBarContentOffsetX];
}

- (void)reset {
    _selectedIndex = NSNotFound;
    [self scrollToViewWithIndex:0 animated:NO];
}

@end
