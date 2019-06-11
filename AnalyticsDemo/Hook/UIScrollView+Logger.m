//
//  UIScrollView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/31.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIScrollView+Logger.h"
#import "UITableView+Logger.h"

#import "NSObject+Logger.h"
#import <objc/runtime.h>
#import "RuntimeHelper.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UIScrollView (Logger)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleSelectorFromSelector:@selector(setDelegate:) toSelector:@selector(hook_setDelegate:)];
    });
}

- (void)hook_setDelegate:(id<UIScrollViewDelegate>)delegate {
    // 由于setDelegate方法可能被多次调用，所以要判断是否已经swizzling了，防止重复执行。
    if (![[self class] delegate:delegate isContain:@selector(scrollViewWillBeginDragging:)]) {
        [self hook_scrollViewWillBeginDragging:delegate];
    }
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UITableView"]){
        if (![[self class] delegate:delegate isContain:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [(UITableView *)self hook_tableViewDidSelectRowAtIndexPathInClass:delegate];
        }
    }
    [self hook_setDelegate:delegate];
}

#pragma --
#pragma UIScrollViewDelegate
- (void)hook_scrollViewWillBeginDragging:(id<UIScrollViewDelegate>)delegate {
    [[self class] swizzleDelegate:delegate fromSelector:@selector(scrollViewWillBeginDragging:) toSelector:@selector(insertToScrollViewWillBeginDragging:)];
}

- (void)insertToScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        
        NSLog(@"标识：%@_%@_%@", NSStringFromClass([self class]), [RuntimeHelper nameWithClass:self instance:scrollView], NSStringFromSelector(@selector(scrollViewWillBeginDragging:)));
        
        func(self, sel, scrollView);
    }
}

@end
