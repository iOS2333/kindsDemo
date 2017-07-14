//
//  UIView+Extension.m
//  01 - 表情键盘
//
//  Created by apple on 15-1-30.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

@end


@implementation UITableView (tableflip)
@dynamic options;
-(UIViewAnimationOptions )options{
    return UIViewAnimationOptionCurveEaseInOut;
}
#pragma mark - Translation
-(CGFloat )yPositionwith:(AnimationDirection )direction
                    with:(UITableView *)tableview{
    if (direction == AnimationDirection_top) {
        return -tableview.frame.size.height;
    }else if(direction == AnimationDirection_bottom){
        return tableview.frame.size.height;
    }else
        return 0;
}
-(CGFloat )xPositionwith:(AnimationDirection )direction
                    with:(UITableViewCell *)cell{
    if (direction == AnimationDirection_left) {
        return -cell.frame.size.width;
    }else if(direction == AnimationDirection_right){
        return cell.frame.size.width;
    }else
        return 0;
}

#pragma mark - tableview
-(void)animateTableView:(AnimationDirection )direction
           withDuration:(NSTimeInterval )duration
         withCompletion:(completion_block )completion{
    switch (direction) {
        case AnimationDirection_top:
        {  [self animationTableViewWithDirection:direction withDuration:duration withCompletion:^{
            completion();
        }];
        }
            break;
        case AnimationDirection_bottom:
        {  [self animationTableViewWithDirection:direction withDuration:duration withCompletion:^{
            completion();
        }];
        }
            break;
        case AnimationDirection_fade:
        {   [self animateWithFadeWithDuration:duration with:NO with:^{
            completion();
        }];
        }
            break;
        case AnimationDirection_custom:
        {  [self animateTableViewWithTransformWithDuration:duration withTransform:self.transform withOptions:self.options with:^{
            completion();
        }];
        }
            break;
        default:
            break;
    }
}


-(void)animationTableViewWithDirection:(AnimationDirection )direction
                          withDuration:(NSTimeInterval )duration
                        withCompletion:(completion_block )completion{
    
    
    CGFloat damping = 0.75;
    
    CGAffineTransform tableTransform = CGAffineTransformMakeTranslation(0.0, [self yPositionwith:direction with:self]);
    [self.layer setAffineTransform:tableTransform];
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.layer setAffineTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        completion();
    }];

}
-(void)animateTableViewWithTransformWithDuration:(NSTimeInterval )duration
                                   withTransform:(CGAffineTransform )transform
                                     withOptions:(UIViewAnimationOptions)options
                                            with:(completion_block )completion{
    
    [self.layer setAffineTransform:transform];
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.0 initialSpringVelocity:0.0 options:options animations:^{
        [self.layer setAffineTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
        completion();
    }];
    
}




#pragma mark - cell
-(void)animateTableViewCell:(AnimationDirection )direction
                 withDuration:(NSTimeInterval )duration
               withCompletion:(completion_block )completion{
    switch (direction) {
        case AnimationDirection_left:
        {  [self animationTableViewCellWithDirection:direction withDuration:duration withCompletion:^{
            completion();
        }];
        }
            break;
        case AnimationDirection_right:
        {  [self animationTableViewCellWithDirection:direction withDuration:duration withCompletion:^{
            completion();
        }];
        }
            break;
        case AnimationDirection_fade:
        {
            [self animateWithFadeWithDuration:duration with:YES with:^{
                completion();
            }];
        }
            break;
        case AnimationDirection_custom:
        {  [self animateTableViewCellWithTransformWithDuration:duration withTransform:self.transform withOptions:self.options with:^{
              completion();
            }];
        }
            break;
        default:
            break;
    }
}

-(void)animationTableViewCellWithDirection:(AnimationDirection )direction
                              withDuration:(NSTimeInterval )duration
                            withCompletion:(completion_block )completion{
   
    CGFloat i = 0;
    for (UITableViewCell* cell in self.visibleCells) {
        
        NSTimeInterval delay = duration/[[NSNumber numberWithInteger:self.visibleCells.count] doubleValue]*[[NSNumber numberWithInteger:i] doubleValue];
        CGFloat damping = 0.55;
        
        CGAffineTransform cellTransform = CGAffineTransformMakeTranslation([self xPositionwith:direction with:cell], 0.0);
        [cell.layer setAffineTransform:cellTransform];
        NSLog(@"text:%@,delay:%f,index:%f",cell.textLabel.text,delay,i);
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:damping initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [cell.layer setAffineTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            completion();
        }];
        i++;
    }
    
}
-(void)animateTableViewCellWithTransformWithDuration:(NSTimeInterval )duration
                                       withTransform:(CGAffineTransform )transform
                                         withOptions:(UIViewAnimationOptions)options
                                                with:(completion_block )completion{
    CGFloat i = 0;
    for (UITableViewCell* cell in self.visibleCells) {
        
        NSTimeInterval delay = duration/[[NSNumber numberWithInteger:self.visibleCells.count] doubleValue]*[[NSNumber numberWithInteger:i] doubleValue];
        
        [cell.layer setAffineTransform:transform];
        
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:0.55 initialSpringVelocity:0.0 options:options animations:^{
            [cell.layer setAffineTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            completion();
        }];
        i++;
    
    }
    
    
}

#pragma mark - fade
-(void)animateWithFadeWithDuration:(NSTimeInterval )duration
                              with:(BOOL)consecutively
                              with:(completion_block )completion
{
    if (consecutively) {
        
        CGFloat i = 0;
        for (UITableViewCell* cell in self.visibleCells) {
            
            NSTimeInterval delay = duration/[[NSNumber numberWithInteger:self.visibleCells.count] doubleValue]*[[NSNumber numberWithInteger:i] doubleValue];
            
            
            
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                completion();
            }];
            i++;
        }

        
    }else{
        CATransition *fade = [self fadeTransition];
        fade.duration = duration;
        [self.layer addAnimation:fade forKey:@"UITableViewReloadDataAnimationKey"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
            completion();
            });
           
        });
    }
}
-(CATransition *)fadeTransition{
    CATransition *fade = [[CATransition alloc] init];
    fade.type = kCATransitionFade;
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    fade.fillMode = kCAFillModeBoth;
    return fade;
}







@end




