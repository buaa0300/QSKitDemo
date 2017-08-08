//
//  QSProcessImageManager.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageManager.h"

#pragma mark - QSProcessImageManager
@implementation QSProcessImageManager

+ (void)imageWithOriginImage:(UIImage *)originImage config:(QSProcessImageConfig *)config completed:(QSProcessImageCompletionBlock)completedBlock{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *newImage = [self p_processImageWithOriginImage:originImage config:config];
        
            dispatch_async(dispatch_get_main_queue(),^{
                               if (completedBlock) {
                                   completedBlock(newImage);
                               }
                           });
    });
    
    
}

+ (UIImage *)p_processImageWithOriginImage:(UIImage *)originImage config:(QSProcessImageConfig *)config{

    BOOL isNeedDrawImage = YES;
    
    //图片的scale和屏幕的scale相同，才可以防止像素不对齐问题
    if ((originImage.scale == [UIScreen mainScreen].scale)) {
        
        if (!config || config.outputSize.width <= 0 || config.outputSize.height <= 0 || config.cornerRadius <= 0) {
            isNeedDrawImage = NO;
        }
        
        if (CGSizeEqualToSize(config.outputSize, originImage.size) && config.cornerRadius == 0) {
            isNeedDrawImage = NO;
        }
    }

    if (!isNeedDrawImage) {
        return originImage;
    }
    
    
    //开启绘制（参考size,cornerRadius)
    CGRect rect = CGRectMake(0, 0, config.outputSize.width, config.outputSize.height);
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:config.cornerRadius];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    if (config.bgColor) {
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [config.bgColor setFill];
        [bgRect fill];
    }
    
    //裁剪
    [roundRectPath addClip];
    //绘制
    [originImage drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}





@end
