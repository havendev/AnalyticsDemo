//
//  UIScrollView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/31.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIScrollView+Logger.h"
#import "HHook.h"

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
    
}
@end
