//
//  SphereTagView.h
//  AllKindsDemo
//
//  Created by kangjia on 2017/3/1.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SphereTagView : UIView
/**
 *  Sets the cloud's tag views.
 *
 *	@remarks Any @c UIView subview can be passed in the array.
 *
 *  @param array The array of tag views.
 */
- (void)setCloudTags:(NSArray *)array;

/**
 *  Starts the cloud autorotation animation.
 */
- (void)timerStart;

/**
 *  Stops the cloud autorotation animation.
 */
- (void)timerStop;
@end
