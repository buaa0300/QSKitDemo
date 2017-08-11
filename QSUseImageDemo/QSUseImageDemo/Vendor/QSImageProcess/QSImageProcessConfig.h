//
//  QSImageProcessConfig.h
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+QSImageProcess.h"

typedef NS_ENUM(NSInteger,QSImageProcessOption) {
    QSImageProcessOptionDefault = 0,
    QSImageProcessOptionClipCorner = 1,
    QSImageProcessOptionCircle = 2,
    QSImageProcessOptionRound = 3,
    QSImageProcessOptionAddGradationMask = 4,
    QSImageProcessOptionAddWholeMask = 5
};

@interface QSImageProcessConfig : NSObject

/**
 图片处理选项
 */
@property (nonatomic,assign)QSImageProcessOption option;

/**
 图片的输出大小
 */
@property (nonatomic, assign) CGSize outputSize;

/**
 裁剪图片需要的背景颜色
 */
@property (nonatomic, strong) UIColor *clipBgColor;

/**
 圆角半径,值为0不处理圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 需要处理的圆角
 */
@property (nonatomic, assign) UIRectCorner corners;

/**
 CG创建上下文，是否不透明
 */
@property (nonatomic, assign) BOOL opaque;

/**
 默认的图片(不透明)配置
 */
+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize;

/**
 默认的图片(不透明)配置,可配置背景色
 */
+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize clipBgColor:(UIColor *)clipBgColor;

/**
 不透明的圆形图片配置,需要设置clipBgColor
 */
+ (instancetype)circleConfigWithOutputSize:(CGSize)outputSize clipBgColor:(UIColor *)clipBgColor;

/**
 透明的圆形图片配置
 */
+ (instancetype)circleConfigWithOutputSize:(CGSize)outputSize;

/**
 圆角图片配置
 */
+ (instancetype)configWithOutputSize:(CGSize)outputSize cornerRadius:(CGFloat)cornerRadius corners:(UIRectCorner)corners;


/**
 init方法
 */
- (instancetype)initWithOutputSize:(CGSize)outputSize;

@end
