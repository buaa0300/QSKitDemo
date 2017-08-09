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

#pragma mark - 图片处理block
@class QSProcessImageConfig;
typedef void(^QSProcessImageBlock)(CGContextRef context, UIImage *image, QSProcessImageConfig *config);


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
//other property


//
@property (nonatomic, copy) QSProcessImageBlock processBlock;

//默认：缩放到指定大小且像素对齐
+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize;

//圆角图片处理默认：缩放到指定大小且像素对齐 + 圆形
+ (instancetype)roundCofigWithOutputSize:(CGSize)outputSize;

//缩放到指定大小且像素对齐 + 自定义圆角
+ (instancetype)configWithOutputSize:(CGSize)outputSize
                        cornerRadius:(CGFloat)cornerRadius
                             corners:(QSProcessImageCorner)corners;


//自定义图片处理
+ (instancetype)configWithOutputSize:(CGSize)outputSize
                        cornerRadius:(CGFloat)cornerRadius
                             corners:(QSProcessImageCorner)corners
                        processBlock:(QSProcessImageBlock)processBlock;



//init方法1
- (instancetype)initWithOutputSize:(CGSize)outputSize
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                      processBlock:(QSProcessImageBlock)processBlock;

//init方法2
- (instancetype)initWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                            opaque:(BOOL)opaque
                      processBlock:(QSProcessImageBlock)processBlock;

@end

