//
//  UIColor+RGB.h
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

#define QSRGB16Color(rgbValue) [UIColor colorWithRGB:rgbValue];

+ (UIColor *) colorWithRGB:(NSUInteger)rgb;

+ (UIColor *) colorWithRGB:(NSUInteger)rgb alpha:(CGFloat)alpha;

+ (UIColor *) appMainColor;

+ (UIColor *) backgroundColor;

+ (UIColor *) navigationBarBgColor;

+ (UIColor *) titleNormalColor;
+ (UIColor *) titleGrayColor;
+ (UIColor *) titleLightGrayColor;
+ (UIColor *) titleVeryLightGrayColor;

+ (UIColor *) dividerLineColor;

+ (UIColor *) searchBarBgColor;

+ (UIColor *) buttonClickBgGrayColor;



@end
