//
//  CrashHandler.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/18.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CrashHandler : NSObject

//信号量截断
void registerSignalHandler(void);
//系统异常捕获
void InstallUncaughtExceptionHandler(void);

@end

NS_ASSUME_NONNULL_END
