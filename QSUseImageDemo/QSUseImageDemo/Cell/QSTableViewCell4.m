//
//  QSTableViewCell4.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell4.h"
#import "QSImageProcess.h"
#import "UIImageView+QSImageProcess.h"

@interface QSTableViewCell4()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *pImageView;
@end

@implementation QSTableViewCell4

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
    [self.contentView addSubview: self.pImageView];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 200, 80)];
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor = [UIColor redColor];
    self.label.text = @"圆角透明，像素混合，折中方案";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth = 1;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
    [self.contentView addSubview:self.label];
    
}

- (void)layoutSubviewsWithUrl:(NSURL *)url{

    QSImageProcessConfig *config = [QSImageProcessConfig circleConfigWithOutputSize:self.pImageView.frame.size];
    UIImage *placeholderImage = [[QSImageProcess sharedImageProcess]processImage:[UIImage imageNamed:@"icon_lena@3x.png"] config:config];
    [self.pImageView qs_setImageWithURL:url placeholderImage:placeholderImage config:config];
}

+ (CGFloat)cellHeight{
    
    return 80 + 15 * 2;
}


@end

