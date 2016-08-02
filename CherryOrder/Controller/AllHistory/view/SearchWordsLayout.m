//
//  SearchWordsLayout.m
//  lukou
//
//  Created by ZHAOYU on 16/4/12.
//  Copyright © 2016年 lukou. All rights reserved.
//

#import "SearchWordsLayout.h"

@implementation SearchWordsLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attributesForElementsInRect.count];
    
    CGFloat leftMargin = self.sectionInset.left;
    //this loop assumes attributes are in IndexPath order
    for (UICollectionViewLayoutAttributes *attributes in attributesForElementsInRect) {
        if (attributes.frame.origin.x == self.sectionInset.left) {
            leftMargin = self.sectionInset.left;
        } else {
            CGRect newLeftAlignedFrame = attributes.frame;
            newLeftAlignedFrame.origin.x = leftMargin;
            attributes.frame = newLeftAlignedFrame;
        }
        leftMargin += attributes.frame.size.width + ITEM_SPACING;
        [newAttributesForElementsInRect addObject:attributes];
    }
    return newAttributesForElementsInRect;
}

@end
