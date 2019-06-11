//
//  UIResponder+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/5.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIResponder+Logger.h"
#import <objc/runtime.h>
#import "RuntimeHelper.h"

@implementation UIResponder (Logger)
- (NSString *)findNameWithInstance:(UIView *)instance {
    id nextResponder = [self nextResponder];
    NSString *name = [RuntimeHelper nameWithClass:self instance:instance];
    if (!name) {
        return [nextResponder findNameWithInstance:instance];
    }
    if ([name hasPrefix:@"_"]) {  //去掉变量名的下划线前缀
        name = [name substringFromIndex:1];
    }
    return name;
}
@end
