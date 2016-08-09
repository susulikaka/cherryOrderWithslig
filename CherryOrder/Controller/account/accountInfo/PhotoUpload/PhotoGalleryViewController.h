//
//  PhotoGalleryViewController.h
//  Lukou
//
//  Created by Zhao Yu on 12/25/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectablePhotoAssets;

@interface PhotoGalleryViewController : UIViewController

- (instancetype)initWithPhotoAssets:(SelectablePhotoAssets *)photos;

@property (nonatomic, readonly) SelectablePhotoAssets *photoAssets;

@property (nonatomic, assign) NSUInteger startPhotoIndex;

@property (nonatomic, readonly) UICollectionView *galleryView;

- (CGRect)visibleImageFrame;
- (NSUInteger)visiblePhotoIndex;

@end
