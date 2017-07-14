//
//  PCCircleView.h
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 手势密码的类型
 */
typedef enum {

    CircleViewTypeSetting = 1,
    CircleViewTypeLogin,
    CircleViewTypeVerify

}CircleViewType;

@class PCCircleView;

@protocol CircleViewDelegate <NSObject>

@optional

#pragma mark - 设置手势密码代理方法
/**
 *  连线个数少于4个时，通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 手势结果
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture;

/**
 *  连线个数多于或等于4个，获取到第一个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第一个次保存的密码
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture;

/**
 *  获取到第二个手势密码时通知代理
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 第二次手势密码
 *  @param equal   第二次和第一次获得的手势密码匹配结果
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal;

#pragma mark - 登录手势密码代理方法
/**
 *  登陆或者验证手势密码输入完成时的代理方法
 *
 *  @param view    circleView
 *  @param type    type
 *  @param gesture 登陆时的手势密码
 */
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal;

@end
@interface PCCircleView : UIView
/**
 *  是否裁剪线条
 */
@property (nonatomic,assign) BOOL clip;
/**
 *  是否有三角形箭头
 */
@property (nonatomic,assign) BOOL arrow;
/**
 *  解锁类型
 */
@property (nonatomic,assign) CircleViewType type;

// 代理
@property (nonatomic, weak) id<CircleViewDelegate> delegate;

-(instancetype)initWithType:(CircleViewType)type
                   withclip:(BOOL)clip
                  witharrow:(BOOL)arrow;
@end
