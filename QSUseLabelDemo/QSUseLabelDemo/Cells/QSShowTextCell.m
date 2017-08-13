//
//  QSShowTextCell.m
//  UILabelDemo
//
//  Created by zhongpingjiang on 17/4/13.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSShowTextCell.h"

#define QSTextLineSpacing 5
#define QSTextFontSize 15

@implementation QSShowTextCellModel

- (instancetype)initWithContent:(NSString *)content contentLines:(CGFloat)contentLines isOpen:(BOOL)isOpen{

    if (self = [super init]) {
        self.content = content;
        self.contentLines = contentLines;
        self.isOpen = isOpen;
    }
    return self;
}


@end

@interface QSShowTextCell()

@property (nonatomic,strong)QSShowTextCellModel *cellModel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIButton *openContentBtn;

@end

@implementation QSShowTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.openContentBtn];
    }
    return self;
}

- (UILabel *)titleLabel{

    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 16)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{

    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:QSTextFontSize];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.qsConstrainedWidth = SCREEN_WIDTH - 30;
        _contentLabel.qsLineSpacing = QSTextLineSpacing;
    }
    return _contentLabel;
}


- (UIButton *)openContentBtn{
    
    if (!_openContentBtn) {
        _openContentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openContentBtn.backgroundColor = [UIColor lightTextColor];
        _openContentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        
        [_openContentBtn setTitle:@"显示全文" forState:UIControlStateNormal];
        [_openContentBtn setTitle:@"收起全文" forState:UIControlStateSelected];
        [_openContentBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_openContentBtn addTarget:self action:@selector(onOpenContentAction:) forControlEvents:UIControlEventTouchUpInside];
        _openContentBtn.hidden = YES;
    }
    return _openContentBtn;
}

- (void)layoutSubviewsWithModel:(QSShowTextCellModel *)model{

    _titleLabel.text = @"DESCRIPTION";
    self.cellModel = (QSShowTextCellModel *)model;
    
    _contentLabel.text = model.content;
    BOOL isLimitedToLines = [_contentLabel qs_adjustTextToFitLines:model.contentLines];
    _contentLabel.frame = CGRectMake(15, CGRectGetMaxY(self.titleLabel.frame) + 10, CGRectGetWidth( _contentLabel.bounds),CGRectGetHeight(_contentLabel.bounds));
    
    
    if (!isLimitedToLines && (model.contentLines != 0)) {
        self.openContentBtn.hidden = YES;
        
    }else{
        self.openContentBtn.hidden = NO;
        self.openContentBtn.selected = self.cellModel.isOpen;
    }

    if (!self.openContentBtn.hidden) {
        self.openContentBtn.frame = CGRectMake(15, CGRectGetMaxY(_contentLabel.frame) + 5, 80, 20);
    }
    _contentLabel.layer.borderColor = [UIColor redColor].CGColor;
    _contentLabel.layer.borderWidth = 1;
}

+ (CGFloat)cellHeightWithModel:(QSShowTextCellModel *)model{

    BOOL isLimitedToLines;
    CGSize textSize = [model.content textSizeWithFont:[UIFont systemFontOfSize:QSTextFontSize] numberOfLines:model.contentLines lineSpacing:QSTextLineSpacing constrainedWidth:SCREEN_WIDTH - 30 isLimitedToLines:&isLimitedToLines];
    
    CGFloat height = textSize.height + 54 + 25;
    if (!isLimitedToLines && (model.contentLines != 0)) {
        height -= 25;
    }
    return height;
}

- (void)onOpenContentAction:(UIButton *)btn{

    if (self.openContentBlock) {
        btn.selected = !btn.selected;
        self.cellModel.isOpen = btn.selected;
        self.openContentBlock(self.cellModel);
        [self layoutSubviewsWithModel:self.cellModel];
    }
}


@end
