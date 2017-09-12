//
//  UIButton+QSSwizzleKit.m
//  QSSwizzleKitDemo
//
//  Created by zhongpingjiang on 2017/9/7.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIButton+QSSwizzleKit.h"
#import <objc/runtime.h>
#import "RSSwizzle.h"

@implementation UIButton (QSSwizzleKit)

- (NSTimeInterval)qs_acceptEventInterval {
    return  [objc_getAssociatedObject(self, @selector(qs_acceptEventInterval)) doubleValue];
}

- (void)setQs_acceptEventInterval:(NSTimeInterval)qs_acceptEventInterval {
    objc_setAssociatedObject(self, @selector(qs_acceptEventInterval), @(qs_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)qs_acceptEventTime {
    return  [objc_getAssociatedObject(self, @selector(qs_acceptEventTime)) doubleValue];
}

- (void)setQs_acceptEventTime:(NSTimeInterval)qs_acceptEventTime {
    objc_setAssociatedObject(self, @selector(qs_acceptEventTime), @(qs_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// a bad solutions ，which may cause carsh
// 在load时执行hook
//+ (void)load {
//    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method after    = class_getInstanceMethod(self, @selector(qs_sendAction:to:forEvent:));
//    method_exchangeImplementations(before, after);
//}


//+ (void)load {
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = [self class];
//        
//        SEL originalSelector = @selector(sendAction:to:forEvent:);
//        SEL swizzledSelector = @selector(qs_sendAction:to:forEvent:);
//        
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        
//        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//        if (success) {
//            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}

+ (void)load{

    RSSwizzleInstanceMethod([UIButton class], @selector(sendAction:to:forEvent:), RSSWReturnType(void), RSSWArguments(SEL action,id target,UIEvent *event), RSSWReplacement({

            NSLog(@"hook了");
            UIButton *btn = self;
            if ([NSDate date].timeIntervalSince1970 - btn.qs_acceptEventTime < btn.qs_acceptEventInterval) {
                return;
            }
    
            if (btn.qs_acceptEventInterval > 0) {
                btn.qs_acceptEventTime = [NSDate date].timeIntervalSince1970;
            }
        
            RSSWCallOriginal(action,target,event);
    
    }), RSSwizzleModeAlways, NULL);
}

- (void)qs_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if ([NSDate date].timeIntervalSince1970 - self.qs_acceptEventTime < self.qs_acceptEventInterval) {
        return;
    }
    
    if (self.qs_acceptEventInterval > 0) {
        self.qs_acceptEventTime = [NSDate date].timeIntervalSince1970;
    }
    
    [self qs_sendAction:action to:target forEvent:event];
}




@end
