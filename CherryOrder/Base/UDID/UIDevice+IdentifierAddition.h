//
// UIDevice(Identifier).h
// UIDeviceAddition
//
// Created by Georg Kitz on 20.08.11.
// Copyright 2011 Aurora Apps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIDevice (IdentifierAddition)

- (NSString *) uniqueMACUDIDIdentifier;
- (NSString *) uniqueOpenUDIDIdentifier;

@end
