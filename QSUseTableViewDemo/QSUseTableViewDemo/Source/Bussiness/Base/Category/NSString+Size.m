//
//  NSString+Size.m
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)textSizeWithFont:(UIFont*)font{
    
    CGSize textSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    textSize = CGSizeMake((int)ceil(textSize.width), (int)ceil(textSize.height));
    return textSize;
}

/**
 根据字体、行数、行间距和constrainedWidth计算文本占据的size
 **/
- (CGSize)textSizeWithFont:(UIFont*)font
                numberOfLines:(NSInteger)numberOfLines
                  lineSpacing:(CGFloat)lineSpacing
             constrainedWidth:(CGFloat)constrainedWidth
            isLimitedToLines:(BOOL *)isLimitedToLines{
    
    if (self.length == 0) {
        return CGSizeZero;
    }
    CGFloat oneLineHeight = font.lineHeight;
    CGSize textSize = [self boundingRectWithSize:CGSizeMake(constrainedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    CGFloat rows = textSize.height / oneLineHeight;
    CGFloat realHeight = oneLineHeight;
    // 0 不限制行数
    if (numberOfLines == 0) {
        if (rows >= 1) {
            realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
        }
    }else{
        if (rows > numberOfLines) {
            rows = numberOfLines;
            if (isLimitedToLines) {
                *isLimitedToLines = YES;  //被限制
            }
        }
        realHeight = (rows * oneLineHeight) + (rows - 1) * lineSpacing;
    }
    
    return CGSizeMake(ceil(constrainedWidth),ceil(realHeight));
}

@end
