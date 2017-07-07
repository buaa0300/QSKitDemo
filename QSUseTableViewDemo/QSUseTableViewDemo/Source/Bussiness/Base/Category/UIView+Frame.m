//
//  UIView+Frame.m
//  QSViewKit
//
//  Created by 姜中平 on 16/2/27.
//  Copyright © 2016年 qingshao. All rights reserved.
//

#import "UIView+Frame.h"


@implementation UIView (Frame)

#pragma mark - 上
- (void)setQsTop:(CGFloat)qsTop{

    CGRect frame = self.frame;
    frame.origin.y = qsTop;
    self.frame = frame;
}

- (CGFloat)qsTop{
    
    return self.frame.origin.y;
}

#pragma mark - 左

- (void)setQsLeft:(CGFloat)qsLeft{
    
    CGRect frame = self.frame;
    frame.origin.x = qsLeft;
    self.frame = frame;
}

- (CGFloat)qsLeft{
    
    return self.frame.origin.x;
}

#pragma mark - 下
- (void)setQsBottom:(CGFloat)qsBottom{

    CGRect frame = self.frame;
    frame.origin.y = qsBottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)qsBottom{
    
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;

}


#pragma mark - 右
- (void)setQsRight:(CGFloat)qsRight{
    
    CGRect frame = self.frame;
    frame.origin.y = qsRight - frame.size.width;
    self.frame = frame;
}

- (CGFloat)qsRight{
    
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
    
}


#pragma mark - 宽

- (void)setQsWidth:(CGFloat)qsWidth{

    CGRect frame = self.frame;
    frame.size.width = qsWidth;
    self.frame = frame;
}

- (CGFloat)qsWidth{

    return self.frame.size.width;
}

#pragma mark - 高
- (void)setQsHeight:(CGFloat)qsHeight{

    CGRect frame = self.frame;
    frame.size.height = qsHeight;
    self.frame = frame;
}

- (CGFloat)qsHeight{
    
    return self.frame.size.height;
}

#pragma mark - 中心点
- (void)setQsCenterX:(CGFloat)qsCenterX{
    
    CGPoint center = self.center;
    center.x = qsCenterX;
    self.center = center;
}

- (CGFloat)qsCenterX
{
    return self.center.x;
}

- (void)setQsCenterY:(CGFloat)qsCenterY{
    
    CGPoint center = self.center;
    center.y = qsCenterY;
    self.center = center;
}

- (CGFloat)qsCenterY
{
    return self.center.y;
    
}



@end
