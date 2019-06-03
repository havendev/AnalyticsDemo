//
//  UIScrollView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/31.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIScrollView+Logger.h"
#import "HHook.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UIScrollView (Logger)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL fromSelector = @selector(setDelegate:);
        SEL toSelector = @selector(hook_setDelegate:);
        [HHook hookClass:self FromSelector:fromSelector ToSelector:toSelector];
    });
}

- (void)hook_setDelegate:(id<UIScrollViewDelegate>)delegate {
    NSLog(@"__1 %@", [NSString stringWithFormat:@"%@_%@",NSStringFromClass([delegate class]),NSStringFromSelector(@selector(scrollViewWillBeginDragging:))]);
    // 由于setDelegate方法可能被多次调用，所以要判断是否已经swizzling了，防止重复执行。
    if (![HHook delegate:delegate IsContain:@selector(scrollViewWillBeginDragging:)]) {
        [self swizzling_scrollViewWillBeginDragging:delegate];
    }
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UITableView"]){
        if (![HHook delegate:delegate IsContain:@selector(tableView:didSelectRowAtIndexPath:)]) {
            [self swizzling_scrollViewWillBeginDragging:delegate];
        }
//        if (![self isContainSel:GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[delegate class]) inClass:[delegate class]]) {
////            [(UITableView *)self swizzling_tableViewDidSelectRowAtIndexPathInClass:delegate];
//        }
    }
    
    [self hook_setDelegate:delegate];
}

- (void)swizzling_scrollViewWillBeginDragging:(id<UIScrollViewDelegate>)delegate {
    SEL fromSelector = @selector(scrollViewWillBeginDragging:);
    SEL toSelector = @selector(hook_scrollViewWillBeginDragging:);

    [HHook hookDelegate:delegate FromSelector:fromSelector ToSelector:toSelector Object:self];
}

- (void)hook_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"__2221 %@-%@", NSStringFromClass([self class]), NSStringFromSelector(@selector(scrollViewWillBeginDragging:)));
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(scrollViewWillBeginDragging:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel, scrollView);
    }
}

@end
