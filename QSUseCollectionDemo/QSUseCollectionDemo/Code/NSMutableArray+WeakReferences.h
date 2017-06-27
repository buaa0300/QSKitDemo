//
//  NSMutableArray+WeakReferences.h
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)

+ (id)mutableArrayUsingWeakReferences;

+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;

@end
