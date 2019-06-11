//
//  UIViewController+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIViewController+Logger.h"
#import "NSObject+Logger.h"
#import <objc/runtime.h>
//#import <UMAnalytics/MobClick.h>

@implementation UIViewController (Logger)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"UIViewController");
        [class swizzleSelectorFromSelector:@selector(viewWillAppear:) toSelector:@selector(hook_viewWillAppear:)];
        [class swizzleSelectorFromSelector:@selector(viewWillDisappear:) toSelector:@selector(hook_viewWillDisappear:)];
        
        //TODO:可补充其他生命周期事件
    });
}

#pragma mark--
#pragma 页面显示、消失
- (void)hook_viewWillAppear:(BOOL)animated {
    //先执行插入代码，再执行原 viewWillAppear 方法
    [self insertToViewWillAppear];
    
    [self hook_viewWillAppear:animated];
}

- (void)hook_viewWillDisappear:(BOOL)animated {
    //先执行插入代码，再执行原 viewWillDisappear 方法
    [self insertToViewWillDisappear];
    
    [self hook_viewWillDisappear:animated];
}

- (void)insertToViewWillAppear {
    //在 ViewWillAppear 时进行日志埋点
    NSLog(@"页面显示：%@", NSStringFromClass([self class]));
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)insertToViewWillDisappear {
    //在 ViewWillDisappear 时进行日志埋点
    NSLog(@"页面消失：%@", NSStringFromClass([self class]));
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
