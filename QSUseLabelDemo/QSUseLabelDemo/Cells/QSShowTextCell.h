//
//  QSShowTextCell.h
//  UILabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSShowTextCellModel : NSObject

@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign)NSInteger contentLines;
@property (nonatomic,assign)BOOL isOpen;

- (instancetype)initWithContent:(NSString *)content
                   contentLines:(CGFloat)contentLines
                         isOpen:(BOOL)isOpen;


@end

typedef void(^QCOpenContentBlock) (QSShowTextCellModel *cellModel);

@interface QSShowTextCell : UITableViewCell

@property (nonatomic,copy)QCOpenContentBlock openContentBlock;

- (void)layoutSubviewsWithModel:(QSShowTextCellModel *)model;

+ (CGFloat)cellHeightWithModel:(QSShowTextCellModel *)model;

@end
