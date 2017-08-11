//
//  UIColor+QSImageProcess.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/11.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIColor+QSImageProcess.h"

@implementation UIColor (QSImageProcess)

+ (UIColor *) colorWithRGB:(NSUInteger)rgb{
    
    return [UIColor colorWithRGB:rgb alpha:1.0f];
}

+ (UIColor *) colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha{
    
    NSUInteger red = ( (rgb&0xff0000) >> 16 );
    NSUInteger green = ( (rgb&0xff00) >> 8 );
    NSUInteger blue = ( rgb & 0xFF );
    CGFloat r = (CGFloat)red / 255.0f;
    CGFloat g = (CGFloat)green  / 255.0f;
    CGFloat b = (CGFloat)blue / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}


- (NSString *)colorValue{

    CGFloat redValue, greenValue, blueValue, alphaValue;
    NSString *value = @"novalue";
    if ([self getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue]) {
        value = [NSString stringWithFormat:@"%.0lf_%.0lf_%.0lf_%.0lf",redValue,greenValue,blueValue,alphaValue];
    }
    return value;
}

@end
