//
//  UIImage+Logger.m
//  AnalyticsDemo
//
//  Created by Haven on 2019/6/10.
//  Copyright © 2019 Haven. All rights reserved.
//

#import "UIImage+Logger.h"
#import "NSObject+Logger.h"
#import <objc/runtime.h>

@implementation UIImage (Logger)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        Class imageClass = NSClassFromString(@"UIImage");
        [object_getClass(imageClass) swizzleSelectorFromSelector:@selector(imageNamed:) toSelector:@selector(hook_imageNamed:)];
    });
}

+ (UIImage *)hook_imageNamed:(NSString *)imageName {
    UIImage *image = [UIImage hook_imageNamed:imageName];
    image.accessibilityIdentifier = imageName;
    return image;
}

@end
