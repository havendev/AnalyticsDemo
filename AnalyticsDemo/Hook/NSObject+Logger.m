//
//  NSObject+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/10.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "NSObject+Logger.h"
#import <objc/runtime.h>
#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation NSObject (Logger)
+ (void)swizzleSelectorFromSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(self,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(self,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (BOOL)delegate:(id)delegateObject isContain:(SEL)selector {
    return [self isContainSel:GET_CLASS_CUSTOM_SEL(selector, [delegateObject class]) inClass:[delegateObject class]];
}

+ (void)swizzleDelegate:(id)delegateObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector {
    //增加swizzle delegate method
    SEL newFromSelector = GET_CLASS_CUSTOM_SEL(fromSelector, [delegateObject class]);
    IMP toIMP = method_getImplementation(class_getInstanceMethod([self class], toSelector));
    class_addMethod([delegateObject class], newFromSelector, toIMP, "v@:@");
    
    // 检查页面是否已经实现了origin delegate method  如果没有手动加一个
    if (![self isContainSel:fromSelector inClass:[delegateObject class] ]) {
        IMP imp = nil;
        class_addMethod([delegateObject class], fromSelector, imp, "v@");
    }
    
    Method firstMethod = class_getInstanceMethod([delegateObject class], fromSelector);
    Method secondMethod = class_getInstanceMethod([delegateObject class], newFromSelector);
    // 将swizzle delegate method 和 origin delegate method 交换
    method_exchangeImplementations(firstMethod, secondMethod);
    
}

+ (BOOL)isContainSel:(SEL)sel inClass:(Class)class {
    unsigned int count;
    
    Method *methodList = class_copyMethodList(class,&count);
    for (int i = 0; i < count; i++) {
        Method method = methodList[i];
        NSString *tempMethodString = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([tempMethodString isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}
@end
