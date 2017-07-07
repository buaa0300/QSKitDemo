//
//  QSDemoContentCell.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell.h"

#pragma mark - QSDemoContentCellModel
@interface QSDemoContentCellModel : QSTableViewCellModel

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *content;

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content;

- (void)calcCellHeight;

@end


#pragma mark - QSDemoContentCell
@interface QSDemoContentCell : QSTableViewCell

@end
