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

- (void)qs_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder config:(QSProcessImageConfig *)config;


@end
