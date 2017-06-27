//
//  QSThreadSafeCounter.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSThreadSafeCounter.h"
#import <libkern/OSAtomic.h>

@implementation QSThreadSafeCounter{

    int32_t _value;
}


- (int32_t)value
{
    return _value;
}

- (int32_t)increase {
    return OSAtomicIncrement32(&_value);
}

@end
