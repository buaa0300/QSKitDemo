//
//  QSProcessImageConfig.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QSProcessImageCorner) {
    QSProcessImageCornerNone = 0,                               //无圆角
    QSProcessImageCornerLeftTop = UIRectCornerTopLeft,          //左上
    QSProcessImageCornerLeftBottom = UIRectCornerBottomLeft,    //左下
    QSProcessImageCornerRightBottom = UIRectCornerBottomRight,  //右下
    QSProcessImageCornerRightTop = UIRectCornerTopRight,        //右上
    QSProcessImageCornerAllCorners = UIRectCornerAllCorners
};

#pragma mark - QSProcessImageConfig
@interface QSProcessImageConfig : NSObject
/**
 图片输出大小
 */
@property (nonatomic, assign) CGSize outputSize;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) CGFloat cornerRadius;          //圆角半径,值为0不处理圆角
@property (nonatomic, assign) QSProcessImageCorner corners;  //需要处理的圆角
@property (nonatomic, assign) BOOL opaque;                   //是否透明

+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize;

+ (instancetype)roundCofigWithOutputSize:(CGSize)outputSize;

- (instancetype)initWithOutputSize:(CGSize)outputSize
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners;

- (instancetype)initWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                            opaque:(BOOL)opaque;

@end

