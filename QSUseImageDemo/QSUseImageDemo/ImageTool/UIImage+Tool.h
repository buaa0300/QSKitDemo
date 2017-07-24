//
//  UIImage+Tool.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/17.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

#pragma mark - 绘制
/**
 根据颜色绘制图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size;

/**
 按比例缩放图片，scale就是缩放比例
 */
- (UIImage *)scaleImageWithScale:(CGFloat)scale;

/**
 缩放图片到指定宽
 */
- (UIImage *)scaleImageToTargetWidth:(CGFloat)targetW;

/**
 缩放图片到指定高
 */
- (UIImage *)scaleImageToTargetHeight:(CGFloat)targetH;


#pragma mark - 裁剪

/**
  裁剪出圆角矩形

 @param cornerRadius 圆角半径
 @param bgColor 背景色
 */
- (UIImage *)clipImageWithCornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor;

/**
 根据贝塞尔路径来裁剪
 */
- (UIImage *)clipImageWithPath:(UIBezierPath *)path bgColor:(UIColor *)bgColor;

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)clipImageWithRect:(CGRect)rect;

#pragma mark - 图片压缩
/**
 压缩到指定像素px
 */
- (UIImage *)compressImageToTargetPx:(CGFloat)targetPx;


/**
 压缩到指定千字节(kb)
 */
- (NSData *)compressImageToTargetKB:(NSInteger )numOfKB;



@end
