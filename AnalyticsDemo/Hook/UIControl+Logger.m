//
//  UIControl+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/30.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIControl+Logger.h"
#import "HHook.h"

@implementation UIControl (Logger)

+ (void) load {
    
    //可监听到UIButton、UITextField、UISwitch、UISegmentedControl、UISlider 、UIStepper等控件的Action事件
    SEL fromSelector = @selector(sendAction:to:forEvent:);
    SEL toSelector = @selector(hook_sendAction:to:forEvent:);
    [HHook hookClass:self FromSelector:fromSelector ToSelector:toSelector];
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
