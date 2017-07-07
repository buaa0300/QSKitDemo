//
//  QSDemoContentCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDemoContentCell.h"

@implementation QSDemoContentCellModel

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content{
    
    self = [super init];
    if (self) {
        self.title = QSString(title, @"");
        self.content = QSString(content, @"无");
    }
    return self;
}

- (void)calcCellHeight{
    
    CGFloat height = [self.content textSizeWithFont:[UIFont systemFontOfSize:13] numberOfLines:0 lineSpacing:5 constrainedWidth:SCREEN_WIDTH - 30 isLimitedToLines:nil].height + 71;
    self.cellHeight = height;
}

@end

#pragma mark - QSDemoContentCell

@interface QSDemoContentCell()

@property (nonatomic,strong)QSDemoContentCellModel *cellModel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *lineView;

@end

@implementation QSDemoContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 200, 16)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.qsConstrainedWidth = SCREEN_WIDTH - 30;
        _contentLabel.qsLineSpacing = 5;
    }
    return _contentLabel;
}

- (UIView *)lineView{

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (void)layoutWithModel:(id)model{
    
    if (!CHECK_VALID_MODEL(model, [QSDemoContentCellModel class])){
        return;
    }

    self.cellModel = (QSDemoContentCellModel *)model;
    
    _titleLabel.text = self.cellModel.title;
    _titleLabel.qsTop = 15;
    
    _contentLabel.text = self.cellModel.content;
    [_contentLabel qs_adjustTextToFitLines:0];
    _contentLabel.frame = CGRectMake(15, _titleLabel.qsBottom + 15, _contentLabel.bounds.size.width, _contentLabel.bounds.size.height);

    _lineView.frame = CGRectMake(0, self.cellModel.cellHeight -1/SCREEN_SCALE , SCREEN_WIDTH, 1/SCREEN_SCALE);
    NSLog(@"ds ");
    
}

+ (CGFloat)cellHeightWithModel:(id)model{
    
    return [super cellHeightWithModel:model];
}

@end
