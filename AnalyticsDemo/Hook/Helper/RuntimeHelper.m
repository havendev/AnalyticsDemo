//
//  RuntimeHelper.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/4.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "RuntimeHelper.h"
#import <objc/runtime.h>

@implementation RuntimeHelper
+ (NSString *)nameWithClass:(id)object instance:(id)instance {
    unsigned int numIvars = 0;
    NSString *key=nil;
    Ivar * ivars = class_copyIvarList([object class], &numIvars);
    
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
                
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        if ((object_getIvar(object, thisIvar) == instance)) {//此处 crash 不要慌！
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            break;
        }
    }
    free(ivars);
    return key;
}

@end
