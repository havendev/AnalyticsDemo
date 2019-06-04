//
//  UITableView+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/4.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UITableView+Logger.h"
#import "HHook.h"
#import "RuntimeHelper.h"

#define GET_CLASS_CUSTOM_SEL(sel,class)  NSSelectorFromString([NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),NSStringFromSelector(sel)])

@implementation UITableView (Logger)
+ (void)load {

}

#pragma --
#pragma UITableViewDelegate
- (void)swizzling_tableViewDidSelectRowAtIndexPathInClass:(id)object {
    SEL fromSelector = @selector(tableView:didSelectRowAtIndexPath:);
    SEL toSelector = @selector(hook_tableView:didSelectRowAtIndexPath:);
    
    [HHook hookDelegate:object FromSelector:fromSelector ToSelector:toSelector Object:self];
}

- (void)hook_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SEL sel = GET_CLASS_CUSTOM_SEL(@selector(tableView:didSelectRowAtIndexPath:),[self class]);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,tableView,indexPath);
        
        NSLog(@"标识：%@_%@_%@_section%ld_row%ld", NSStringFromClass([self class]), [RuntimeHelper nameWithClass:self instance:tableView], NSStringFromSelector(@selector(tableView:didSelectRowAtIndexPath:)), indexPath.section, indexPath.row);
    }
}
@end
