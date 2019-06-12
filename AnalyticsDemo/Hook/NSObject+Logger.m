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

//    NSLog(@"__delegateObject %@", [self class]);

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

+ (void)swizzleDelegate:(id)delegateObject originSelector:(SEL)originSelector swizzleSelector:(SEL)swizzleSelector {
    SEL newSelector = GET_CLASS_CUSTOM_SEL(originSelector, [delegateObject class]);
    Method swizzledMethod = class_getInstanceMethod([delegateObject class], swizzleSelector);
    
    //增加swizzle delegate method
    class_addMethod([delegateObject class],
                    newSelector,
                    method_getImplementation(class_getInstanceMethod([self class], swizzleSelector)),
                    method_getTypeEncoding(swizzledMethod));
    
    Method swizzleDelegateMethod = class_getInstanceMethod([delegateObject class], newSelector);
    Method originDelegateMethod = class_getInstanceMethod([delegateObject class], originSelector);
    
    // 将swizzle delegate method 和 origin delegate method 交换
    method_exchangeImplementations(swizzleDelegateMethod, originDelegateMethod);
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
