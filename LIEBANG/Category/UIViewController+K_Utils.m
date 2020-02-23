//
//  UIViewController+K_Utils.m
//  MarryLoveApp
//
//  Created by caominglei on 2019/10/9.
//  Copyright © 2019 caominglei. All rights reserved.
//

#import "UIViewController+K_Utils.h"

#import <objc/runtime.h>

@implementation UIViewController (K_Utils)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
               // When swizzling a class method, use the following:
                           // Class class = object_getClass((id)self);
        
               SEL originalSelector = @selector(presentViewController:animated:completion:);
                SEL swizzledSelector = @selector(cx_presentViewController:animated:completion:);
        
               Method originalMethod = class_getInstanceMethod(class, originalSelector);
                Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
               BOOL didAddMethod =
                               class_addMethod(class,
                       originalSelector,
                       method_getImplementation(swizzledMethod),
                       method_getTypeEncoding(swizzledMethod));
        
               if (didAddMethod) {
                               class_replaceMethod(class,
                       swizzledSelector,
                       method_getImplementation(originalMethod),
                       method_getTypeEncoding(originalMethod));
               } else {
                   method_exchangeImplementations(originalMethod, swizzledMethod);
               }
//        swizzling_exchangeMethod([self class], @selector(presentViewController:animated:completion:), @selector(cx_presentViewController:animated:completion:));
    });
}

- (void)cx_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    //设置满屏，不需要小卡片
    if(@available(iOS 13.0, *)) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self cx_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
