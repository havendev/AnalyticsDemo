//
//  UIResponder+UIAutoTest.m
//  AFWealth
//
//  Created by Yinxl on 11/1/16.
//  Copyright © 2016 opensource. All rights reserved.
//

#import "UIResponder+UIAutoTest.h"
#import <objc/runtime.h>
#import "RuntimeHelper.h"

@implementation UIResponder (UIAutoTest)

- (NSString *)findNameWithInstance:(UIView *)instance
{
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
