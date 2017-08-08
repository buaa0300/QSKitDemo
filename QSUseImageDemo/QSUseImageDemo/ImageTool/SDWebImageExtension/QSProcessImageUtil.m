//
//  QSProcessImageUtil.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageUtil.h"

/**
 裁圆角
 */
void QSProcessImageCorners(CGContextRef context, UIImage *originImage, QSProcessImageConfig *config) {
    
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    if (!CGSizeEqualToSize(CGSizeZero, rect.size) && cornerRadius > 0 && config.corners != QSProcessImageCornerNone) {
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            byRoundingCorners:(UIRectCorner)config.corners
                                                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [config.bgColor setFill];
        [bgRect fill];
        [roundRectPath addClip];
        [originImage drawInRect:rect];
    }
    CGContextRestoreGState(context);
}


@implementation QSProcessImageUtil

+ (UIImage *)processImage:(UIImage *)originImage config:(QSProcessImageConfig *)config{
    
    CGRect rect = { CGPointZero, config.outputSize };
    
    UIGraphicsBeginImageContextWithOptions(config.outputSize, YES, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    QSProcessImageCorners(ctx,originImage,config);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
