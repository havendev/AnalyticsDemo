//
//  HHook.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "HHook.h"
#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation HHook
+ (void)hookClass:(Class)classObject FromSelector:(SEL)fromSelector ToSelector:(SEL)toSelector {
    Class class = classObject;
    
    //得到被替换类的实例方法
    Method fromMethod = class_getInstanceMethod(class, fromSelector);
    
    //得到替换类的实例方法
    Method toMethod = class_getInstanceMethod(class, toSelector);
    
    //class_addMethod 返回成功即表示被替换的方法没实现，然后通过 class_replaceMethod 方法先实现；返回失败则表示被替换方法已经存在，可以直接进行 IMP 指针交换
    if (class_addMethod(class, fromSelector, method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        //进行方法替换
        class_replaceMethod(class, toSelector, method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
    } else {
        //交换IMP指针
        method_exchangeImplementations(fromMethod, toMethod);
    }
}

+ (BOOL)delegate:(id)delegateObject IsContain:(SEL)selector {
    return [self isContainSel:GET_CLASS_CUSTOM_SEL(selector, [delegateObject class]) inClass:[delegateObject class]];
}

+ (void)hookDelegate:(id)delegateObject FromSelector:(SEL)fromSelector ToSelector:(SEL)toSelector Object:(id)object { 
    //增加swizzle delegate method
    SEL newFromSelector = GET_CLASS_CUSTOM_SEL(fromSelector, [delegateObject class]);
    IMP toIMP = method_getImplementation(class_getInstanceMethod([object class], toSelector));
    
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
