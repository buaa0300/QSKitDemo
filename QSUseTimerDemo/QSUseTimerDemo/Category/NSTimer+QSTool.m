//
//  NSTimer+QSTool.m
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSTimer+QSTool.h"

@implementation NSTimer (QSTool)

+ (NSTimer *)qs_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(QSExecuteTimerBlock)block repeats:(BOOL)repeats{
 
    NSTimer *timer = [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(qs_executeTimer:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+ (void)qs_executeTimer:(NSTimer *)timer{

    QSExecuteTimerBlock block = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
