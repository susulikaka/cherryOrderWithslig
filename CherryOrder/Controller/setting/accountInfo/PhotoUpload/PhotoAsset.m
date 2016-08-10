//
//  PhotoAsset.m
//  Lukou
//
//  Created by XueMing on 3/20/15.
//  Copyright (c) 2015 Lukou. All rights reserved.
//

#import "PhotoAsset.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoAsset

- (instancetype)initWithALAsset:(ALAsset *)asset
{
  self = [super init];
  if (self) {
    _asset = asset;
    _identifier = [[self class] photoIdentifier:asset];
  }
  return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                             image:(UIImage *)image
                         thumbnail:(UIImage *)thumbnail
              aspectRatioThumbnail:(UIImage *)aspectRatioThumbnail
{
  self = [super init];
  if (self) {
    _identifier = identifier;
    _image = image;
    _thumbnail = thumbnail;
    _aspectRatioThumbnail = aspectRatioThumbnail;
  }
  return self;
}

+ (NSString *)photoIdentifier:(ALAsset *)asset
{
  return [[asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
}

#pragma mark - Property

- (UIImage *)image
{
  if (!_image && self.asset) {
    _image = [UIImage imageWithCGImage:[[self.asset defaultRepresentation] fullScreenImage]];
  }
  return _image;
}

- (UIImage *)thumbnail
{
  if (!_thumbnail && self.asset) {
    _thumbnail = [UIImage imageWithCGImage:[self.asset thumbnail]];
  }
  return _thumbnail;
}

- (UIImage *)aspectRatioThumbnail
{
  if (!_aspectRatioThumbnail && self.asset) {
    _aspectRatioThumbnail = [UIImage imageWithCGImage:[self.asset aspectRatioThumbnail]];
  }
  return _aspectRatioThumbnail;
}

@end
