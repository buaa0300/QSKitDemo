//
//  QSDemoBigStyleCell.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell.h"

@interface QSDemoBigStyleCellModel : QSTableViewCellModel

@property (nonatomic,copy)NSString *bgImageName;
@property (nonatomic,copy)NSString *iconImageName;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subTitle;

- (instancetype)initWithbgImageName:(NSString *)bgImageName
                      iconImageName:(NSString *)iconImageName
                              title:(NSString *)title
                           subTitle:(NSString *)subTitle;

@end

@interface QSDemoBigStyleCell : QSTableViewCell




@end
