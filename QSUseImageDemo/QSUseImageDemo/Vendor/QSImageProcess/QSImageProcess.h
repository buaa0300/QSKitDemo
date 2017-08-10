//
//  QSImageProcess.h
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSImageProcessConfig.h"

typedef void(^QSImageProcessCompletedBlock)(UIImage *outputImage);

@class QSImageProcessConfig;

@interface QSImageProcess : NSObject

/**
 图片处理配置对象
 */
@property (nonatomic,strong)QSImageProcessConfig *config;


+ (nonnull instancetype)sharedImageProcess;


/**
 异步图片处理

 @param image 待处理的图片
 @param config 图片处理配置描述
 @param completedBlock 处理完成块
 */
- (void)processImage:(UIImage *)image
              config:(QSImageProcessConfig *)config
           completed:(QSImageProcessCompletedBlock)completedBlock;



/**
 同步图片处理

 @param image 待处理的图片
 @param config 图片处理配置描述
 @return 返回处理好的图片
 */
- (UIImage *)processImage:(UIImage *)image
                   config:(QSImageProcessConfig *)config;


@end
