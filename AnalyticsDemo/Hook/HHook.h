//
//  HHook.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHook : NSObject
+ (void)hookClass:(Class)classObject FromSelector:(SEL)fromSelector ToSelector:(SEL)toSelector;

+ (BOOL)delegate:(id)delegateObject IsContain:(SEL)selector;
+ (void)hookDelegate:(id)delegateObject FromSelector:(SEL)fromSelector ToSelector:(SEL)toSelector Object:(id)object;
@end

NS_ASSUME_NONNULL_END
