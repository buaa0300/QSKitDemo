//
//  UIColor+QSImageProcess.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/11.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QSImageProcess)

+ (UIColor *) colorWithRGB:(NSUInteger)rgb;

+ (UIColor *) colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha;

- (NSString *) colorValue;

@end
