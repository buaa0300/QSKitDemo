//
//  QSImageProcess.m
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageProcess.h"
#import "QSDispatchQueue.h"
#import "QSImageProcessUtil.h"

@implementation QSImageProcess

#pragma mark - Singleton, init, dealloc
+ (nonnull instancetype)sharedImageProcess {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (void)dealloc{

}

#pragma mark - process Image
- (void)processImage:(UIImage *)image
              config:(QSImageProcessConfig *)config
           completed:(QSImageProcessCompletedBlock)completedBlock{
    
    //图片处理queue
    [[QSDispatchQueue processImageQueue]async:^{
        
        UIImage *newImage = [self processImage:image config:config];
        NSLog(@"currentThread info is: %@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(),^{
            if (completedBlock) {
                completedBlock(newImage);
            }
        });
    }];
}

- (UIImage *)processImage:(UIImage *)image
                   config:(QSImageProcessConfig *)config{
    
    if (CGSizeEqualToSize(config.outputSize, image.size)
        && [UIScreen mainScreen].scale == image.scale
        && config.cornerRadius == 0) {
        return image;
    }
    
    CGRect rect = {CGPointZero, config.outputSize};
    UIGraphicsBeginImageContextWithOptions(rect.size,config.opaque, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (config.option == QSImageProcessOptionClipCorner) {
        
        QSImageProcessClipCorner(context, image, config);
    
    }else if(config.option == QSImageProcessOptionCircle){
        
        config.cornerRadius = (MIN(config.outputSize.width, config.outputSize.height)) /2.0f;
        config.corners = UIRectCornerAllCorners;
        QSImageProcessClipCorner(context, image, config);
    }

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
