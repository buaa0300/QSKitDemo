//
//  QSTableViewCell2.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell2.h"
#import "QSImageProcess.h"

@interface QSTableViewCell2()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *pImageView;
@property (nonatomic,strong)NSURL *url;

@property (nonatomic,strong)UIImage *normalImage;
@property (nonatomic,strong)UIImage *selectImage;


@end

@implementation QSTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    self.pImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 80, 80)];
    self.pImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview: self.pImageView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 200, 80)];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor = [UIColor redColor];
    self.label.text = @"圆角情形下,cell的高亮重写效果1,性能最差";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth = 1;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
    [self.contentView addSubview:self.label];
    
    QSImageProcessConfig *config1 = [QSImageProcessConfig circleConfigWithOutputSize:self.pImageView.frame.size clipBgColor:[UIColor whiteColor]];
    _normalImage = [[QSImageProcess sharedImageProcess]processImage:[UIImage imageNamed:@"icon_lena@3x.png"] config:config1];

    
    QSImageProcessConfig *config2 = [QSImageProcessConfig circleConfigWithOutputSize:self.pImageView.frame.size clipBgColor:[UIColor colorWithRGB:0xdddddd]];
    _selectImage = [[QSImageProcess sharedImageProcess] processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                config:config2];
    
}

- (void)layoutSubviewsWithUrl:(NSURL *)url{
    
//    self.url = url;
    
    self.pImageView.image = _normalImage;
}

+ (CGFloat)cellHeight{
    
    return 80 + 15 * 2;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(onUnHighted) object:nil];
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
        self.pImageView.image = _selectImage;
    } else {
        [self performSelector:@selector(onUnHighted) withObject:nil afterDelay:0.5];
    }
}

- (void)onUnHighted{

    self.pImageView.image = _normalImage;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

// 配置cell选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(onUnHighted) object:nil];
        self.contentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
        if (self.pImageView.image != _selectImage) {
            self.pImageView.image = _selectImage;
        }
    } else {

        [self performSelector:@selector(onUnHighted) withObject:nil afterDelay:0.5];
    }
}

- (void)dealloc{

    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(onUnHighted) object:nil];

}

@end

