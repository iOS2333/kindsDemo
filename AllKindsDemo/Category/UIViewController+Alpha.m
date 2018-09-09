//
//  UIViewController+Alpha.m
//  AllKindsDemo
//
//  Created by kangjia on 6/6/18.
//  Copyright © 2018年 jim_kj. All rights reserved.
//

#import "UIViewController+Alpha.h"
#import <objc/runtime.h>
#import "UINavigationController+Alpha.h"
@implementation UIViewController (Alpha)
//定义常量 必须是C语言字符串
static char *alphaKey = "alphaKey";
-(void)setNavAlpha:(NSString *)navAlpha{
    /*
     属性类型 基本数据类型用 assign 对象用retain/copy
     OBJC_ASSOCIATION_ASSIGN;
     OBJC_ASSOCIATION_RETAIN;
     OBJC_ASSOCIATION_COPY;   //不写默认atomic
     OBJC_ASSOCIATION_COPY_NONATOMIC;  //nonatomic
     OBJC_ASSOCIATION_RETAIN_NONATOMIC;
     
     */
    /*
     关联对象绑定
     * id object 给哪个对象的属性赋值
     const void *key 属性对应的key
     id value  设置属性值为value
     objc_AssociationPolicy policy  使用的策略，是一个枚举值，和copy，retain，assign是一样的，手机开发一般都选择NONATOMIC
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy);
     */
    
    objc_setAssociatedObject(self, alphaKey, navAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 设置导航栏透明度（利用Category自己添加的方法）
    [self.navigationController setNeedsNavigationBackground:[navAlpha floatValue]];
    
}
-(NSString *)navAlpha{
    return  objc_getAssociatedObject(self, alphaKey)?:@"1.0";
}
@end
