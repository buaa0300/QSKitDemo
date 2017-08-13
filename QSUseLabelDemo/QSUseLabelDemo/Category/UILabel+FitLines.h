//
//  UILabel+FitLines.h
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FitLines)

/**
 最大显示宽度
 */
@property (nonatomic,assign)CGFloat qsConstrainedWidth;


/**
 行间距
 */
@property (nonatomic,assign)CGFloat qsLineSpacing;


/**
 文本适应于指定的行数
 @return 文本是否被numberOfLines限制
 */
- (BOOL)qs_adjustTextToFitLines:(NSInteger)numberOfLines;

@end
