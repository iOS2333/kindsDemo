//
//  UINavigationController+Alpha.m
//  AllKindsDemo
//
//  Created by kangjia on 6/6/18.
//  Copyright © 2018年 jim_kj. All rights reserved.
//

#import "UINavigationController+Alpha.h"
#import <objc/runtime.h>
@implementation UINavigationController (Alpha)
#pragma mark - 设置渐变
// 设置导航栏背景透明度
- (void)setNeedsNavigationBackground:(CGFloat)alpha {
    
    // 导航栏背景透明度设置
    UIView *barBackgroundView = [[self.navigationBar subviews] objectAtIndex:0];// _UIBarBackground
    UIImageView *backgroundImageView = [[barBackgroundView subviews] objectAtIndex:0];// UIImageView
    if (self.navigationBar.isTranslucent) {
        if (backgroundImageView != nil && backgroundImageView.image != nil) {
            barBackgroundView.alpha = alpha;
        } else {
            UIView *backgroundEffectView = [[barBackgroundView subviews] objectAtIndex:1];// UIVisualEffectView
            if (backgroundEffectView != nil) {
                backgroundEffectView.alpha = alpha;
            }
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    // 对导航栏下面那条线做处理
    self.navigationBar.clipsToBounds = alpha ==0.0;
    self.navigationBar.hidden = alpha == 0.0;
}

#pragma mark - 初始化方式
//这个方法是懒加载，没有用到这个类就不会调用，可以节省系统资源,load方法是一定会在runtime中被调用的，只要类被添加到runtime中了，就会调用load方法
//类 -> 子类 ->分类 (load不会覆盖)   分类 -> 子类 ->类 (initialize会覆盖)
+ (void)initialize {
    if (self == [UINavigationController self]) {

        // 交换方法,利用runtime的swizz方法,updateInteractiveTransition是过渡动画的方法
        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
        SEL swizzledSelector = NSSelectorFromString(@"ex__updateInteractiveTransition:");
        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
// 交换的方法，监控滑动手势
- (void)ex__updateInteractiveTransition:(CGFloat)percentComplete {

    UIViewController *topVC = self.topViewController;//最顶上的view
    if (topVC != nil) {
        //交互式动画
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            // 随着滑动的过程设置导航栏透明度渐变
            CGFloat fromAlpha = [[coor viewControllerForKey:UITransitionContextFromViewControllerKey].navAlpha floatValue];
            CGFloat toAlpha = [[coor viewControllerForKey:UITransitionContextToViewControllerKey].navAlpha floatValue];
            CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete;
            NSLog(@"from:%f, to:%f, now:%f",fromAlpha, toAlpha, nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
        }
    }
        [self ex__updateInteractiveTransition:(percentComplete)];
}
#pragma mark - UINavigationController Delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *topVC = self.topViewController;
    if (topVC != nil) {
        id<UIViewControllerTransitionCoordinator> coor = topVC.transitionCoordinator;
        if (coor != nil) {
            //            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
            //                [self dealInteractionChanges:context];
            //            }];
            
            // notifyWhenInteractionChangesUsingBlock是10.0以后的api，换成notifyWhenInteractionEndsUsingBlock
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                [self dealInteractionChanges:context];
#pragma clang diagnostic pop
            }];
        }
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey].navAlpha floatValue];
            NSLog(@"自动取消返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navAlpha floatValue];
            NSLog(@"自动完成返回到alpha：%f", nowAlpha);
            [self setNeedsNavigationBackground:nowAlpha];
        }];
    }
}


#pragma mark - UINavigationBar Delegate
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item {
    if (self.viewControllers.count >= navigationBar.items.count) {// 点击返回按钮
        UIViewController *popToVC = self.viewControllers[self.viewControllers.count - 1];
        [self setNeedsNavigationBackground:[popToVC.navAlpha floatValue]];
        //        [self popViewControllerAnimated:YES];
    }
}

- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item {
    // push到一个新界面
    [self setNeedsNavigationBackground:[self.topViewController.navAlpha floatValue]];
}



#pragma mark - 设置自身属性值
static char *navalphaKey = "navalphaKey";

-(void)setAlpha:(NSString *)alpha{
    
    objc_setAssociatedObject(self, navalphaKey, alpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
-(NSString *)alpha{
    return objc_getAssociatedObject(self, navalphaKey)?:@"1.0";
}
@end
