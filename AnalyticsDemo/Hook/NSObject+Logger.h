//
//  NSObject+Logger.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/10.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Logger)
+ (void)swizzleSelectorFromSelector:(SEL)originalSelector toSelector:(SEL)swizzledSelector;


+ (BOOL)delegate:(id)delegateObject isContain:(SEL)selector;
+ (void)swizzleDelegate:(id)delegateObject fromSelector:(SEL)fromSelector toSelector:(SEL)toSelector;
@end

NS_ASSUME_NONNULL_END
