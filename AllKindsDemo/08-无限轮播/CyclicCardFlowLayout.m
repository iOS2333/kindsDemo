//
//  CyclicCardFlowLayout.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/6/30.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "CyclicCardFlowLayout.h"

@interface CyclicCardFlowLayout ()
{
    CGFloat ActiveDistance;
    CGFloat ScaleFactor;
}
@end


@implementation CyclicCardFlowLayout

-(CGPoint )targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0,self.collectionView.bounds.size.width , self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    CGFloat horizontalCenterX = proposedContentOffset.x + (self.collectionView.bounds.size.width/2);
    CGFloat offsetAdjustment = CGFLOAT_MAX;
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        CGFloat itemHorizontalCenterX = layoutAttributes.center.x;
        if(fabs(itemHorizontalCenterX-horizontalCenterX) < fabs(offsetAdjustment)){
            offsetAdjustment = itemHorizontalCenterX-horizontalCenterX;
        }
    }
    
    
    return CGPointMake(proposedContentOffset.x+offsetAdjustment, proposedContentOffset.y);
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    ActiveDistance = screen_height*(410.00/667.00);
    ScaleFactor = 0.21;
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
        CGFloat  normalizedDistance = fabs(distance/ActiveDistance);
        CGFloat zoom = 1 - ScaleFactor *normalizedDistance;
        attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0);
        attributes.zIndex = 1;
        
    }
    
    return array;
}
-(BOOL )shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return true;
}
@end
