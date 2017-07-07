//
//  QSFPSLabel.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSFPSLabel.h"
#import "YYWeakProxy.h"

@implementation QSFPSLabel{
    
    CADisplayLink *_displayLink;
    NSUInteger _count;
    NSTimeInterval _lastTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = NO;
        self.textColor = [UIColor whiteColor];
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        _displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(timerFire:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }

    return self;
}

- (void)dealloc {
    
    [_displayLink invalidate];
}

- (void)timerFire:(CADisplayLink *)link
{
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    self.text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    [self sizeToFit];
}


@end
