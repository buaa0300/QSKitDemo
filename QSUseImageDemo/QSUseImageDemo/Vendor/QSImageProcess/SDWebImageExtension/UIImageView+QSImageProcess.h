//
//  UIImageView+QSImageProcess.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/11.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSImageProcessConfig.h"

@interface UIImageView (QSImageProcess)

/**
 加载并显示网络图片，调用前需要先设置好UIImageView的frame或bounds
 
 @param url 图片url
 @param placeholder 图片处理配置对象
 */
- (void)qs_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;


/**
  加载并显示网络图片

 @param url 图片url
 @param placeholder 占位图
 @param config 图片处理配置对象
 */
- (void)qs_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                    config:(QSImageProcessConfig *)config;




@end
