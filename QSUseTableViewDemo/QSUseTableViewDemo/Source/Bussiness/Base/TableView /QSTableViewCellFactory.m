//
//  QSTableViewCellFactory.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 2017/7/28.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCellFactory.h"
#import "QSTableViewCell.h"

@interface QSTableViewCellFactory()

@property (nonatomic,weak)UITableView *tableView;

@end

@implementation QSTableViewCellFactory

- (instancetype)initWithTableView:(UITableView *)tableView{

    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

#pragma mark - 计算cell高度
- (CGFloat)cellHeightForData:(id)data{
    
    if (!data || ![data isKindOfClass:[QSTableViewCellModel class]]) {
        return CGFLOAT_MIN;
    }
    
    QSTableViewCellModel *cellModel = (QSTableViewCellModel *)data;
    Class cellClass = [cellModel cellClass];
    if (cellClass != Nil && [cellClass isSubclassOfClass:[QSTableViewCell class]]) {
        return [cellClass cellHeightWithModel:cellModel];
    }
    return CGFLOAT_MIN;
}

#pragma mark - 获取cell
- (QSTableViewCell *)cellInstanceForData:(id)data{

    QSTableViewCell *cell = nil;
    if (data && [data isKindOfClass:[QSTableViewCellModel class]]) {
        
        QSTableViewCellModel *cellModel = (QSTableViewCellModel *)data;
        Class cellClass = [cellModel cellClass];
        cell = [self.tableView dequeueReusableCellWithIdentifier:cellModel.cellClassName];
        
        if (!cell) {
            if (cellClass && [cellClass isSubclassOfClass:[QSTableViewCell class]]) {
                cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellModel.cellClassName];
            }else{
                
                NSLog(@"cellClass[%@] Error!!",NSStringFromClass(cellClass));
            }
        }
    }
    
    //safe,make sure not return nil
    if (!cell) {
        cell = [[QSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QSTableViewCell"];
    }
    return cell;
}

@end
