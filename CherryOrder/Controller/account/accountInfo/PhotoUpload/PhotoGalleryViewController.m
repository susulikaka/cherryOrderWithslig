//
//  PhotoGalleryViewController.m
//  Lukou
//
//  Created by Zhao Yu on 12/25/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import "SelectablePhotoAssets.h"
#import "ImageScrollView.h"

#define IMAGE_VIEW_TAG 100

@interface PhotoGalleryViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation PhotoGalleryViewController {
    UIButton *_checkButton;
    BOOL _scrolledToStartPoint;
}

- (instancetype)initWithPhotoAssets:(SelectablePhotoAssets *)photos
{
    if ( (self = [super initWithNibName:nil bundle:nil]) ) {
        _photoAssets = photos;
        [self.navigationController setNavigationBarHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, layout.minimumInteritemSpacing);
    _galleryView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _galleryView.frame = [self _lk_galleryViewFrame];
    _galleryView.dataSource = self;
    _galleryView.delegate = self;
    _galleryView.pagingEnabled = YES;
    [_galleryView registerClass:[UICollectionViewCell class]
     forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [self.view addSubview:_galleryView];
    
    UIView *navigationBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    navigationBackgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationBackgroundView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"left-arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(_lk_back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton.frame = ({
        CGRect frame;
        frame.size = CGSizeMake(40, 40);
        frame.origin = CGPointMake(0, CGRectGetMaxY([[UIApplication sharedApplication] statusBarFrame]) + (44 - frame.size.height) / 2);
        CGRectIntegral(frame);
    });
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkButton setImage:[UIImage imageNamed:@"icon_check_gray_bordered"] forState:UIControlStateNormal];
    [_checkButton setImage:[UIImage imageNamed:@"icon_check_blue_bordered"] forState:UIControlStateSelected];
    [_checkButton addTarget:self action:@selector(_lk_check) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkButton];
    _checkButton.selected = [self.photoAssets isPhotoAtIndexSelected:self.startPhotoIndex];
    _checkButton.frame = ({
        CGRect frame;
        frame.size = CGSizeMake(40, 40);
        frame.origin = CGPointMake(self.view.bounds.size.width - backButton.frame.origin.x - frame.size.width,
                                   CGRectGetMidY(backButton.frame) - frame.size.height / 2);
        CGRectIntegral(frame);
    });
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _galleryView.frame = [self _lk_galleryViewFrame];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_galleryView.collectionViewLayout;
    layout.itemSize = CGSizeMake(_galleryView.bounds.size.width - layout.minimumInteritemSpacing,
                                 _galleryView.bounds.size.height);
    
    if (!_scrolledToStartPoint) {
        _scrolledToStartPoint = YES;
        [_galleryView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.startPhotoIndex inSection:0]
                             atScrollPosition:UICollectionViewScrollPositionLeft
                                     animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_lk_reloadPhotoLibrary)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isMovingToParentViewController]) {
        [self _lk_loadFullImageAtPageIfNeeded:[self visiblePhotoIndex]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (CGRect)visibleImageFrame
{
    UICollectionViewCell *cell = [[_galleryView visibleCells] firstObject];
    ImageScrollView *imageView = (ImageScrollView *)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    UIView *view = [imageView.delegate viewForZoomingInScrollView:imageView];
    return [self.view convertRect:view.bounds fromView:view];
}

- (NSUInteger)visiblePhotoIndex
{
    NSIndexPath *indexPath = [[_galleryView indexPathsForVisibleItems] firstObject];
    return indexPath ? indexPath.row : self.startPhotoIndex;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoAssets.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    ImageScrollView *imageView = (ImageScrollView *)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    if (imageView == nil) {
        imageView = [[ImageScrollView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:imageView];
    }
    [imageView displayImage:([self.photoAssets fullImageAtIndexIfCached:indexPath.row] ?: [self.photoAssets aspectRatioThumbnailImageAtIndex:indexPath.row])];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = [self visiblePhotoIndex];
    _checkButton.selected = [self.photoAssets isPhotoAtIndexSelected:index];
    [self _lk_loadFullImageAtPageIfNeeded:index];
}

#pragma mark - Actions

- (void)_lk_back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_lk_check
{
    NSUInteger index = [self visiblePhotoIndex];
    if (![self.photoAssets setSelection:!_checkButton.selected forPhotoAtIndex:index]) {
        [LKUIUtils showError:[NSString stringWithFormat:@"最多选择 %ld 张图片", self.photoAssets.maxSelectionCount]];
    }
    _checkButton.selected = [self.photoAssets isPhotoAtIndexSelected:index];
}

- (void)_lk_loadFullImageAtPageIfNeeded:(NSUInteger)page
{
    if ([self.photoAssets fullImageAtIndexIfCached:page] == nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.photoAssets fullImageAtIndex:page];
            [_galleryView performSelectorOnMainThread:@selector(reloadItemsAtIndexPaths:)
                                           withObject:@[[NSIndexPath indexPathForItem:page inSection:0]]
                                        waitUntilDone:NO];
        });
    }
}

- (void)_lk_reloadPhotoLibrary{
    [self.photoAssets reloadAllPhotosWithCompletion:^(NSError *error) {
        if (error) {
            [LKUIUtils showError:@"加载照片库失败"];
        }
        [self.galleryView reloadData];
    }];
}

#pragma mark - Private methods

- (CGRect)_lk_galleryViewFrame
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_galleryView.collectionViewLayout;
    CGRect frame;
    frame.origin = CGPointMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame));
    frame.size = CGSizeMake(self.view.bounds.size.width + layout.minimumInteritemSpacing,
                            self.view.bounds.size.height - frame.origin.y);
    return frame;
}

@end
