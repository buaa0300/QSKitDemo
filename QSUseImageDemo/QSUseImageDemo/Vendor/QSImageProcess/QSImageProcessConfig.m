//
//  QSImageProcessConfig.m
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageProcessConfig.h"

//@interface UIColor (Value)
//
//- (NSString *)colorValueString;
//
//@end
//
//@implementation UIColor (Value)
//
//- (NSString *)colorValueString{
//    
//    CGFloat redValue, greenValue, blueValue, alphaValue;
//    NSString *value = @"";
//    if ([self getRed:&redValue green:&greenValue blue:&blueValue alpha:&alphaValue]) {
//        value = [NSString stringWithFormat:@"%.0lf_%.0lf_%.0lf_%.0lf",redValue,greenValue,blueValue,alphaValue];
//    }
//    return value;
//}
//
//@end

@implementation QSImageProcessConfig

- (instancetype)initWithOutputSize:(CGSize)outputSize{

    self = [super init];
    if (self) {
        _option = QSImageProcessOptionDefault;
        _outputSize = outputSize;
        _clipBgColor = [UIColor whiteColor];
        _cornerRadius = 0.0f;
        _corners = 0;
        _opaque = YES;  //不透明
    }
    return self;
}

//- (NSString *)description{
//    return [NSString stringWithFormat:@"width=%.0lf_height=%.0lf_corners=%lu_cornerradius=%.1lf_opaque=%d_color=%@",self.outputSize.width,self.outputSize.height,(unsigned long)self.corners,round(self.cornerRadius),self.opaque,[self.bgColor colorValueString]];
//}


@end
