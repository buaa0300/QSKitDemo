//
//  QSProcessImageUtil.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageConfig.h"

void QSProcessImageCorners(CGContextRef context, UIImage *inputImage, QSProcessImageConfig *config);

@interface QSProcessImageUtil : NSObject

//+ (UIImage *)processImage:(QSProcessImageConfig *)config{
//
//    
//    
//    UIGraphicsBeginImageContextWithOptions(self.outputSize, opaque, 0.0);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextClearRect(ctx, rect);
//    
//    self.processBlock(ctx, inputImage, self);
//    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//}

+ (UIImage *)processImage:(UIImage *)originImage config:(QSProcessImageConfig *)config;


@end
