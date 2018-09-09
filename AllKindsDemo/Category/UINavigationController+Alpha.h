//
//  UINavigationController+Alpha.h
//  AllKindsDemo
//
//  Created by kangjia on 6/6/18.
//  Copyright © 2018年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Alpha.h"
@interface UINavigationController (Alpha)<UINavigationBarDelegate, UINavigationControllerDelegate>
@property (copy, nonatomic) NSString *alpha;
- (void)setNeedsNavigationBackground:(CGFloat)alpha;
@end
