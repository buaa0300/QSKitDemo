//
//  UIImageView+SDWebImageExtension.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSProcessImageManager.h"

@interface UIImageView (SDWebImageExtension)

- (void)qs_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                    config:(QSProcessImageConfig *)config;

/**
 调用前需要先设置好View的frame或bounds
 */
- (void)qs_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder;

@end
