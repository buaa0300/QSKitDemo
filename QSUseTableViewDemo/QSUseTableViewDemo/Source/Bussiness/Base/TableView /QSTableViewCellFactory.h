//
//  QSTableViewCellFactory.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 2017/7/28.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QSTableViewCell;

/**
 负责cell的创建、高度计算以及
 */
@interface QSTableViewCellFactory : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

- (CGFloat)cellHeightForData:(id)data;

- (QSTableViewCell *)cellInstanceForData:(id)data;

@end
