//
//  PhotoAsset.h
//  Lukou
//
//  Created by XueMing on 3/20/15.
//  Copyright (c) 2015 Lukou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAsset;
@interface PhotoAsset : NSObject

@property (nonatomic, readonly) ALAsset *asset;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *aspectRatioThumbnail;

- (instancetype)initWithALAsset:(ALAsset *)asset;
- (instancetype)initWithIdentifier:(NSString *)identifier
                             image:(UIImage *)image
                         thumbnail:(UIImage *)thumbnail
              aspectRatioThumbnail:(UIImage *)aspectRatioThumbnail;

+ (NSString *)photoIdentifier:(ALAsset *)asset;

@end
