//
//  HHook.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "HHook.h"

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
@end
