//
//  QSProcessImageManager.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageManager.h"

#pragma mark - 图片处理函数
/**
 处理图片
 */
void QSProcessImageAction(CGContextRef context, UIImage *originImage, QSProcessImageConfig *config);

#pragma mark - QSProcessImageManager
@implementation QSProcessImageManager

+ (void)processImage:(UIImage *)image
              config:(QSProcessImageConfig *)config
           completed:(QSProcessImageCompletionBlock)completedBlock{
    
    [self processImage:image config:config cache:nil cacheKey:nil completed:completedBlock];
}

+ (void)processImage:(UIImage *)image
              config:(QSProcessImageConfig *)config
               cache:(SDImageCache *)cache
            cacheKey:(NSString *)cacheKey
           completed:(QSProcessImageCompletionBlock)completedBlock{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *newImage = [self processImage:image config:config];
        if (cache && cacheKey && cacheKey.length > 0 && image) {
            [cache storeImage:image forKey:cacheKey completion:nil];
        }
        dispatch_async(dispatch_get_main_queue(),^{
            if (completedBlock) {
                completedBlock(newImage);
            }
        });
    });
}


+ (UIImage *)processImage:(UIImage *)image
                   config:(QSProcessImageConfig *)config{

    return [self p_processImage:image config:config];
}

#pragma mark - 真正处理
+ (UIImage *)p_processImage:(UIImage *)image
                     config:(QSProcessImageConfig *)config{

    if (CGSizeEqualToSize(config.outputSize, image.size)
        && [UIScreen mainScreen].scale == image.scale
        && config.cornerRadius == 0) {
        return image;
    }
    
    CGRect rect = {CGPointZero, config.outputSize};
    UIGraphicsBeginImageContextWithOptions(rect.size, config.opaque, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    QSProcessImageAction(ctx,image,config);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - 图片处理函数
/**
 处理图片
 */
void QSProcessImageAction(CGContextRef context, UIImage *originImage, QSProcessImageConfig *config){
    
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    if (!CGSizeEqualToSize(CGSizeZero, rect.size)){
        
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        UIColor *bgColor = config.bgColor;
        if (!bgColor) {
            bgColor = [UIColor whiteColor];
        }
        [bgColor setFill];
        [bgRect fill];
    }
    
    //裁剪圆角
    if (cornerRadius > 0 && config.corners != QSProcessImageCornerNone) {
    
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            byRoundingCorners:(UIRectCorner)config.corners
                                                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [roundRectPath addClip];
        
    }
    [originImage drawInRect:rect];
    CGContextRestoreGState(context);
}







@end
