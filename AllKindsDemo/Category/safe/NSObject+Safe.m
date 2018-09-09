//
//  NSObject+Safe.m
//  MF_sgenglish
//
//  Created by kangjia on 2018/3/1.
//  Copyright © 2018年 mf. All rights reserved.
//

#import "NSObject+Safe.h"

@implementation NSObject (Safe)

@end


#pragma mark - NSMutableArray
@implementation NSMutableArray (NilSafe)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc]  init];
        
        ///动态运行时校验两个方法
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
        [obj swizzleMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safe_setObject:atIndexedSubscript:)];
        [obj swizzleMethod:@selector(removeObject:) withMethod:@selector(safe_removeObject:)];
        [obj swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safe_removeObjectAtIndex:)];
        [obj swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:)];
        
        
        
    });
    
    
    
}
- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    Class class = [self class];
    
    Method   originalMethod = class_getInstanceMethod(class,origSelector);
    Method   swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    /**
     动态运行时给类添加方法
     
     @param class 需要添加方法的类
     @param origSelector 方法名
     @param swizzledMethod IMP 实现这个方法的函数
     @return 表示添加方法成功与否
     */
    BOOL didAddMethod = class_addMethod(class, origSelector,
                                        method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    ////先尝试给源方法添加实现，这里是为了避免源方法没有实现的情况
    if (didAddMethod) {
       // 添加成功：将源方法的实现替换到交换方法的实现
        class_replaceMethod(class, newSelector,
                        method_getImplementation(originalMethod),
                        method_getTypeEncoding(originalMethod));
        
    }else{
       //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
    
    
    
    
    
}
/*
 * remove
 */
-(void)safe_removeObject:(id)anObject{
    
    if (!anObject) {
        NSLog(@"##remove object can not be nil");
    }else{
        [self safe_removeObject:anObject];
    }
    
}
/*
 *removeObject
 */
-(void)safe_removeObjectAtIndex:(NSUInteger)index{
    
    if (index > self.count) {
        NSLog(@"##数组下标越界,%zd",index);
    }else{
        [self safe_removeObjectAtIndex:index];
    }
    
}
/*
 * add
 */
- (void)safe_addObject:(id)value{
    
    if (value) {
        [self safe_addObject:value];
    }else {
        ///这里是设置obj为nil的时候进入
        NSLog(@"##[NSMutableArray addObject:], Object cannot be nil");
    }
    
}
/*
 * objectAtIndex
 */
- (id)safe_objectAtIndex:(NSInteger)index{
    
    if (index < self.count) {
        
        return [self safe_objectAtIndex:index];
        
    }else {
        ///下标越界
        NSLog(@"##数组下标越界");
        return nil;
        
    }
    
}
/*
 * objectAtIndex
 */
-(void)safe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    
    if (!obj || (idx > self.count)) {
        NSLog(@"##数组下标越界,obj为nil,%zd",idx);
    }else{
        [self safe_setObject:obj atIndexedSubscript:idx];
    }
}

-(void)safe_removeObjectsInRange:(NSRange)range{
    
    if (range.location == self.count) {
        NSLog(@"##数组下标越界");
    }else{
        [self safe_removeObjectsInRange:range];
    }
}

-(void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    if (!anObject) {
        NSLog(@"##insertObject object can not be nil,%zd",index);
    }else{
        [self safe_insertObject:anObject atIndex:index];
    }
}

@end

#pragma mark - NSMutableArray
@implementation NSMutableDictionary (NilSafe)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        id obj = [[self alloc] init];
        
        [obj swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
        [obj swizzleMethod:@selector(setValue:forKey:) withMethod:@selector(safe_setValue:forKey:)];
        [obj swizzleMethod:@selector(removeObjectForKey:) withMethod:@selector(safe_removeObjectForKey:)];
        
        
    });
    
    
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    /**
     动态运行时给类添加方法
     
     @param class 需要添加方法的类
     @param origSelector 方法名
     @param swizzledMethod IMP 实现这个方法的函数
     @return 表示添加方法成功与否
     */
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            
                            newSelector,
                            
                            method_getImplementation(originalMethod),
                            
                            method_getTypeEncoding(originalMethod));
        
    } else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
    
}

- (void)safe_setObject:(id)value forKey:(NSString *)key {
    
    if (value) {
        
        [self safe_setObject:value forKey:key];
        
    }else {
        
        NSLog(@"##[NSMutableDictionary setObject: forKey:], Object cannot be nil,%@",key);
        
    }
    
}

-(void)safe_setValue:(id)value forKey:(NSString *)key{
    
    if (value) {
        
        [self safe_setValue:value forKey:key];
        
    }else {
        
        NSLog(@"##[NSMutableDictionary setValue: forKey:], Value cannot be nil,%@",key);
        
    }
}

-(void)safe_removeObjectForKey:(id)aKey{
    
    if (!aKey) {
        NSLog(@"##The Key of removeObjectForKey can not be nil");
    }else{
        [self safe_removeObjectForKey:aKey];
    }
    
}



@end
#pragma mark - NSArray
@implementation NSArray (NilSafe)

+ (void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc] init];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
    });
    
}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector{
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    /**
     动态运行时给类添加方法
     
     @param class 需要添加方法的类
     @param origSelector 方法名
     @param swizzledMethod IMP 实现这个方法的函数
     @return 表示添加方法成功与否
     */
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

- (id)safe_objectAtIndex:(NSInteger)index{
    
    if (index < self.count) {
        
        return [self safe_objectAtIndex:index];
        
    }else {
        ///下标越界
        NSLog(@"##数组下标越界");
        return nil;
        
    }
    
}

@end


