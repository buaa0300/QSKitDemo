//
//  QSTableViewCell1.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell1.h"
#import "QSImageProcess.h"

@interface QSTableViewCell1()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *pImageView;
@property (nonatomic,strong)NSURL *url;
@end

@implementation QSTableViewCell1

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
    self.label.text = @"圆角情形下，cell的默认高亮效果，UI不合格";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth = 1;
    self.label.numberOfLines = 0;
    [self.label sizeToFit];
    [self.contentView addSubview:self.label];
    
}

- (void)layoutSubviewsWithUrl:(NSURL *)url{
    
//    self.url = url;
    
    QSImageProcessConfig *config = [QSImageProcessConfig circleConfigWithOutputSize:self.pImageView.frame.size clipBgColor:[UIColor whiteColor]];
    UIImage *placeholderImage = [[QSImageProcess sharedImageProcess]processImage:[UIImage imageNamed:@"icon_lena@3x.png"] config:config];
    self.pImageView.image = placeholderImage;
}

+ (CGFloat)cellHeight{
    
    return 80 + 15 * 2;
}


@end

