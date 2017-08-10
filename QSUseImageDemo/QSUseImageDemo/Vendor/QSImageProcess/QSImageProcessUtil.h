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
 @param config 图片处理的配置描述
 */
void QSImageProcessClipCorner(CGContextRef context, UIImage *image, QSImageProcessConfig *config);
