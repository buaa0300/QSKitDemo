//
//  NSTimer+QSTool.h
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^QSExecuteTimerBlock) (NSTimer *timer);

@interface NSTimer (QSTool)

+ (NSTimer *)qs_scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval executeBlock:(QSExecuteTimerBlock)block repeats:(BOOL)repeats;

@end
