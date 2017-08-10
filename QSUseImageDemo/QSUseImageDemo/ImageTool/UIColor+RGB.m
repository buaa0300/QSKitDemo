//
//  UIColor+RGB.m
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+ (UIColor *) colorWithRGB:(NSUInteger)rgb
{
    return [UIColor colorWithRGB:rgb alpha:1.0f];
}

+ (UIColor *) colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha
{
    NSUInteger red = ( (rgb&0xff0000) >> 16 );
    NSUInteger green = ( (rgb&0xff00) >> 8 );
    NSUInteger blue = ( rgb & 0xFF );
    CGFloat r = (CGFloat)red / 255.0f;
    CGFloat g = (CGFloat)green  / 255.0f;
    CGFloat b = (CGFloat)blue / 255.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

#pragma mark - 基本的配色

+ (UIColor *) appMainColor{
    
    return QSRGB16Color(0x0076ff);
}


+ (UIColor *)backgroundColor{
    
    return QSRGB16Color(0xf3f3f7);
}

+ (UIColor *)navigationBarBgColor{
    
    return QSRGB16Color(0xf7f7f9);
    //QSRGB16Color(0x6f7378);
    //;
}

+ (UIColor *) titleNormalColor{
    
    return QSRGB16Color(0x333333);
}

+ (UIColor *) titleGrayColor{
    
    return QSRGB16Color(0x6f7378);
}

+ (UIColor *) titleLightGrayColor{
    
    return QSRGB16Color(0xadb1b9);
}

+ (UIColor *) titleVeryLightGrayColor{
    
    return QSRGB16Color(0xf6f6f9);
}

+ (UIColor *) dividerLineColor{
    
    return QSRGB16Color(0xe1e1ee);
}

+ (UIColor *) searchBarBgColor{
    
    return QSRGB16Color(0xe5e6ec);
}

+ (UIColor *) buttonClickBgGrayColor{
    
    return QSRGB16Color(0xf3f3f7);
}




@end
