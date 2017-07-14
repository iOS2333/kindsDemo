//
//  UIView+Boom.h
//  粒子效果demo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 雷晏. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CALayer (Anim)

/*
 *  摇动
 */
-(void)shake;
/*
 *  缩放
 */
-(void)scale;


@end

@interface UIView (Boom)

-(void)boom;
@end
