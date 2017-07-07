//
//  UIView+Frame.h
//  QSViewKit
//
//  Created by 姜中平 on 16/2/27.
//  Copyright © 2016年 qingshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

//(位置：)上，左，下，右
@property (nonatomic, assign) CGFloat qsTop;
@property (nonatomic, assign) CGFloat qsLeft;

@property (nonatomic, assign) CGFloat qsBottom;
@property (nonatomic, assign) CGFloat qsRight;

//(大小：)宽 和 高
@property (nonatomic, assign) CGFloat qsWidth;
@property (nonatomic, assign) CGFloat qsHeight;

//中心点
@property (nonatomic, assign) CGFloat qsCenterX;
@property (nonatomic, assign) CGFloat qsCenterY;


@end
