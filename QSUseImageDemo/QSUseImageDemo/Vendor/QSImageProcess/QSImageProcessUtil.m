//
//  QSImageProcessUtil.m
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageProcessUtil.h"
#import "QSImageProcessConfig.h"
#import "UIColor+QSImageProcess.h"

// 图片处理1 - 裁剪圆角
void QSImageProcessClipCorner(CGContextRef context, UIImage *image, QSImageProcessConfig *config){
    
    //保存当前图形上下文的状态，以免影响其它地方的绘制
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    //不透明，裁剪的时候需要绘制背景
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

// 图片处理2 - 环形
void QSImageProcessRound(CGContextRef context, UIImage *image, QSImageProcessConfig *config){

    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    
    //不透明，裁剪的时候需要绘制背景
    if (!CGSizeEqualToSize(CGSizeZero, rect.size) && config.clipBgColor && config.opaque == YES){
        
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [config.clipBgColor setFill];
        [bgRect fill];
    }
    
    //直径大的圆
    UIBezierPath *bigOvalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
    //设置填充规则为奇偶填充
    bigOvalPath.usesEvenOddFillRule = YES;
    //直径小的圆
    UIBezierPath *smallOvalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.size.width/4, rect.size.height/4, rect.size.width/2, rect.size.height/2)];
    //将小圆添加到大圆路径上
    [bigOvalPath appendPath:smallOvalPath];
    //裁剪，两个路径形成一个环
    [bigOvalPath addClip];
    //绘制图像，填充奇偶规则表示的内部，即环状
    [image drawInRect:rect];
    CGContextRestoreGState(context);
}


/**
 图片处理3 - 给图片添加渐变蒙版(默认色)
 */
void QSImageProcessAddGradationMask(CGContextRef context, UIImage *image, QSImageProcessConfig *config){

    CGRect rect = CGContextGetClipBoundingBox(context);
    [image drawInRect:rect];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    UIColor *topColor = [UIColor colorWithRGB:0x000000 alpha:0.2];
    UIColor *midColor = [UIColor colorWithRGB:0x000000 alpha:0.4];
    UIColor *bottomColor = [UIColor colorWithRGB:0x000000 alpha:0.6];
    NSArray *colors =
    @[ (__bridge id)topColor.CGColor, (__bridge id)midColor.CGColor, (__bridge id)bottomColor.CGColor ];
    CGFloat locations[] = { 0.0, 0.5, 1.0 };
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(0, 0);
    CGPoint endPoint = CGPointMake(0, rect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
}


/**
 图片处理4 - 给图片添加整块蒙版
 */
void QSImageProcessAddWholeMask(CGContextRef context, UIImage *image, QSImageProcessConfig *config){

    CGRect rect = CGContextGetClipBoundingBox(context);
    [image drawInRect:rect];
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRGB:0xe3e3e3 alpha:0.2].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
}
