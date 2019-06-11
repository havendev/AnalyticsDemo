//
//  UIResponder+Logger.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/5.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Logger)
- (NSString *)findNameWithInstance:(UIView *) instance;
@end

NS_ASSUME_NONNULL_END
