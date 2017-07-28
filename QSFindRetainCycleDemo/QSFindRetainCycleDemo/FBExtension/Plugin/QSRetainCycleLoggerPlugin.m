//
//  QSRetainCycleLoggerPlugin.m
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSRetainCycleLoggerPlugin.h"

@implementation QSRetainCycleLoggerPlugin

- (void)memoryProfilerDidFindRetainCycles:(NSSet *)retainCycles{
    
    if (retainCycles.count > 0) {
        NSLog(@"\nretainCycles = \n%@",retainCycles);
    }
}

@end
