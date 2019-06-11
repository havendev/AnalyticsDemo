//
//  UITableView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/4.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UITableView+Logger.h"
#import "NSObject+Logger.h"
#import <objc/runtime.h>
#import "RuntimeHelper.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UITableView (Logger)
+ (void)load {

}

#pragma --
#pragma UITableViewDelegate
- (void)hook_tableViewDidSelectRowAtIndexPathInClass:(id)object {
    [[self class] swizzleDelegate:object fromSelector:@selector(tableView:didSelectRowAtIndexPath:) toSelector:@selector(insertToableView:didSelectRowAtIndexPath:)];
}

- (void)insertToableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,tableView,indexPath);
        NSLog(@"标识：%@_%@_%@_section%ld_row%ld", NSStringFromClass([self class]), [RuntimeHelper nameWithClass:self instance:tableView], NSStringFromSelector(@selector(tableView:didSelectRowAtIndexPath:)), indexPath.section, indexPath.row);
    }
}
@end
