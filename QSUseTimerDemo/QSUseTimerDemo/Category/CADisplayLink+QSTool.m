//
//  CADisplayLink+QSTool.m
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "CADisplayLink+QSTool.h"
#import <objc/runtime.h>

@implementation CADisplayLink (QSTool)

- (void)setExecuteBlock:(QSExecuteDisplayLinkBlock)executeBlock{

    objc_setAssociatedObject(self, @selector(executeBlock), [executeBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (QSExecuteDisplayLinkBlock)executeBlock{

    return objc_getAssociatedObject(self, @selector(executeBlock));
}

+ (CADisplayLink *)displayLinkWithExecuteBlock:(QSExecuteDisplayLinkBlock)block{

    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(qs_executeDisplayLink:)];
    displayLink.executeBlock = [block copy];
    return displayLink;
}

+ (void)qs_executeDisplayLink:(CADisplayLink *)displayLink{

    if (displayLink.executeBlock) {
        displayLink.executeBlock(displayLink);
    }
}

@end
