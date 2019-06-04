//
//  RuntimeHelper.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/4.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeHelper : NSObject
+ (NSString *)nameWithClass:(id)object instance:(id)instance;
@end

NS_ASSUME_NONNULL_END
