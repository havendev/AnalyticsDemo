//
//  AppDelegate.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/5/28.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "AppDelegate.h"
#import "CrashHandler.h"
//#import <UMCommon/UMCommon.h>

@interface AppDelegate () {
    NSTimer *timer;
    int counter;
    
    UIBackgroundTaskIdentifier taskIden;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //配置友盟环境
//    [UMConfigure setEncryptEnabled:YES];        //打开加密传输
//    [UMConfigure setLogEnabled:YES];            //设置打开日志
//    [UMConfigure initWithAppkey:@"" channel:@"App Store"];
    
    counter = 0;
    
    registerSignalHandler();//信号量截断
    InstallUncaughtExceptionHandler();//系统异常捕获
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

    NSLog(@"__applicationDidEnterBackground %@", [self getNow]);
    
    [self beginTask];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeat) userInfo:nil repeats:YES];

}

- (void)beginTask {
    NSLog(@"begin=============");
    taskIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBack]; // 如果在系统规定时间内任务还没有完成，在时间到之前会调用到这个方法，一般是3~10分钟
    }];
}

- (void)endBack {
    NSLog(@"end============= %@", [self getNow]);
    [[UIApplication sharedApplication] endBackgroundTask:taskIden];
    taskIden = UIBackgroundTaskInvalid;
}

- (void)repeat {
    counter ++;
    
    NSLog(@"__counter %d", counter);
    
    //3分钟后打印堆栈信息并结束后台运行
    if(counter == 5) {
        
        //当前堆栈信息
        NSLog(@"---%@", [NSThread callStackSymbols]);
        NSLog(@"---%@", [NSThread callStackReturnAddresses]);
        
        //强行抛一个错误结束
//        @throw [NSException exceptionWithName:@"context show" reason:@"crush's reason" userInfo:nil];
        
        [timer invalidate];
        timer = nil;
        
        [self endBack];
    }
}

- (NSString *)getNow {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    NSString *current = [formatter stringFromDate:date];
    return current;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
