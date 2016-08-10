//
//  PhotoPickerViewController.h
//  Lukou
//
//  Created by Zhao Yu on 12/24/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectablePhotoAssets;

@interface PhotoPickerViewController : UIViewController<UICollectionViewDataSource,
  UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (instancetype)initWithPhotoAssets:(SelectablePhotoAssets *)photos;

@property (nonatomic, readonly) SelectablePhotoAssets *photoAssets;
@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL viewCompact;

@property (nonatomic, strong) void (^selectionDoneAction)();

- (void)selectAssetWithURLs:(NSSet *)urls;

@end
