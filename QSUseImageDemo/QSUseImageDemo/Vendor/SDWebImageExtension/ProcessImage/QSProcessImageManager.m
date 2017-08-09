//
//  QSProcessImageManager.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageManager.h"
#import "QSDispatchQueue.h"

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

    //使用[QSDispatchQueue processImageQueue]控制最大线程并发数
    [[QSDispatchQueue processImageQueue]async:^{

        UIImage *newImage = [self processImage:image config:config];
        if (cache && cacheKey && cacheKey.length > 0 && image) {
            [cache storeImage:newImage forKey:cacheKey completion:nil];
        }
        NSLog(@"currentThread info is: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(),^{
            if (completedBlock) {
                completedBlock(newImage);
            }
        });
    }];
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
//    if(con)
    if (config.processBlock ) {
        config.processBlock(ctx, image, config);
    }
    
//    QSProcessImageAction(ctx,image,config);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
