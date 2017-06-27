//
//  NSMutableArray+WeakReferences.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSMutableArray+WeakReferences.h"

@implementation NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferences {
    
    return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // Cast of C pointer type 'CFMutableArrayRef' (aka 'struct __CFArray *') to Objective-C pointer type 'id' requires a bridged cast
    return (id)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
    // return (id)(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end
