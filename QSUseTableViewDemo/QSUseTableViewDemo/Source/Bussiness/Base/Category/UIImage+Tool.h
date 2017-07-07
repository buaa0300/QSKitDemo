//
//  UIImage+Tool.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/17.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tool)

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size;

@end
