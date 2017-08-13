//
//  UILabel+FitLines.m
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UILabel+FitLines.h"
#import "NSString+Size.h"
#import <objc/runtime.h>

@implementation UILabel (FitLines)

/**
 行间距
 */
- (void)setQsLineSpacing:(CGFloat)qsLineSpacing{
    
    objc_setAssociatedObject(self, @selector(qsLineSpacing), [NSNumber numberWithFloat:qsLineSpacing], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)qsLineSpacing{
    
    return [objc_getAssociatedObject(self, @selector(qsLineSpacing)) floatValue];
}

/**
 最大显示宽度
 */
- (void)setQsConstrainedWidth:(CGFloat)qsConstrainedWidth{

    objc_setAssociatedObject(self, @selector(qsConstrainedWidth), [NSNumber numberWithFloat:qsConstrainedWidth], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)qsConstrainedWidth{
    
    return [objc_getAssociatedObject(self, @selector(qsConstrainedWidth)) floatValue];
}

/**
 文本适应于指定的行数
 @return 文本是否被numberOfLines限制
 */
- (BOOL)qs_adjustTextToFitLines:(NSInteger)numberOfLines{

    if (!self.text || self.text.length == 0) {
        return NO;
    }
    
    self.numberOfLines = numberOfLines;
    BOOL isLimitedToLines = NO;
    
    CGSize textSize = [self.text textSizeWithFont:self.font numberOfLines:self.numberOfLines lineSpacing:self.qsLineSpacing constrainedWidth:self.qsConstrainedWidth isLimitedToLines:&isLimitedToLines];
    
    //单行的情况
    if (fabs(textSize.height - self.font.lineHeight) < 0.00001f) {
        self.qsLineSpacing = 0.0f;
    }
    
    //设置文字的属性
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:self.qsLineSpacing];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;//结尾部分的内容以……方式省略
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [self.text length])];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [self.text length])];
    
    
    [self setAttributedText:attributedString];
    self.bounds = CGRectMake(0, 0, textSize.width, textSize.height);
    return isLimitedToLines;
}

@end
