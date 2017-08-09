//
//  UIColor+Value.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIColor+Value.h"

@implementation UIColor (Value)

- (NSString *)colorValueString{

    CGFloat redValue, greenValue, blueValue, alphaValue;
    NSString *value = @"";
    if ([self getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue]) {
       value = [NSString stringWithFormat:@"%.0lf_%.0lf_%.0lf_%.0lf",redValue,greenValue,blueValue,alphaValue];
    }
    return value;
}

@end
