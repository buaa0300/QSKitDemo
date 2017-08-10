//
//  QSImageProcessUtil.m
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageProcessUtil.h"
#import "QSImageProcessConfig.h"

// 图片处理1 - 裁剪圆角
void QSImageProcessClipCorner(CGContextRef context, UIImage *image, QSImageProcessConfig *config){
    
    //保存当前图形上下文的状态，以免影响其它地方的绘制
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    //不透明，裁剪的时候才需要绘制背景
    if (!CGSizeEqualToSize(CGSizeZero, rect.size) && config.clipBgColor && config.opaque == YES){
        
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [config.clipBgColor setFill];
        [bgRect fill];
    }
    
    //裁剪
    if (cornerRadius > 0 && config.corners != 0) {
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            byRoundingCorners:config.corners
                                                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [roundRectPath addClip];
        
    }
    //绘制图形，只显示裁剪区域中的部分
    [image drawInRect:rect];
    ////恢复图形上下文状态
    CGContextRestoreGState(context);
};
