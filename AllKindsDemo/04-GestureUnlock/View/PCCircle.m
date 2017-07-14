//
//  PCCircle.m
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import "PCCircle.h"

@interface PCCircle()

/**
 *  外环颜色
 */
@property (nonatomic, strong) UIColor *outCircleColor;

/**
 *  实心圆颜色
 */
@property (nonatomic, strong) UIColor *inCircleColor;

/**
 *  三角形颜色
 */
@property (nonatomic, strong) UIColor *trangleColor;

@end

@implementation PCCircle
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = CircleBackgroundColor;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = CircleBackgroundColor;
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat radio;
    CGRect circleRect = CGRectMake(CircleEdgeWidth, CircleEdgeWidth, rect.size.width - 2 * CircleEdgeWidth, rect.size.height - 2 * CircleEdgeWidth);
    
    if (self.type == CircleTypeGesture) {
        radio = CircleRadio;
    } else if (self.type == CircleTypeInfo) {
        radio = 1;
    }
    
    // 上下文旋转
    [self transFormCtx:ctx rect:rect];
    
    // 画圆环
  
    [self drawEmptyCricleWithContext:ctx rect:circleRect color:self.outCircleColor];
    // 画实心圆
    [self drawSolidCircleWithContext:ctx rect:rect radio:radio color:self.inCircleColor];
    
    if (self.arrow) {
        
        // 画三角形箭头
        [self drawTrangleWithContext:ctx topPoint:CGPointMake(rect.size.width/2, 10) length:kTrangleLength color:self.trangleColor];
    }
}

#pragma mark - 画圆
/**
 *  画外圆环
 *
 *  @param ctx   图形上下文
 *  @param rect  绘画范围
 *  @param color 绘制颜色
 */
-(void)drawEmptyCricleWithContext:(CGContextRef )ctx
                             rect:(CGRect) rect
                            color:(UIColor *)color
{
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, rect);
    CGContextAddPath(ctx, circlePath);
    [color set];
    CGContextSetLineWidth(ctx, CircleEdgeWidth);
    CGContextStrokePath(ctx);
    CGPathRelease(circlePath);
    
}
/**
 *  画实心圆
 *
 *  @param ctx   图形上下文
 *  @param rect  绘制范围
 *  @param radio 占大圆比例
 *  @param color 绘制颜色
 */
- (void)drawSolidCircleWithContext:(CGContextRef)ctx
                              rect:(CGRect)rect
                             radio:(CGFloat)radio
                             color:(UIColor *)color
{
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(rect.size.width/2 * (1 - radio) + CircleEdgeWidth, rect.size.height/2 * (1 - radio) + CircleEdgeWidth, rect.size.width * radio - CircleEdgeWidth * 2, rect.size.height * radio - CircleEdgeWidth * 2));
    [color set];
    CGContextAddPath(ctx, circlePath);
    CGContextFillPath(ctx);
    CGPathRelease(circlePath);
}
/**
 *  画三角形
 *
 *  @param ctx    图形上下文
 *  @param point  顶点
 *  @param length 边长
 *  @param color  绘制颜色
 */
- (void)drawTrangleWithContext:(CGContextRef)ctx
                      topPoint:(CGPoint)point
                        length:(CGFloat)length
                         color:(UIColor *)color
{
    CGMutablePathRef trianglePathM = CGPathCreateMutable();
    CGPathMoveToPoint(trianglePathM, NULL, point.x, point.y);
    CGPathAddLineToPoint(trianglePathM, NULL, point.x - length/2, point.y + length/2);
    CGPathAddLineToPoint(trianglePathM, NULL, point.x + length/2, point.y + length/2);
    CGContextAddPath(ctx, trianglePathM);
    [color set];
    CGContextFillPath(ctx);
    CGPathRelease(trianglePathM);
}
/*
 *  上下文旋转
 */
-(void)transFormCtx:(CGContextRef)ctx rect:(CGRect)rect{
    //    if(self.angle == 0) return;
    CGFloat translateXY = rect.size.width * .5f;
    //平移
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    CGContextRotateCTM(ctx, self.angle);
    //再平移回来
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}
#pragma mark - color getter
/**
 *  圆环绘制颜色的getter
 */

-(UIColor *)outCircleColor{
    UIColor *color;
    
    switch (self.state) {
        case CircleStateNormal:
        {
            color = CircleStateNormalOutsideColor;
        }
            break;
        case CircleStateSelected:
        {
            color = CircleStateSelectedOutsideColor;
        }
            break;
        case CircleStateError:
        {
            color = CircleStateErrorOutsideColor;
        }
            break;
        case CircleStateLastOneSelected:
        {
            color = CircleStateSelectedOutsideColor;
        }
            break;
        case CircleStateLastOneError:
        {
            color = CircleStateErrorOutsideColor;
        }
            break;
            
        default:
        {
            color = CircleStateNormalOutsideColor;
        }
            break;
    }
    
    
    return color;
}
/**
 *  实心圆绘制颜色的getter
 */
- (UIColor *)inCircleColor{
    UIColor *color;
    switch (self.state) {
        case CircleStateNormal:
        {
            color = CircleStateNormalInsideColor;
        }
            break;
        case CircleStateSelected:
        {
            color = CircleStateSelectedInsideColor;
        }
            break;
        case CircleStateError:
        {
            color = CircleStateErrorInsideColor;
        }
            break;
        case CircleStateLastOneSelected:
        {
            color = CircleStateSelectedInsideColor;
        }
            break;
        case CircleStateLastOneError:
        {
            CircleStateErrorInsideColor;
        }
            break;
            
        default:
        {
            color = CircleStateNormalInsideColor;
        }
            break;
    }
    
    return color;
    
}
/**
 *  三角形颜色的getter
 */

- (UIColor *)trangleColor{
    UIColor *color;
    switch (self.state) {
        case CircleStateNormal:
        {
            color = CircleStateNormalTrangleColor;
        }
            break;
        case CircleStateSelected:
        {
            color = CircleStateSelectedTrangleColor;
        }
            break;
        case CircleStateError:
        {
            color = CircleStateErrorTrangleColor;
        }
            break;
        case CircleStateLastOneSelected:
        {
            color = CircleStateNormalTrangleColor;
        }
            break;
        case CircleStateLastOneError:
        {
            color = CircleStateNormalTrangleColor;
        }
            break;
            
        default:{
            color = CircleStateNormalTrangleColor;
        }
            break;
    }
    
    return color;
    
}
#pragma mark - 重写
//重写angle的setter
- (void)setAngle:(CGFloat)angle{
    _angle = angle;
    
    [self setNeedsDisplay];
    
}
//重写state的setter
-(void)setState:(CircleState)state{
    _state = state;
    
    [self setNeedsDisplay];
}

@end
