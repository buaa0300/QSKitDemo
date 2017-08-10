//
//  QSProcessImageConfig.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageConfig.h"
#import "UIColor+Value.h"
#import "UIColor+RGB.h"

#pragma mark - process Block
//默认处理：缩放指定大小 + 裁圆角
static QSProcessImageBlock __QSDefaultProcessImageBlock = ^(CGContextRef context, UIImage *image, QSProcessImageConfig *config){
    
    //保存当前图形上下文的状态，以免影响其它地方的绘制
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    if (!CGSizeEqualToSize(CGSizeZero, rect.size)){
        
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        UIColor *bgColor = config.bgColor;
        if (bgColor) {
            [bgColor setFill];
            [bgRect fill];
        }
      
    }
    
    //裁剪圆角
    if (cornerRadius > 0 && config.corners != 0) {
        
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            byRoundingCorners:(UIRectCorner)config.corners
                                                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [roundRectPath addClip];
        
    }
    //绘制图形，只显示裁剪区域中的部分
    [image drawInRect:rect];
    //保存当前图形上下文的状态，以免影响其它地方的绘制
    CGContextRestoreGState(context);
};


#pragma mark - QSProcessImageConfig
@implementation QSProcessImageConfig

+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize{

    return [self configWithOutputSize:outputSize
                         cornerRadius:0
                              corners:0];
}

+ (instancetype)circleCofigWithOutputSize:(CGSize)outputSize{

    return [self circleCofigWithOutputSize:outputSize opaque:NO];

}

+ (instancetype)circleCofigWithOutputSize:(CGSize)outputSize
                                   opaque:(BOOL)opaque{

    UIColor *bgColor = nil;
    if (opaque) {
        bgColor = [UIColor whiteColor];
    }
    
    return [self configWithOutputSize:outputSize
                              bgColor:bgColor
                         cornerRadius:MIN(outputSize.width, outputSize.height)/2.0
                              corners:UIRectCornerAllCorners
                               opaque:opaque
                         processBlock:__QSDefaultProcessImageBlock];
    
}

+ (instancetype)configWithOutputSize:(CGSize)outputSize
                        cornerRadius:(CGFloat)cornerRadius
                             corners:(UIRectCorner)corners{

    return [self configWithOutputSize:outputSize
                              bgColor:[UIColor whiteColor]
                         cornerRadius:cornerRadius
                              corners:corners
                               opaque:YES
                         processBlock:__QSDefaultProcessImageBlock];
}

+ (instancetype)configWithOutputSize:(CGSize)outputSize
                             bgColor:(UIColor *)bgColor
                        cornerRadius:(CGFloat)cornerRadius
                             corners:(UIRectCorner)corners
                              opaque:(BOOL)opaque
                        processBlock:(QSProcessImageBlock)processBlock{
    
    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:outputSize
                                                                           bgColor:bgColor
                                                                      cornerRadius:cornerRadius
                                                                           corners:corners
                                                                            opaque:opaque
                                                                      processBlock:processBlock];
    
    return config;
}

//init方法
- (instancetype)initWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(UIRectCorner)corners
                            opaque:(BOOL)opaque
                      processBlock:(QSProcessImageBlock)processBlock{
    self = [super init];
    if (self) {
        _outputSize = outputSize;
        _bgColor = bgColor;
        _cornerRadius = MIN(cornerRadius, MIN(outputSize.width, outputSize.height) / 2.0f);
        _corners = corners;
        _opaque = opaque;
        if (!processBlock) {
            _processBlock = [__QSDefaultProcessImageBlock copy];
        }else{
            _processBlock = [processBlock copy];
        }
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"width=%.0lf_height=%.0lf_corners=%lu_cornerradius=%.1lf_opaque=%d_color=%@",self.outputSize.width,self.outputSize.height,(unsigned long)self.corners,round(self.cornerRadius),self.opaque,[self.bgColor colorValueString]];
}

@end

