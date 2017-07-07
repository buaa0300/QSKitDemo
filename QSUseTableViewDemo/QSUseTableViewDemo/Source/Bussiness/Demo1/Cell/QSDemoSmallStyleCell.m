//
//  QSDemoSmallStyleCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDemoSmallStyleCell.h"

#define kQSDemoSmallStyleCellHeight  60.0f

@implementation QSDemoSmallStyleCellModel

- (instancetype)initWithIconName:(NSString *)iconName
                           title:(NSString *)title
                        subTitle:(NSString *)subTitle
                        isNotice:(BOOL)isNotice{
    
    self = [super init];
    if (self) {
        self.iconName = iconName;
        self.title = title;
        self.subTitle = subTitle;
        self.isNotice = isNotice;
    }
    return self;
}

@end

#pragma mark - QSDemoSmallStyleCell

@interface QSDemoSmallStyleCell()

@property (nonatomic,strong)QSDemoSmallStyleCellModel *cellModel;
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *subTitleLabel;
@property (nonatomic,strong)UIButton *noticeBtn;

@end

@implementation QSDemoSmallStyleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    [self.contentView  addSubview:({
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (kQSDemoSmallStyleCellHeight - 40)/2, 40, 40)];
        _iconView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _iconView.layer.borderWidth = 0.5f;
        _iconView.layer.cornerRadius = 20;
        _iconView.layer.masksToBounds = YES;
        _iconView;
    })];
    
    [self.contentView addSubview:({
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel;
    })];
    
    [self.contentView addSubview:({
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.backgroundColor = [UIColor whiteColor];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel;
    })];
    
    [self.contentView addSubview:({
        
        _noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 65, (kQSDemoSmallStyleCellHeight - 25)/2, 50, 25)];
        _noticeBtn.backgroundColor = [UIColor clearColor];
        [_noticeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        [_noticeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_noticeBtn setTitle:@"未关注" forState:UIControlStateNormal];
        [_noticeBtn setTitle:@"已关注" forState:UIControlStateSelected];
        
        _noticeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _noticeBtn.layer.masksToBounds = YES;
        _noticeBtn.layer.cornerRadius = 2;
        _noticeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _noticeBtn.layer.borderWidth = 0.5;
        [_noticeBtn addTarget:self action:@selector(onNoticeAction:) forControlEvents:UIControlEventTouchUpInside];
        _noticeBtn;
    })];
}

- (void)layoutWithModel:(id)model{
    
    if (!CHECK_VALID_MODEL(model, [QSDemoSmallStyleCellModel class])) {
        return;
    }
    
    self.cellModel = (QSDemoSmallStyleCellModel *)model;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [[UIImage imageNamed:self.cellModel.iconName] scaleImageWithSize:_iconView.frame.size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            _iconView.image = image;
        });
    });

    [_titleLabel setText:self.cellModel.title];
    
    CGSize textSize = [self.cellModel.title textSizeWithFont:_titleLabel.font];
    _titleLabel.frame = CGRectMake(CGRectGetMaxY(_iconView.frame)  + 10, CGRectGetMinY(_iconView.frame), textSize.width, textSize.height);
   
    [_subTitleLabel setText:self.cellModel.subTitle];
    textSize = [self.cellModel.subTitle textSizeWithFont:_subTitleLabel.font];
    _subTitleLabel.frame = CGRectMake(CGRectGetMaxY(_iconView.frame) + 10,CGRectGetMaxY(_titleLabel.frame) + 5, textSize.width, textSize.height);
    
    _noticeBtn.enabled = self.cellModel.isNotice ? NO : YES;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    
    return kQSDemoSmallStyleCellHeight;
}

#pragma mark - action
- (void)onNoticeAction:(UIButton *)sender{
    
    if (self.cellModel.noticeActBlock) {
        self.cellModel.noticeActBlock(self.cellModel.userInfo);
        self.noticeBtn.selected = !self.noticeBtn.selected;
        self.cellModel.isNotice = !self.cellModel.isNotice;
    }
    
    if (self.cellModel.isNotice) {
        [self sendMessage:@"已经关注了" messageId:nil receiverKey:self.cellModel.componentViewId];
    }else{
        [self sendMessage:@"尚未关注" messageId:nil receiverKey:self.cellModel.componentViewId];
    }
}

@end
