//
//  QSTableViewCell.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QSTableViewCellActionBlock) (_Nullable id userInfo);

#pragma mark - QSTableViewCellModel
@interface QSTableViewCellModel : NSObject

@property (nonatomic,copy)NSString  *cellClassName;
@property (nonatomic,copy)NSString  *componentViewId; //cell组成的View的id
@property (nonatomic,copy)QSTableViewCellActionBlock tapCellBlock;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)id userInfo;

- (Class)cellClass;

@end

#pragma mark - QSTableViewCell
@interface QSTableViewCell : UITableViewCell

#pragma mark - 子类重写
- (void)layoutWithModel:(id)model;

+ (CGFloat)cellHeightWithModel:(id)model;

- (void)onTapCellAction;

@end


NS_ASSUME_NONNULL_END
