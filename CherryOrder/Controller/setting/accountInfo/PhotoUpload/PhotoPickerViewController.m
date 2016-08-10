//
//  PhotoPickerViewController.m
//  Lukou
//
//  Created by Zhao Yu on 12/24/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "PhotoPickerViewController.h"
#import "PhotoGalleryViewController.h"
//#import "LKViewController.h"
#import "SelectablePhotoAssets.h"
#import "PhotoAsset.h"
#import "PhotoGridCell.h"
#import "PhotoCameraView.h"

#define CAMERA_BG_HEIGHT [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout headerReferenceSize].height

@interface PhotoPickerViewController ()<UIAlertViewDelegate>

@property (nonatomic, weak) PhotoCameraView *cameraBgView;
@property (nonatomic, readonly) UIBarButtonItem *confirmBarButton;
@property (nonatomic, readonly) UILabel *selectedPhotosLabel;
@property (nonatomic, strong) NSSet *assetURLsToBeSelected;

@end

@implementation PhotoPickerViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithPhotoAssets:nil];
}

- (instancetype)initWithPhotoAssets:(SelectablePhotoAssets *)photos
{
    if ( (self = [super initWithNibName:nil bundle:nil]) ) {
        self.title = @"选择照片";
        
        _viewCompact = NO;
        _photoAssets = photos ?: [[SelectablePhotoAssets alloc] initWithMaxSelectionCount:1];
        
        const CGFloat spacing = 2;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = flowLayout.minimumInteritemSpacing = spacing;
        flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
        NSUInteger columns = 3;
        CGFloat size = SCREEN_WIDTH - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
        size = floorf((size - (columns - 1) * flowLayout.minimumInteritemSpacing) / columns);
        flowLayout.itemSize = CGSizeMake(size, size);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(_lk_cancel)];
    _confirmBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(_lk_confirm)];
    _selectedPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _selectedPhotosLabel.backgroundColor = MAIN_COLOR;
    _selectedPhotosLabel.font = [UIFont systemFontOfSize:12];
    _selectedPhotosLabel.textColor = [UIColor whiteColor];
    _selectedPhotosLabel.textAlignment = NSTextAlignmentCenter;
    _selectedPhotosLabel.layer.cornerRadius = _selectedPhotosLabel.bounds.size.width / 2;
    _selectedPhotosLabel.layer.masksToBounds = YES;
    
    self.navigationItem.rightBarButtonItems = @[_confirmBarButton, [[UIBarButtonItem alloc] initWithCustomView:_selectedPhotosLabel]];
    
    self.collectionView.frame = self.view.bounds;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    [self.collectionView registerClass:[PhotoCameraView class] forCellWithReuseIdentifier:NSStringFromClass([PhotoCameraView class])];
    [self.collectionView registerClass:[PhotoGridCell class]
            forCellWithReuseIdentifier:NSStringFromClass([PhotoGridCell class])];
    [self _lk_configCollectionView];
    [self.view addSubview:self.collectionView];
    
    [self _lk_reloadPhotoLibrary];
    
    @weakify(self);
    [RACObserve(self.photoAssets, numberOfSelectedPhotos) subscribeNext:^(NSNumber *number) {
        @strongify(self);
        self.confirmBarButton.enabled = number.unsignedIntegerValue > 0;
        self.selectedPhotosLabel.text = number.stringValue;
        self.selectedPhotosLabel.hidden = number.unsignedIntegerValue == 0;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (![self isMovingFromParentViewController]) {
        [self.collectionView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_lk_reloadPhotoLibrary)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - Public methods

- (void)setViewCompact:(BOOL)viewCompact
{
    _viewCompact = viewCompact;
    [self _lk_configCollectionView];
}

- (void)selectAssetWithURLs:(NSSet *)urls
{
    if (urls.count > 0) {
        self.assetURLsToBeSelected = [urls copy];
        
        if (self.photoAssets.assets.count > 0) {
            [self _lk_performAssetsSelection];
        }
    }
}

#pragma mark - Private methods

- (void)_lk_configCollectionView
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (self.viewCompact) {
        layout.headerReferenceSize = CGSizeZero;
    } else {
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 150);
        [self.collectionView registerClass:[PhotoCameraView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:NSStringFromClass([PhotoCameraView class])];
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = _photoAssets.assets.count;
    return self.viewCompact ? ++count : count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                        withReuseIdentifier:NSStringFromClass([PhotoCameraView class])
                                                                               forIndexPath:indexPath];
    _cameraBgView = (PhotoCameraView *)view;
    _cameraBgView.compact = NO;
    if ([[_cameraBgView gestureRecognizers] count] == 0) {
        [_cameraBgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_lk_cameraAction)]];
    }
    return view;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger photoIndex = [self _lk_photoIndexAtIndexPath:indexPath];
    if (self.viewCompact && indexPath.row == 0) {
        PhotoCameraView *cameraView = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoCameraView class])
                                                                                   forIndexPath:indexPath];
        [cameraView setCompact:YES];
        [cameraView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_lk_cameraAction)]];
        return cameraView;
    }
    
    PhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PhotoGridCell class])
                                                                       forIndexPath:indexPath];
    // In iOS9, default thumbnail size of ALAsset is much more smaller than iOS8-.
    // We must use aspectRatioThumbnail to get bigger size image data.(Poor performance!!!)
    // In some day we say fuck to iOS7, we can use new PhotoKit(born in iOS8) to do photo picker stuff.
    if (IS_iOS9) {
        cell.imageView.image = [self.photoAssets aspectRatioThumbnailImageAtIndex:photoIndex];
    } else {
        cell.imageView.image = [self.photoAssets thumbnailImageAtIndex:photoIndex];
    }
    cell.checkButton.selected = [self.photoAssets isPhotoAtIndexSelected:photoIndex];
    if ([[cell.checkButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] == 0) {
        [cell.checkButton addTarget:self
                             action:@selector(_lk_photoCheckButtonAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewCompact && indexPath.row == 0) {
        return;
    }
    NSInteger photoIndex = [self _lk_photoIndexAtIndexPath:indexPath];
    PhotoGalleryViewController *controller = [[PhotoGalleryViewController alloc] initWithPhotoAssets:self.photoAssets];
    controller.startPhotoIndex = photoIndex;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _cameraBgView.contentOffsetY = scrollView.contentOffset.y;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [SVProgressHUD showWithStatus:@"保存照片…" maskType:SVProgressHUDMaskTypeClear];
    
    void (^failure)() = ^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    };
    
    void (^completion)() = ^(NSURL *assetURL, NSError *error) {
        if (assetURL == nil) {
            failure(error);
            return ;
        }
        
        [self.photoAssets.assetsLibrary assetForURL:assetURL
                                        resultBlock:^(ALAsset *asset) {
                                            [SVProgressHUD showSuccessWithStatus:@"照片已保存"];
                                            
                                            NSUInteger indexRow = self.viewCompact ? 1 : 0;
                                            [self.photoAssets insertAsset:[[PhotoAsset alloc] initWithALAsset:asset] atIndex:0 selected:YES];
                                            [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:indexRow inSection:0]]];
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }
                                       failureBlock:failure];
    };
    
    [self.photoAssets.assetsLibrary writeImageDataToSavedPhotosAlbum:UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 1)
                                                            metadata:info[UIImagePickerControllerMediaMetadata]
                                                     completionBlock:completion];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)_lk_cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_lk_confirm
{
    if (self.selectionDoneAction) {
        self.selectionDoneAction();
    }
}

- (void)_lk_photoCheckButtonAction:(UIButton *)button
{
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[self.collectionView convertPoint:button.center fromView:button.superview]];
    NSInteger photoIndex = [self _lk_photoIndexAtIndexPath:indexPath];
    if ([self.photoAssets setSelection:!button.selected forPhotoAtIndex:photoIndex]) {
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else {
        [LKUIUtils showError:[NSString stringWithFormat:@"最多选择 %ld 张图片", self.photoAssets.maxSelectionCount]];
    }
}

- (NSInteger)_lk_photoIndexAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger photoIndex = indexPath.row;
    return self.viewCompact ? --photoIndex : photoIndex;
}

- (void)_lk_cameraAction
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
#define TAKE_PICTURE \
do { \
UIImagePickerController *controller = [[UIImagePickerController alloc] init]; \
controller.sourceType = UIImagePickerControllerSourceTypeCamera; \
controller.delegate = self; \
[self presentViewController:controller animated:YES completion:nil]; \
} while(0)
    
#define SHOW_ERROR \
do { \
[[[UIAlertView alloc] initWithTitle:@"提示" \
message:@"请打开系统设置，进入「隐私」->「相机」，允许路口访问相机。" \
delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil] show]; \
} while (0)
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            TAKE_PICTURE;
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            SHOW_ERROR;
            break;
        case AVAuthorizationStatusNotDetermined:
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    TAKE_PICTURE;
                } else {
                    SHOW_ERROR;
                }
            }];
            break;
    }
    
#undef TAKE_PICTURE
#undef SHOW_ERROR
}

- (void)_lk_reloadPhotoLibrary
{
    [LKUIUtils showProgressDialog:@"正在加载照片库…"];
    [self.photoAssets reloadAllPhotosWithCompletion:^(NSError *error) {
        [LKUIUtils dismissProgressDialog];
        if (error) {
            if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"没有权限访问你的手机相册" message:@"请到手机系统的设置>隐私>照片中允许路口访问" delegate:self cancelButtonTitle:@"请到手机系统的设置>隐私>照片中允许路口访问" otherButtonTitles:@"", nil];
                [self.view addSubview:alert];
                [alert show];
            
            } else {
                [LKUIUtils showError:@"加载照片库失败"];
            }
            return;
        }
        
        [self _lk_performAssetsSelection];
        
        [self.collectionView reloadData];
    }];
}

- (void)_lk_performAssetsSelection
{
    if (self.assetURLsToBeSelected == nil) {
        return;
    }
    
    NSUInteger __block selected = 0;
    [self.photoAssets.assets enumerateObjectsUsingBlock:^(PhotoAsset *photoAsset, NSUInteger idx, BOOL *stop) {
        if ([self.assetURLsToBeSelected containsObject:photoAsset.identifier]) {
            [self.photoAssets setSelection:YES forPhotoAtIndex:idx];
            
            *stop = ++selected == self.assetURLsToBeSelected.count;
        }
    }];
    
    self.assetURLsToBeSelected = nil;
}

#pragma mark - delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else if (buttonIndex == 1) {
    }
}

@end
