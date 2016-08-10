//
//  SelectablePhotoAssets.h
//  Lukou
//
//  Created by Zhao Yu on 12/25/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class PhotoAsset;

@interface SelectablePhotoAssets : NSObject

+ (void)requestPhotoLibraryAccessWithCompletion:(void (^)(BOOL authorized))completion;

@property (nonatomic, readonly) NSArray *assets;
@property (nonatomic, readonly) ALAssetsLibrary *assetsLibrary;

// KVO compliant
@property (nonatomic, readonly) NSUInteger numberOfSelectedPhotos;

@property (nonatomic, readonly) NSUInteger maxSelectionCount;

- (instancetype)initWithMaxSelectionCount:(NSUInteger)max;
- (instancetype)initWithAssets:(NSArray *)assets
                 assetsLibrary:(ALAssetsLibrary *)assetsLibrary
                   allSelected:(BOOL)allSelected
             maxSelectionCount:(NSUInteger)max;
- (instancetype)selectedPhotoAssets;

- (void)reloadAllPhotosWithCompletion:(void (^)(NSError *))completion;

- (void)insertAsset:(PhotoAsset *)photoAsset atIndex:(NSUInteger)index selected:(BOOL)selected;

- (BOOL)isPhotoAtIndexSelected:(NSUInteger)index;
- (BOOL)setSelection:(BOOL)selected forPhotoAtIndex:(NSUInteger)index;
- (BOOL)selectPhotos:(NSArray *)photos deselectOthers:(BOOL)deselectOthers;
- (NSArray *)selectedPhotos;

- (void)removeUnselectedPhotos;

- (UIImage *)thumbnailImageAtIndex:(NSUInteger)index;
- (UIImage *)aspectRatioThumbnailImageAtIndex:(NSUInteger)index;
- (UIImage *)fullImageAtIndex:(NSUInteger)index;
- (UIImage *)fullImageAtIndexIfCached:(NSUInteger)index;

@end
