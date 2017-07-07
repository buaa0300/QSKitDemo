//
//  QSDemoBigStyleCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDemoBigStyleCell.h"

#define kQSDemoBigStyleCellHeight              ceil((91.5 * SCREEN_SCALE))

@implementation QSDemoBigStyleCellModel

- (instancetype)initWithbgImageName:(NSString *)bgImageName
                      iconImageName:(NSString *)iconImageName
                              title:(NSString *)title
                           subTitle:(NSString *)subTitle{
    self = [super init];
    if (self) {
        self.bgImageName = QSString(bgImageName, @"");
        self.iconImageName = QSString(iconImageName, @"");
        self.title = QSString(title, @"");;
        self.subTitle = QSString(subTitle, @"");;
    }
    return self;
}

@end


@interface QSDemoBigStyleCell()

@property (nonatomic, strong) QSDemoBigStyleCellModel *cellModel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end


@implementation QSDemoBigStyleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubViews{
    
    [self.contentView addSubview:({
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kQSDemoBigStyleCellHeight)];
        _bgImageView;
    })];
    
    [self.contentView addSubview:({
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + 10, kQSDemoBigStyleCellHeight - 52, 40, 40)];
        _iconImageView.layer.cornerRadius = 20.0f;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = [UIColor yellowColor];
        _iconImageView;
    })];
    
    [self.contentView addSubview:({
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel;
    })];
    
    [self.contentView addSubview:({
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel;
    })];
}

- (void)layoutWithModel:(id)model{
    
    if (!CHECK_VALID_MODEL(model, [QSDemoBigStyleCellModel class])) {
        return;
    }
    
    self.cellModel = (QSDemoBigStyleCellModel *)model;
    
    [self registerMessageReceiverWithKey:self.cellModel.componentViewId];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //压缩背景图片 & 头像图片
        UIImage *bgImage = [[UIImage imageNamed:self.cellModel.bgImageName] scaleImageWithSize:_bgImageView.frame.size];
        UIImage *image = [[UIImage imageNamed:self.cellModel.iconImageName] scaleImageWithSize:_iconImageView.frame.size];
        dispatch_sync(dispatch_get_main_queue(), ^{
            _bgImageView.image = bgImage;
            _iconImageView.image = image;
            _iconImageView.hidden = (image != nil) ? NO : YES;
        });
    });
    
    //title的设置
    _titleLabel.text = self.cellModel.title;
    
    CGFloat titleOffsetX = CGRectGetMaxX(_iconImageView.frame) + 10;
    if (_iconImageView.hidden == YES) {
        titleOffsetX = 20;
    }
    _titleLabel.frame = CGRectMake(titleOffsetX, _iconImageView.qsTop, SCREEN_WIDTH - 100, 18);
    
    //subTitle的设置
    _subTitleLabel.text = self.cellModel.subTitle;
    _subTitleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(_titleLabel.frame), SCREEN_WIDTH - 100, 14);
}

+ (CGFloat)cellHeightWithModel:(id)model{

    NSLog(@"kQSDemoBigStyleCellHeight = %.2lf",kQSDemoBigStyleCellHeight);
    return kQSDemoBigStyleCellHeight;
}

- (void)onTapCellAction{

    if (self.cellModel.tapCellBlock) {
        self.cellModel.tapCellBlock(self.cellModel.userInfo);
    }
}

#pragma mark - QSMessageCenterDelegate
- (void)qsReceiveMessage:(id)message messageId:(NSString *)msgId{

    NSLog(@"self = %@,self.cellModel.componentViewId = %@",self,self.cellModel.componentViewId);
    self.subTitleLabel.text = [message description];
}

@end
