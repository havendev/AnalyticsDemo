//
//  UITableView+Logger.h
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/4.
//  Copyright © 2019 Haven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Logger)
- (void)hook_tableViewDidSelectRowAtIndexPathInClass:(id)object;
@end

NS_ASSUME_NONNULL_END
