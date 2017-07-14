//
//  PCCircleView.m
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import "PCCircleView.h"
#import "PCCircle.h"

@interface PCCircleView()

// 选中的圆的集合
@property (nonatomic, strong) NSMutableArray *circleSet;

// 当前点
@property (nonatomic, assign) CGPoint currentPoint;

// 数组清空标志
@property (nonatomic, assign) BOOL hasClean;

@end

@implementation PCCircleView

#pragma mark - 重写arrow的setter
- (void)setArrow:(BOOL)arrow
{
    _arrow = arrow;
    
    // 遍历子控件，改变其是否有箭头
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        [circle setArrow:arrow];
    }];
    
}

- (NSMutableArray *)circleSet
{
    if (_circleSet == nil) {
        _circleSet = [NSMutableArray array];
    }
    return _circleSet;
}

#pragma mark - 初始化

-(instancetype)initWithType:(CircleViewType)type withclip:(BOOL)clip witharrow:(BOOL)arrow{
    
    if (self = [super init]) {
        [self lockViewPrepare];
        self.clip = clip;
        self.arrow = arrow;
        self.type = type;
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}
#pragma mark - 初始化 解锁图形
- (void)lockViewPrepare{
    
    self.frame = CGRectMake(0, 0, screen_wid - CircleViewEdgeMargin*2, screen_wid - CircleViewEdgeMargin *2);
    
    self.center = CGPointMake(screen_wid/2, CircleViewCenterY);
    
    //默认裁剪
    [self setClip:YES];
    //默认有箭头
    [self setArrow:YES];
   
    self.backgroundColor = CircleBackgroundColor;
    
    for (NSInteger i = 0; i<9; i++) {
        PCCircle *circle = [[PCCircle alloc] init];        
        circle.type = CircleTypeGesture;
        circle.arrow = self.arrow;
        [self addSubview:circle];

    }
    
}
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat itemViewWH = CircleRadius * 2;
    CGFloat marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0f;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % 3;
        
        NSUInteger col = idx / 3;
        
        CGFloat x = marginValue * row + row * itemViewWH + marginValue/2;
        
        CGFloat y = marginValue * col + col * itemViewWH + marginValue/2;
        
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        
        // 设置tag -> 密码记录的单元
        subview.tag = idx + 1;
        
        subview.frame = frame;
    }];
}

#pragma mark - 手势操作//通过touchbegan事件来触发drawRect来画线
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self gestureEndResetMembers];//清空手势操作
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];//获取当前点击的点坐标
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof PCCircle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {//遍历所有的圆点,判断是否有点击位置处于圆的位置内有的话加到点击数组,并置点击状态
            [obj setState:CircleStateSelected];
            [self.circleSet addObject:obj];
        }
    }];
    
    /**
     *  处理最后一个点,不出现箭头
     */
    [self circleSetLastObjectWithState:CircleStateLastOneSelected];
    
    [self setNeedsDisplay];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    /**
     *  添加连线过程中的圆点
     */
    [self.subviews enumerateObjectsUsingBlock:^(__kindof PCCircle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (CGRectContainsPoint(obj.frame, point)) {
            
            if ([self.circleSet containsObject:obj]) {
                
            }else{
                [self.circleSet addObject:obj];
                /**
                 *  move 连线
                 */
                if (self.circleSet.count >= 2) {
                    [self calAngleAndconnectTheJumpedCircle]; 
                }
            }
            
           
            
        }else{
            self.currentPoint = point;
        }
        
    }];
    /**
     *  重置保存选中点状态
     */
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setState:CircleStateSelected];
        
        // 如果是登录或者验证原手势密码，就改为对应的状态
        if (self.type != CircleViewTypeSetting) {
            [obj setState:CircleStateLastOneSelected];
        }
        
        
    }];
    /**
     *  处理最后一个点
     */
    [self circleSetLastObjectWithState:CircleStateLastOneSelected];

    [self setNeedsDisplay];
    
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.hasClean = NO;
    
    NSString *gesture = [self getGestureResultFromCircleSet:self.circleSet];
    
    if (gesture.length == 0) {
        return;
    }
    //手势结果处理
    switch (self.type) {
        case CircleViewTypeSetting:
            [self gestureEndByTypeSettingWithGesture:gesture length:gesture.length];
            break;
        case CircleViewTypeLogin:
            [self gestureEndByTypeLoginWithGesture:gesture length:gesture.length];
            break;
        case CircleViewTypeVerify:
            [self gestureEndByTypeVerifyWithGesture:gesture length:gesture.length];
            break;
        default:
            [self gestureEndByTypeSettingWithGesture:gesture length:gesture.length];
            break;

    }
    
    
    // 手势结束后是否错误回显重绘，取决于是否延时清空数组和状态复原
    [self errorToDisPlay];

}
#pragma mark - 是否错误重新绘制
-(void)errorToDisPlay{
    if ([self getCircleState] == CircleStateError || [self getCircleState] == CircleStateLastOneError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kdisplayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self gestureEndResetMembers];
            
        });

    }else{
        [self gestureEndResetMembers];
    }
    
}
#pragma mark - 获取当前选中圆的状态
- (CircleState)getCircleState{
    return [(PCCircle *)[self.circleSet firstObject] state];
}
#pragma mark - 手势结束时的清空操作
/**
 *  手势结束时的清空操作
 */
- (void)gestureEndResetMembers
{
    @synchronized(self) { // 保证线程安全
        if (!self.hasClean) {
            
            // 手势完毕，选中的圆回归普通状态
            [self changeCircleInCircleSetWithState:CircleStateNormal];
            
            // 清空数组
            [self.circleSet removeAllObjects];
            
            // 清空方向
            [self resetAllCirclesDirect];
            
            // 完成之后改变clean的状态
            [self setHasClean:YES];
        }
    }
}
#pragma mark - 改变选中数组CircleSet子控件状态
- (void)changeCircleInCircleSetWithState:(CircleState)state
{
    [self.circleSet enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
        
        [circle setState:state];
        
        // 如果是错误状态，那就将最后一个按钮特殊处理
        if (state == CircleStateError) {
            if (idx == self.circleSet.count - 1) {
                [circle setState:CircleStateLastOneError];
            }
        }
        
    }];
    
    [self setNeedsDisplay];
}

#pragma mark - 清空所有子控件的方向
- (void)resetAllCirclesDirect
{
    [self.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setAngle:0];
    }];
}
#pragma mark - 对数组中最后一个对象的处理
- (void)circleSetLastObjectWithState:(CircleState)state
{
    [[self.circleSet lastObject] setState:state];
}
#pragma mark - 画线
/**
 *  drawRect
 *
 *  @param rect
 */
-(void)drawRect:(CGRect)rect{
    
    if (self.circleSet == nil || self.circleSet.count == 0) {
        return;//如果没有选中的按钮,直接返回
    }
    UIColor *color;
    if ([self getCircleState] == CircleStateError) {
        color = CircleConnectLineErrorColor;
    }else{
        color = CircleConnectLineNormalColor;
    }
    /**
     *  画线
     */
    [self connectCirclesWithRect:rect lineColor:color];
}
/**
*  将选中的圆形以color颜色链接起来
*
*  @param rect  图形上下文
*  @param color 连线颜色
*/
-(void)connectCirclesWithRect:(CGRect )rect
                    lineColor:(UIColor *)color{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加路径
    CGContextAddRect(ctx, rect);
    
    //是否裁剪
    [self clipSubviewsWhenConnectInContext:ctx clip:self.clip];
    
    //裁剪上下文
    CGContextEOClip(ctx);
    //遍历选中状态下的点,来连线
    for (NSInteger i = 0;i < self.circleSet.count ; i++) {
        PCCircle *circle = self.circleSet[i];
        
        if ( i == 0) {
            CGContextMoveToPoint(ctx, circle.center.x, circle.center.y);
        }else{
            CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y);
        }
    }
    //连接最后一个按钮到手指触摸的点
    if (CGPointEqualToPoint(self.currentPoint,CGPointZero) == NO) {
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof PCCircle  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([self getCircleState] == CircleStateError || [self getCircleState] == CircleStateLastOneError) {
                
            }else{
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
            }
        }];
    }
    
    //连线转角方式
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    
    //设置绘图属性,线条宽度
    CGContextSetLineWidth(ctx, CircleConnectLineWidth);
    //线条颜色
    [color set];
    //渲染路径
    CGContextStrokePath(ctx);
    
}
/**
 *  是否剪裁子控件
 *
 *  @param ctx  图形上下文
 *  @param clip 是否剪裁
 */
- (void)clipSubviewsWhenConnectInContext:(CGContextRef)ctx clip:(BOOL)clip
{
    if (clip) {
        
        // 遍历所有子控件
        [self.subviews enumerateObjectsUsingBlock:^(PCCircle *circle, NSUInteger idx, BOOL *stop) {
            
            CGContextAddEllipseInRect(ctx, circle.frame); // 确定"剪裁"的形状
        }];
    }
}
#pragma mark move 处理连线


-(void)calAngleAndconnectTheJumpedCircle{
    
    if (self.circleSet == nil || self.circleSet.count == 0) {
        return;
    }
    
    //取出最后一个
    PCCircle *lastOne = [self.circleSet lastObject];
    //取出倒数第二个
    PCCircle *lastTwo = [self.circleSet objectAtIndex:(self.circleSet.count - 2)];
    
    //获取坐标数值
    CGFloat last_1_x = lastOne.center.x;
    CGFloat last_1_y = lastOne.center.y;
    CGFloat last_2_x = lastTwo.center.x;
    CGFloat last_2_y = lastTwo.center.y;
    
    //1,计算角度,反正切函数
    CGFloat angle = atan2(last_1_y - last_2_y, last_1_x - last_2_x) + M_PI_2;
    
    [lastTwo setAngle:angle];
    
    //2,处理跳跃连线
    
    CGPoint center_point = [self centerPointWithPointOne:lastOne.center pointTwo:lastTwo.center];
    
    PCCircle *center_circle = [self enumCircleSetToFindWhichSubviewContainTheCenterPoint:center_point];
    
    if (center_circle != nil) {
        //把中间跳过的圆加到选中圆的数组中,倒数第二个
        if (![self.circleSet containsObject:center_circle]) {
            [self.circleSet insertObject:center_circle atIndex:self.circleSet.count - 1];
        }
        
    }
    
    
}
/**
 *  处理两个点返回中间一个点
 *
 *  @param pointOne 第一个
 *  @param pointTwo 第二个
 *
 *  @return 中间那个点
 */
- (CGPoint)centerPointWithPointOne:(CGPoint)pointOne pointTwo:(CGPoint)pointTwo
{
    CGFloat x1 = pointOne.x > pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat x2 = pointOne.x < pointTwo.x ? pointOne.x : pointTwo.x;
    CGFloat y1 = pointOne.y > pointTwo.y ? pointOne.y : pointTwo.y;
    CGFloat y2 = pointOne.y < pointTwo.y ? pointOne.y : pointTwo.y;
    
    return CGPointMake((x1+x2)/2, (y1 + y2)/2);
}/**
 *  给一个点,判断是否被圆包含,如果是,返回这个圆,不是的话返回nil
 *
 *  @param point 给定的点
 *
 *  @return 返回包含点的圆
 */
- (PCCircle *)enumCircleSetToFindWhichSubviewContainTheCenterPoint:(CGPoint)point
{
    PCCircle *circle;
    
    for (PCCircle *tmpCircle in self.subviews) {
        if (CGRectContainsPoint(tmpCircle.frame, point)) {//遍历所有的点,寻找包含点的圆
            circle = tmpCircle;
            break;
        }
    }
    
    if (![self.circleSet containsObject:circle]) {//如果选中的点中不包含该圆,则设置该圆的角度
        circle.angle = [(PCCircle *)[self.circleSet objectAtIndex:self.circleSet.count - 2] angle];
    }
    
    
    
    return circle;//k可能为空,当前点不在任何圆内
}
#pragma mark - 手势操作结果处理
/**
 *  将手势结果取出拼字符串保存,或者验证处理
 *
 *  @param circleSet 手势结果数组
 *
 *  @return 拼接结果
 */

- (NSString *)getGestureResultFromCircleSet:(NSMutableArray *)circleSet
{
    NSMutableString *m_str = [NSMutableString string];
    
    for (PCCircle *circle in circleSet) {
        [m_str appendFormat:@"%@",@(circle.tag)];//拼接圆的tag值
    }
    
    return m_str;
}

#pragma mark  解锁类型：验证 手势路径的处理
/**
 *  解锁类型：验证 手势路径的处理
 */
- (void)gestureEndByTypeVerifyWithGesture:(NSString *)gesture length:(CGFloat)length
{
    [self gestureEndByTypeLoginWithGesture:gesture length:length];
}

#pragma mark 解锁类型：登陆 手势路径的处理
/**
 *  解锁类型：登陆 手势路径的处理
 */
- (void)gestureEndByTypeLoginWithGesture:(NSString *)gesture length:(CGFloat)length{
    
    NSString *password = [PCCircleViewConst getGestureWithKey:gestureFinalSaveKey];
    
    BOOL equal = [password isEqualToString:gesture];
    
    
    if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteLoginGesture:result:)]) {
        [self.delegate circleView:self type:self.type didCompleteLoginGesture:gesture result:equal];
    }
    
    if (!equal) {
        [self changeCircleInCircleSetWithState:CircleStateError];
    }

}
#pragma mark  解锁类型：设置 手势路径的处理
/**
 *  解锁类型：设置 手势路径的处理
 */
- (void)gestureEndByTypeSettingWithGesture:(NSString *)gesture length:(CGFloat)length
{
    if (length <CircleSetCountLeast) {//少于最少连线的点
        
        // 1.通知代理
        if ([self.delegate respondsToSelector:@selector(circleView:type:connectCirclesLessThanNeedWithGesture:)]) {
            [self.delegate circleView:self type:self.type connectCirclesLessThanNeedWithGesture:gesture];
        }
 
        //2.重置状态
        [self changeCircleInCircleSetWithState:CircleStateError];
        
    }
    else{//多余最少连线的点
        NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
        
        if (gestureOne.length < CircleSetCountLeast) {//保存第一个密码
            
            [PCCircleViewConst saveGesture:gesture Key:gestureOneSaveKey];
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteSetFirstGesture:)]) {
                [self.delegate circleView:self type:self.type didCompleteSetFirstGesture:gesture];
            }

            
        }
        else{
            
            BOOL equal = [gesture isEqualToString:[PCCircleViewConst getGestureWithKey:gestureOneSaveKey]];//判断两次密码一致不
            
            // 通知代理
            if ([self.delegate respondsToSelector:@selector(circleView:type:didCompleteSetSecondGesture:result:)]) {
                
                [self.delegate circleView:self type:self.type didCompleteSetSecondGesture:gesture result:equal];
                
            }

            
            if (equal) { // 两次密码一致,保存最终的密码
                [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
            }else{ //重新绘制显示
                [self changeCircleInCircleSetWithState:CircleStateError];
            }
            
            
        }
        
        
    }
}
@end
