//
//  QSProcessImageManager.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSProcessImageConfig.h"

typedef void(^QSProcessImageCompletionBlock)(UIImage *outputImage);

#pragma mark - QSProcessImageManager
@interface QSProcessImageManager : NSObject

+ (void)processImage:(UIImage *)image
              config:(QSProcessImageConfig *)config
           completed:(QSProcessImageCompletionBlock)completedBlock;

+ (void)processImage:(UIImage *)image
              config:(QSProcessImageConfig *)config
               cache:(SDImageCache *)cache
            cacheKey:(NSString *)cacheKey
           completed:(QSProcessImageCompletionBlock)completedBlock;

+ (UIImage *)processImage:(UIImage *)image
                   config:(QSProcessImageConfig *)config;

@end
