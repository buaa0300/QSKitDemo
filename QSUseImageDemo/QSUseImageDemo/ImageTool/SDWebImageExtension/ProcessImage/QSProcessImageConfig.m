//
//  QSProcessImageConfig.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageConfig.h"

@implementation QSProcessImageConfig

+ (instancetype)defaultConfigWithOutputSize:(CGSize)outputSize{

    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:outputSize cornerRadius:0 corners:QSProcessImageCornerNone];
    
    return config;
}

+ (instancetype)roundCofigWithOutputSize:(CGSize)outputSize{

    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:outputSize cornerRadius:outputSize.width/2 corners:QSProcessImageCornerAllCorners];
    
    return config;
}

- (instancetype)initWithOutputSize:(CGSize)outputSize
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners{
    
    return [self initWithOutputSize:outputSize
                            bgColor:[UIColor whiteColor]
                       cornerRadius:cornerRadius
                            corners:corners
                             opaque:YES];
}

- (instancetype)initWithOutputSize:(CGSize)outputSize
                           bgColor:(UIColor *)bgColor
                      cornerRadius:(CGFloat)cornerRadius
                           corners:(QSProcessImageCorner)corners
                            opaque:(BOOL)opaque{
    self = [super init];
    if (self) {
        _outputSize = outputSize;
        _bgColor = bgColor;
        _cornerRadius = cornerRadius;
        _corners = corners;
        _opaque = opaque;
    }
    return self;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@-%.0lf",NSStringFromCGSize(self.outputSize), round(self.cornerRadius)];
}

@end

