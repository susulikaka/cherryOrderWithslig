//
//  SelectablePhotoAssets.m
//  Lukou
//
//  Created by Zhao Yu on 12/25/14.
//  Copyright (c) 2014 Lukou. All rights reserved.
//

#import "SelectablePhotoAssets.h"
#import "PhotoAsset.h"

static NSString * const kLKCacheKeyFull = @"full";
static NSString * const kLKCacheKeyThumbnail = @"thumbnail";
static NSString * const kLKCacheKeyAspectRatioThumbnail = @"aspect-thumbnail";

@interface SelectablePhotoAssets ()

@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation SelectablePhotoAssets {
  NSMutableIndexSet *_selectedIndexSet;
}

+ (void)requestPhotoLibraryAccessWithCompletion:(void (^)(BOOL authorized))completion
{
  [[[ALAssetsLibrary alloc] init] enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                                  *stop = YES;
                                                  if (group == nil) {
                                                    completion(YES);
                                                  }
                                                }
                                              failureBlock:^(NSError *error) {
                                                completion(NO);
                                              }];
}

- (instancetype)init
{
  return [self initWithMaxSelectionCount:NSNotFound];
}

- (instancetype)initWithMaxSelectionCount:(NSUInteger)max
{
  return [self initWithAssets:nil assetsLibrary:nil allSelected:NO maxSelectionCount:max];
}

- (instancetype)initWithAssets:(NSArray *)assets
                 assetsLibrary:(ALAssetsLibrary *)assetsLibrary
                   allSelected:(BOOL)allSelected
             maxSelectionCount:(NSUInteger)max
{
  if ( (self = [super init]) ) {
    _imageCache = [[NSCache alloc] init];
    _assets = [assets copy];
    _assetsLibrary = assetsLibrary ?: [[ALAssetsLibrary alloc] init];
    _maxSelectionCount = max;

    _selectedIndexSet = [NSMutableIndexSet indexSet];
    if (allSelected) {
      [_selectedIndexSet addIndexesInRange:NSMakeRange(0, _assets.count)];
    }

    NSAssert(_selectedIndexSet.count <= max, @"too many selected assets");
  }
  return self;
}

- (void)reloadAllPhotosWithCompletion:(void (^)(NSError *))completion
{
  NSParameterAssert(completion != nil);

  [self _lk_loadAllPhotosWithCompletion:^(NSArray *assets, NSError *error) {
    [self _lk_replaceWithAssets:assets];
    completion(error);
  }];
}

- (void)insertAsset:(PhotoAsset *)photoAsset atIndex:(NSUInteger)index selected:(BOOL)selected
{
  if (selected && _selectedIndexSet.count + 1 > self.maxSelectionCount) {
    selected = NO;
  }

  NSMutableArray *assets = [_assets mutableCopy];
  [assets insertObject:photoAsset atIndex:index];
  _assets = [assets copy];

  [_selectedIndexSet shiftIndexesStartingAtIndex:index by:1];

  if (selected) {
    [self willChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
    [_selectedIndexSet addIndex:index];
    [self didChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
  }
}

- (BOOL)isPhotoAtIndexSelected:(NSUInteger)index
{
  return [_selectedIndexSet containsIndex:index];
}

- (BOOL)setSelection:(BOOL)selected forPhotoAtIndex:(NSUInteger)index
{
  if (selected && _selectedIndexSet.count + 1 > self.maxSelectionCount) {
    return NO;
  }

  if ([self isPhotoAtIndexSelected:index] != selected) {
    [self willChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
    if (selected) {
      [_selectedIndexSet addIndex:index];
    } else {
      [_selectedIndexSet removeIndex:index];
    }
    [self didChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
  }

  return YES;
}

- (BOOL)selectPhotos:(NSArray *)photos deselectOthers:(BOOL)deselectOthers
{
  NSMutableIndexSet *newSelectedIndexes = deselectOthers ? [NSMutableIndexSet indexSet] : [_selectedIndexSet mutableCopy];

  NSMutableSet *selectedURLs = [NSMutableSet set];
  [photos enumerateObjectsUsingBlock:^(PhotoAsset *photoAsset, NSUInteger idx, BOOL *stop) {
    [selectedURLs addObject:photoAsset.identifier];
  }];
  [_assets enumerateObjectsUsingBlock:^(PhotoAsset *photoAsset, NSUInteger idx, BOOL *stop) {
    if ([selectedURLs containsObject:photoAsset.identifier]) {
      [newSelectedIndexes addIndex:idx];
    }
  }];

  if (newSelectedIndexes.count > self.maxSelectionCount) {
    return NO;
  }

  if ([_selectedIndexSet count] != [newSelectedIndexes count]) {
    [self willChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
    _selectedIndexSet = newSelectedIndexes;
    [self didChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
  } else {
    _selectedIndexSet = newSelectedIndexes;
  }
  return YES;
}

- (NSUInteger)numberOfSelectedPhotos
{
  return [_selectedIndexSet count];
}

- (NSArray *)selectedPhotos
{
  return [_assets objectsAtIndexes:_selectedIndexSet];
}

- (instancetype)selectedPhotoAssets
{
  if (self.numberOfSelectedPhotos == 0) {
    return nil;
  }

  NSArray *photos = [self selectedPhotos];
  SelectablePhotoAssets *result = [[[self class] alloc] initWithAssets:photos
                                                         assetsLibrary:self.assetsLibrary
                                                           allSelected:YES
                                                     maxSelectionCount:self.maxSelectionCount];
  result.imageCache = _imageCache;
  return result;
}

- (void)removeUnselectedPhotos
{
  if (_selectedIndexSet.count == _assets.count) {
    // All selected, nothing to remove.
    return;
  }

  _assets = [_assets objectsAtIndexes:_selectedIndexSet];
  [_selectedIndexSet removeAllIndexes];
  [_selectedIndexSet addIndexesInRange:NSMakeRange(0, _assets.count)];
}

- (void)_lk_loadAllPhotosWithCompletion:(void (^)(NSArray *assets, NSError *error))completion
{
  NSParameterAssert(completion != nil);

  NSMutableArray *assets = [NSMutableArray array];
  ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
    if (group == nil) {
      completion(assets, nil);
    } else {
      [group setAssetsFilter:[ALAssetsFilter allPhotos]];
      [group enumerateAssetsWithOptions:NSEnumerationReverse
                             usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                               if (result) {
                                 [assets addObject:[[PhotoAsset alloc] initWithALAsset:result]];
                               }
                             }];
    }
  };

  ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    completion(nil, error);
  };

  [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                    usingBlock:listGroupBlock
                                  failureBlock:failureBlock];
}

- (void)_lk_replaceWithAssets:(NSArray *)newAssets
{
  NSMutableSet *selectedAssetsURLs = [NSMutableSet set];
  [_selectedIndexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
    [selectedAssetsURLs addObject:[_assets[idx] identifier]];
  }];

  _assets = [newAssets copy];
  NSMutableIndexSet *newSelectedIndexes = [NSMutableIndexSet indexSet];
  [_assets enumerateObjectsUsingBlock:^(PhotoAsset *photoAsset, NSUInteger idx, BOOL *stop) {
    if ([selectedAssetsURLs containsObject:photoAsset.identifier]) {
      [newSelectedIndexes addIndex:idx];
    }
  }];

  if ([_selectedIndexSet count] != [newSelectedIndexes count]) {
    [self willChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
    _selectedIndexSet = newSelectedIndexes;
    [self didChangeValueForKey:NSStringFromSelector(@selector(numberOfSelectedPhotos))];
  } else {
    _selectedIndexSet = newSelectedIndexes;
  }
}

- (UIImage *)thumbnailImageAtIndex:(NSUInteger)index
{
  return [self _lk_imageAtIndex:index type:kLKCacheKeyThumbnail fromCache:YES];
}

- (UIImage *)aspectRatioThumbnailImageAtIndex:(NSUInteger)index
{
  return [self _lk_imageAtIndex:index type:kLKCacheKeyAspectRatioThumbnail fromCache:YES];
}

- (UIImage *)fullImageAtIndex:(NSUInteger)index
{
  return [self _lk_imageAtIndex:index type:kLKCacheKeyFull fromCache:YES];
}

- (UIImage *)fullImageAtIndexIfCached:(NSUInteger)index
{
  return [self _lk_imageAtIndex:index type:kLKCacheKeyFull fromCache:NO];
}

- (UIImage *)_lk_imageAtIndex:(NSUInteger)index
                          type:(NSString *)type
                     fromCache:(BOOL)fromCache
{
  PhotoAsset *photoAsset = [self.assets objectAtIndex:index];
  NSString *cacheKey = [NSString stringWithFormat:@"%@.%@", type, photoAsset.identifier];
  UIImage *image = [self.imageCache objectForKey:cacheKey];
  if (!image && fromCache) {
    if ([type isEqualToString:kLKCacheKeyFull]) {
      image = photoAsset.image;
    } else if ([type isEqualToString:kLKCacheKeyThumbnail]) {
      image = photoAsset.thumbnail;
    } else if ([type isEqualToString:kLKCacheKeyAspectRatioThumbnail]) {
      image = photoAsset.aspectRatioThumbnail;
    }
    [self.imageCache setObject:image forKey:cacheKey cost:(image.size.width * image.size.height * image.scale)];
  }
  return image;
}

@end
