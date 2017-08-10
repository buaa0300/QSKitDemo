//
//  QSTableViewCell2.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell2.h"
#import "QSProcessImageManager.h"
#import "UIImageView+SDWebImageExtension.h"
#import "UIColor+RGB.h"

@interface QSTableViewCell2()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *pImageView;
@property (nonatomic,strong)QSProcessImageConfig *normalConfig;
@property (nonatomic,strong)QSProcessImageConfig *selectedConfig;
@property (nonatomic,strong)NSURL *url;

@property (nonatomic,strong)UIImage *normalImage;
@property (nonatomic,strong)UIImage *selectImage;


@end

@implementation QSTableViewCell2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        _selectedConfig = [[QSProcessImageConfig alloc]initWithOutputSize:CGSizeMake(80, 80)
                                                                  bgColor:[UIColor colorWithRGB:0xdddddd]
                                                             cornerRadius:30
                                                                  corners:UIRectCornerAllCorners
                                                                   opaque:YES
                                                             processBlock:__QSDefaultProcessImageBlock];
        
        _normalConfig = [QSProcessImageConfig configWithOutputSize:CGSizeMake(80, 80)
                                                      cornerRadius:30
                                                           corners:UIRectCornerAllCorners];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews{
    
    self.pImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 80, 80)];
    self.pImageView.backgroundColor = [UIColor whiteColor];
//    self.pImageView.layer.borderColor = [UIColor blueColor].CGColor;
//    self.pImageView.layer.borderWidth = 1;
    [self.contentView addSubview: self.pImageView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 200, 80)];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor = [UIColor redColor];
    self.label.text = @"圆角情形下,cell的高亮重写效果1";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth = 1;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
    [self.contentView addSubview:self.label];
    
    _normalImage = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                config:_normalConfig ];
    
    _selectImage = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                config:_selectedConfig];
    
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

