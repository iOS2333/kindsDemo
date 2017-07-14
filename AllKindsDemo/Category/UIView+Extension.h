//
//  UIView+Extension.h
//  01 - 表情键盘
//
//  Created by apple on 15-1-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end


typedef NS_ENUM(NSInteger,AnimationDirection) {
    AnimationDirection_top,
    AnimationDirection_bottom,
    AnimationDirection_left,
    AnimationDirection_right,
    AnimationDirection_fade,
    AnimationDirection_custom,
};
typedef void (^completion_block)();



@interface UITableView (tableflip)
/*
 
 AnimationDirection_custom 所需参数
 
 */
@property (nonatomic,assign) CGAffineTransform transform;
@property (nonatomic,assign) UIViewAnimationOptions options;

/*
 
 tableView ani
 
 */
-(void)animateTableView:(AnimationDirection )direction
           withDuration:(NSTimeInterval )duration
         withCompletion:(completion_block )completion;
/*
 
 tableViewCell ani
 
 */
-(void)animateTableViewCell:(AnimationDirection )direction
                 withDuration:(NSTimeInterval )duration
               withCompletion:(completion_block )completion;
@end
