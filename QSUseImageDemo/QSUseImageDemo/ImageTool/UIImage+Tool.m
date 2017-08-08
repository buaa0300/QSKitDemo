//
//  UIImage+Tool.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/17.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIImage+Tool.h"
#import <objc/runtime.h>
#import "NSData+Length.h"

@implementation UIImage (Tool)

#pragma mark - 绘制
/**
 根据颜色绘制图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{

    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //创建位图上下文，并设置为当前上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置填充
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 缩放
/**
 缩放图片到指定Size
 */
- (UIImage *)scaleImageWithSize:(CGSize)size{
    
    //创建上下文
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    
    //绘图
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    //获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 按比例缩放图片
 */
- (UIImage *)scaleImageWithScale:(CGFloat)scale{
    
    if (scale < 0) {
        return self;
    }
    
    CGSize scaleSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    return [self scaleImageWithSize:scaleSize];
}


/**
 缩放图片到指定宽
 */
- (UIImage *)scaleImageToTargetWidth:(CGFloat)targetW{

    CGSize size = self.size;
    if (size.width <= targetW) {
        return self;
    }
    
    CGFloat scale = targetW / size.width;
    return [self scaleImageWithScale:scale];
}

/**
 缩放图片到指定高
 */
- (UIImage *)scaleImageToTargetHeight:(CGFloat)targetH{
    
    CGSize size = self.size;
    if (size.height <= targetH) {
        return self;
    }
    
    CGFloat scale = targetH / size.height;
    return [self scaleImageWithScale:scale];
}

#pragma mark - 裁剪
- (UIImage *)clipImageWithPath:(UIBezierPath *)path bgColor:(UIColor *)bgColor{
    
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    //创建位图上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, self.scale);
    if (bgColor) {
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [bgColor setFill];
        [bgRect fill];
    }
    //裁剪
    [path addClip];
    //绘制
    [self drawInRect:rect];
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return clipImage;
}

/**
 裁剪圆角图片
 */
- (UIImage *)clipImageWithCornerRadius:(CGFloat)cornerRadius bgColor:(UIColor *)bgColor{
    
    
    
    
    
    CGSize imageSize = self.size;
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);

    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    return [self clipImageWithPath:roundRectPath bgColor:bgColor];
}

/**
 从指定的rect裁剪出图片
 */
- (UIImage *)clipImageWithRect:(CGRect)rect{
    
    CGFloat scale = self.scale;
    CGImageRef clipImageRef = CGImageCreateWithImageInRect(self.CGImage,
                                                          CGRectMake(rect.origin.x * scale,
                                                                     rect.origin.y  * scale,
                                                                     rect.size.width * scale,
                                                                     rect.size.height * scale));
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(clipImageRef)/scale, CGImageGetHeight(clipImageRef)/scale);
    
    
    UIGraphicsBeginImageContextWithOptions(smallBounds.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // clipImage是将要绘制的UIImage图片(防止图片上下颠倒)
    CGContextTranslateCTM(context, 0, smallBounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, smallBounds.size.width, smallBounds.size.height), clipImageRef);
    
//    CGContextDrawImage(context, smallBounds, clipImageRef);
    UIImage* clipImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    CGImageRelease(clipImageRef);
    return clipImage;
}

#pragma mark - 图片加载(方法混写swizzle)
+ (instancetype)qs_imageWithName:(NSString *)name{
    
    UIImage *image = [UIImage qs_imageWithName:name];
    
    if (image == nil) {
        NSLog(@"loding image is null:%@", name);
    }
    return image;
}

+ (void)load{
    
    Method qs_imageWithName = class_getClassMethod([UIImage class], @selector(qs_imageWithName:));
    Method imageNamed = class_getClassMethod([UIImage class], @selector(imageNamed:));
    method_exchangeImplementations(imageNamed, qs_imageWithName);
}

#pragma mark - 图片压缩

/**
 压缩到指定像素px
 */
- (UIImage *)compressImageToTargetPx:(CGFloat)targetPx{

    UIImage *compressImage = nil;
    
    CGSize imageSize = self.size;
    CGFloat compressScale = 0; //压缩比例
    
    //压缩后的目标size
    CGSize targetSize = CGSizeMake(targetPx, targetPx);
    //实际宽高比例
    CGFloat factor = imageSize.width / imageSize.height;
    
    if (imageSize.width < targetSize.width && imageSize.height < targetSize.height) {
        //图片实际宽高 都小于 目标宽高，没必要压缩
        compressImage = self;
        
    }else if (imageSize.width > targetSize.width && imageSize.height > targetSize.height){
        //图片实际宽高 都大于 目标宽高
        if (factor <= 2) {
            //宽高比例小于等于2,获取大的等比压缩
            compressScale = targetPx / MAX(imageSize.width,imageSize.height);
        }else{
            //宽高比例大于2,获取小的等比压缩
            compressScale = targetPx / MIN(imageSize.width,imageSize.height);
        }
    }else if(imageSize.width > targetSize.width && imageSize.height < imageSize.height){
        //宽大于目标宽,高小于目标高
        if (factor <= 2) {
            compressScale = targetSize.width / imageSize.width;
        }else{
            compressImage = self;
        }
    }else if(imageSize.width < targetSize.width && imageSize.height > imageSize.height){
        //宽小于目标宽,高大于目标高
        if (factor <= 2) {
            compressScale = targetSize.height / imageSize.height;
        }else{
            compressImage = self;
        }
    }
    
    //需要压缩
    if (compressScale > 0 && !compressImage) {
        
        CGSize compressSize = CGSizeMake(self.size.width * compressScale, self.size.height * compressScale);
        UIGraphicsBeginImageContextWithOptions(compressSize, YES, 1);
        [self drawInRect:CGRectMake(0, 0, compressSize.width, compressSize.height)];
        compressImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (!compressImage) {
        compressImage = self;
    }
    
    return compressImage;
}

/**
 压缩到指定千字节(kb)
 */
- (NSData *)compressImageToTargetKB:(NSInteger )numOfKB{

    CGFloat compressionQuality = 0.9f;
    CGFloat compressionCount = 0;
    
    NSData *imageData = UIImageJPEGRepresentation(self,compressionQuality);
    
    while (imageData.length >= 1000 * numOfKB && compressionCount < 15) {  //15是最大压缩次数.mac中文件大小1000进制
        compressionQuality = compressionQuality * 0.9;
        compressionCount ++;
        imageData = UIImageJPEGRepresentation(self, compressionQuality);
    }
    return imageData;
}




@end
