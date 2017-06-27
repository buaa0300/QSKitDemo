//
//  CADisplayLink+QSTool.h
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class CADisplayLink;

typedef void(^QSExecuteDisplayLinkBlock) (CADisplayLink *displayLink);

@interface CADisplayLink (QSTool)

@property (nonatomic,copy)QSExecuteDisplayLinkBlock executeBlock;

+ (CADisplayLink *)displayLinkWithExecuteBlock:(QSExecuteDisplayLinkBlock)block;

@end
