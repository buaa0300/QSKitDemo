//
//  QSImageProcessConfig.h
//  QSUseImageDemo
//
//  Created by shaoqing on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QSImageProcessOption) {
    QSImageProcessOptionDefault = 0,
    QSImageProcessOptionClipCorner = 1,
    QSImageProcessOptionCircle = 2,
    
};

@interface QSImageProcessConfig : NSObject

/**
 图片处理选项
 */
@property (nonatomic,assign)QSImageProcessOption option;

/**
 图片的输出大小
 */
@property (nonatomic, assign) CGSize outputSize;

/**
 裁剪图片需要的背景颜色
 */
@property (nonatomic, strong) UIColor *clipBgColor;

/**
 圆角半径,值为0不处理圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 需要处理的圆角
 */
@property (nonatomic, assign) UIRectCorner corners;

/**
 CG创建上下文，是否不透明
 */
@property (nonatomic, assign) BOOL opaque;


/**
 init方法
 */
- (instancetype)initWithOutputSize:(CGSize)outputSize;

@end
