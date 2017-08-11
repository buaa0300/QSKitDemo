//
//  QSTableViewCell1.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseTableViewCell.h"
/**
 正常
 */
@interface QSTableViewCell1 : QSBaseTableViewCell

- (void)layoutSubviewsWithUrl:(NSURL *)url;

+ (CGFloat)cellHeight;

@end
