//
//  UIControl+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/30.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIControl+Logger.h"
#import "NSObject+Logger.h"
#import <objc/runtime.h>

@implementation UIControl (Logger)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //可监听到UIButton、UITextField、UISwitch、UISegmentedControl、UISlider 、UIStepper等控件的Action事件
        [self swizzleSelectorFromSelector:@selector(sendAction:to:forEvent:) toSelector:@selector(hook_sendAction:to:forEvent:)];
    });
}

#pragma mark --
#pragma 按钮点击
- (void)hook_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self insertToSendAction:action to:target forEvent:event];
    
    [self hook_sendAction:action to:target forEvent:event];
}

- (void)insertToSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    //日志记录
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded) {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetString = NSStringFromClass([target class]);
        
        NSLog(@"唯一标识：%@_%@_%@", actionString, targetString, self.accessibilityIdentifier);
    }
}
@end
