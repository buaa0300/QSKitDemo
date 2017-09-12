//
//  NSObject+Swizzle.m
//  QSSwizzleKitDemo
//
//  Created by shaoqing on 2017/9/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (void)load{

   //调换IMP
    Method originalMethod = class_getInstanceMethod([NSObject class], @selector(description));
    Method myMethod = class_getInstanceMethod([NSObject class], @selector(qs_description));
    method_exchangeImplementations(originalMethod, myMethod);
}

- (void)qs_description{
    
    NSLog(@"description 被 Swizzle 了");
    return [self qs_description];
}

@end
