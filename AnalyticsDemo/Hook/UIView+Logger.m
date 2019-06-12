//
//  UIView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/5.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIView+Logger.h"
#import "UIResponder+Logger.h"
#import "NSObject+Logger.h"
#import <objc/runtime.h>

@implementation UIView (Logger)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        Class class = NSClassFromString(@"UIView");
        [class swizzleSelectorFromSelector:@selector(accessibilityIdentifier) toSelector:@selector(hook_accessibilityIdentifier)];
    });
}

#pragma mark - Method Swizzling
- (NSString *)hook_accessibilityIdentifier {
    NSString *labelStr = [self.superview findNameWithInstance:self];
    
    if (labelStr && ![labelStr isEqualToString:@""]) {
        //SB或XIB布局的，因获取不到image的name，所以至少要拉个变量名
        labelStr = [NSString stringWithFormat:@"%@",labelStr];
    } else {
        if ([self isKindOfClass:[UIButton class]]) {
            //UIButton 使用 button 的 text 和 image
            labelStr = [NSString stringWithFormat:@"%@%@",((UIButton *)self).titleLabel.text?:@"",((UIButton *)self).imageView.image.accessibilityIdentifier?:@""];
        }
    }
    
    [self setAccessibilityIdentifier:labelStr];
    return labelStr;
}

@end
