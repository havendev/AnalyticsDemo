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
@end

NS_ASSUME_NONNULL_END
