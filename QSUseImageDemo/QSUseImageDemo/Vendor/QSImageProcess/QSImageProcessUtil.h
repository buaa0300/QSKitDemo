//
//  QSImageProcessUtil.h
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSImageProcessConfig;

/**
 图片处理1 - 裁剪圆角

 @param context 图形上下文
 @param image 需要处理的图片
 @param config 图片处理的配置对象
 */
void QSImageProcessClipCorner(CGContextRef context, UIImage *image, QSImageProcessConfig *config);


/**
 图片处理1 - 环形

 @param context 图形上下文
 @param image 需要处理的图片
 @param config 图片处理的配置对象
 */
void QSImageProcessRound(CGContextRef context, UIImage *image, QSImageProcessConfig *config);


/**
 图片处理3 - 给图片添加渐变蒙版(默认色)
 
 @param context 图形上下文
 @param image 需要处理的图片
 @param config 图片处理的配置对象
 */
void QSImageProcessAddGradationMask(CGContextRef context, UIImage *image, QSImageProcessConfig *config);


/**
 图片处理4 - 给图片添加整块蒙版
 
 @param context 图形上下文
 @param image 需要处理的图片
 @param config 图片处理的配置对象
 */
void QSImageProcessAddWholeMask(CGContextRef context, UIImage *image, QSImageProcessConfig *config);

