//
//  CyclicCardView.h
//  AllKindsDemo
//
//  Created by kangjia on 2018/3/29.
//  Copyright © 2018年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CyclicCardView : UIView
@property(nonatomic,assign) BOOL  Autoscrol;//默认ture
@property(nonatomic,assign) NSTimeInterval animationDuration;//默认时间5秒
@property(nonatomic,copy) void (^TapActionBlock)(NSInteger pageIndex);//点击回调

//初始化
- (instancetype)initWithFrame:(CGRect)frame
                   withImages:(NSArray *)imagearr
                    withSacle:(NSDictionary *)scale;
@end
