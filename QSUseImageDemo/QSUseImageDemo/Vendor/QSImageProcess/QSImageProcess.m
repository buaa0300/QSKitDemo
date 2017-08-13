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
    
    switch (config.option) {
        case QSImageProcessOptionDefault:{
            [image drawInRect:rect];
        }
            break;
            
        case QSImageProcessOptionClipCorner:{
            QSImageProcessClipCorner(context, image, config);
        }
            break;
            
        case QSImageProcessOptionCircle:{
            QSImageProcessClipCorner(context, image, config);
        }
            break;
            
        case QSImageProcessOptionRound:{
            QSImageProcessRound(context, image, config);
        }
            break;
            
        case QSImageProcessOptionAddGradationMask:{
            QSImageProcessAddGradationMask(context, image, config);
        }
            break;
         
        case QSImageProcessOptionAddWholeMask:{
            QSImageProcessAddWholeMask(context, image, config);
        }
            
        default:
            break;
    }

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
