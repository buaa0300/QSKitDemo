//
//  QSBaseTableViewCell.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseTableViewCell.h"

@implementation QSBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviewsWithUrl:(NSURL *)url{

    
}

+ (CGFloat)cellHeight{

    return 44.0f;
}

@end
