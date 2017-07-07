//
//  QSDemoSmallStyleCell.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell.h"

#pragma mark - QSDemoSmallStyleCellModel
@interface QSDemoSmallStyleCellModel : QSTableViewCellModel

@property (nonatomic,copy)NSString *iconName;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subTitle;
@property (nonatomic,assign)BOOL isNotice;

@property (nonatomic,copy)QSTableViewCellActionBlock noticeActBlock;

- (instancetype)initWithIconName:(NSString *)iconName
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                        isNotice:(BOOL)isNotice;

@end

#pragma mark - QSDemoSmallStyleCell
@interface QSDemoSmallStyleCell : QSTableViewCell



@end
