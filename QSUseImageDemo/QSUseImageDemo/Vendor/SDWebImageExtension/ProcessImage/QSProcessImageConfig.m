//
//  QSProcessImageConfig.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageConfig.h"

#pragma mark - process Block
//默认处理：缩放指定大小 + 裁圆角
QSProcessImageBlock __QSDefaultProcessImageBlock = ^(CGContextRef context, UIImage *image, QSProcessImageConfig *config){
    
    CGContextSaveGState(context);
    CGRect rect = CGContextGetClipBoundingBox(context);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) / 2.0f;
    CGFloat cornerRadius = MIN(config.cornerRadius, radius);
    
    if (!CGSizeEqualToSize(CGSizeZero, rect.size)){
        
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        UIColor *bgColor = config.bgColor;
        if (!bgColor) {
            bgColor = [UIColor whiteColor];
        }
        [bgColor setFill];
        [bgRect fill];
    }
    
    //裁剪圆角
    if (cornerRadius > 0 && config.corners != QSProcessImageCornerNone) {
        
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                            byRoundingCorners:(UIRectCorner)config.corners
                                                                  cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [roundRectPath addClip];
        
    }
    [image drawInRect:rect];
    CGContextRestoreGState(context);
};


#pragma mark - QSProcessImageConfig
@implementation QSProcessImageConfig

+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize{

    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:outputSize cornerRadius:0 corners:QSProcessImageCornerNone processBlock:__QSDefaultProcessImageBlock];
    
    return [self configWithOutputSize:outputSize
                         cornerRadius:0
                              corners:QSProcessImageCornerNone];
    
    return config;
}

+ (instancetype)roundCofigWithOutputSize:(CGSize)outputSize{

    return [self configWithOutputSize:outputSize
                         cornerRadius:MIN(outputSize.width, outputSize.height)/2.0
                              corners:QSProcessImageCornerAllCorners];
}

+ (instancetype)configWithOutputSize:(CGSize)outputSize
                        cornerRadius:(CGFloat)cornerRadius
                             corners:(QSProcessImageCorner)corners{

    return [self configWithOutputSize:outputSize
                         cornerRadius:cornerRadius
                              corners:corners
                         processBlock:__QSDefaultProcessImageBlock];

}

+ (instancetype)configWithOutputSize:(CGSize)outputSize
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                      processBlock:(QSProcessImageBlock)processBlock{
    
    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:outputSize
                                                                      cornerRadius:cornerRadius
                                                                           corners:corners
                                                                      processBlock:processBlock];
    
    return config;
}

- (instancetype)configWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
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

- (instancetype)initWithOutputSize:(CGSize)outputSize
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                      processBlock:(QSProcessImageBlock)processBlock{
    
    return [self initWithOutputSize:outputSize
                            bgColor:[UIColor whiteColor]
                       cornerRadius:cornerRadius
                            corners:corners
                             opaque:YES
                       processBlock:processBlock];
}

- (instancetype)initWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
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
    return [NSString stringWithFormat:@"width=%.0lf&height=%.0lf&corners=%lu&cornerradius=%.1lf&opaque=%d",self.outputSize.width,self.outputSize.height,(unsigned long)self.corners,round(self.cornerRadius),self.opaque];
}

@end

