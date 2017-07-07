//
//  UIImage+Tool.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/17.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIImage+Tool.h"
#import <objc/runtime.h>

@implementation UIImage (Tool)

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size{
    
    if (CGSizeEqualToSize(size, self.size)) {
        return self;
    }
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    //绘图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
