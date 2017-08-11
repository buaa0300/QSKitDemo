//
//  QSImageProcessConfig.m
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageProcessConfig.h"

@implementation QSImageProcessConfig

/**
 默认的图片(不透明)配置
 */
+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize{

    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:outputSize];
    config.option = QSImageProcessOptionDefault;
    config.clipBgColor = [UIColor whiteColor];
    return config;
}


/**
 默认的图片(不透明)配置,可配置背景色
 */
+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize clipBgColor:(UIColor *)clipBgColor{
    
    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:outputSize];
    config.option = QSImageProcessOptionDefault;
    config.clipBgColor = [UIColor whiteColor];
    return config;
}

/**
 默认圆形(不透明)图片配置
 */
+ (instancetype)circleConfigWithOutputSize:(CGSize)outputSize clipBgColor:(UIColor *)clipBgColor{
    
    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:outputSize];
    config.clipBgColor = clipBgColor;
    config.option = QSImageProcessOptionCircle;
    config.cornerRadius = (MIN(config.outputSize.width, config.outputSize.height)) /2.0f;
    config.corners = UIRectCornerAllCorners;
    return config;
}

/**
 透明的圆形图片配置
 */
+ (instancetype)circleConfigWithOutputSize:(CGSize)outputSize {

    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:outputSize];
    config.opaque = NO;
    config.option = QSImageProcessOptionCircle;
    config.cornerRadius = (MIN(config.outputSize.width, config.outputSize.height)) /2.0f;
    config.corners = UIRectCornerAllCorners;
    return config;
}


/**
 圆角图片(不透明)配置
 */
+ (instancetype)configWithOutputSize:(CGSize)outputSize cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners{

    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:outputSize];
    config.cornerRadius = cornerRadius;
    config.corners = corners;
    config.option = QSImageProcessOptionClipCorner;
    config.clipBgColor = [UIColor whiteColor];
    return config;
}

- (instancetype)initWithOutputSize:(CGSize)outputSize{

    self = [super init];
    if (self) {
        _option = QSImageProcessOptionDefault;
        _outputSize = outputSize;
        _clipBgColor = [UIColor whiteColor];
        _cornerRadius = 0.0f;
        _corners = 0;
        _opaque = YES;  //不透明
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"option=%d&width=%.0lf_height=%.0lf_corners=%lu_cornerradius=%.1lf_opaque=%d_color=%@",(int)self.option,self.outputSize.width,self.outputSize.height,(unsigned long)self.corners,round(self.cornerRadius),self.opaque,[self.clipBgColor colorValue]];
}

@end
