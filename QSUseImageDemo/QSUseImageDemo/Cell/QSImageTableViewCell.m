//
//  QSImageTableViewCell.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSImageTableViewCell.h"
#import "QSProcessImageManager.h"
#import "UIImageView+SDWebImageExtension.h"
#import "UIColor+RGB.h"

@interface QSImageTableViewCell()

@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *pImageView;
@property (nonatomic,strong)QSProcessImageConfig *normalConfig;
@property (nonatomic,strong)QSProcessImageConfig *selectedConfig;
@property (nonatomic,strong)NSURL *url;
@property(nonatomic, strong) UIImageView *maskContentView;
@end

@implementation QSImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.selectedBackgroundView.backgroundColor = [UIColor redColor];
        _selectedConfig = [[QSProcessImageConfig alloc]initWithOutputSize:CGSizeMake(80, 80)
                                                                               bgColor:[UIColor grayColor]
                                                                          cornerRadius:30
                                                                               corners:UIRectCornerAllCorners
                                                                                opaque:YES
                                                                          processBlock:__QSDefaultProcessImageBlock];
        
        _normalConfig = [QSProcessImageConfig configWithOutputSize:CGSizeMake(80, 80) cornerRadius:30 corners:UIRectCornerAllCorners];
        [self setupSubViews];
    }
    return self;
}

- (UIImageView *)maskContentView {
    
    if (!_maskContentView) {
        _maskContentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        _maskContentView.backgroundColor = [UIColor redColor];
//        [UIColor colorWithRGB:0xe3e3e3 alpha:0.8];
//        _maskContentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _maskContentView;
}


- (void)setupSubViews{
    
    self.pImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
    self.pImageView.backgroundColor = [UIColor whiteColor];
    self.pImageView.layer.borderColor = [UIColor blueColor].CGColor;
    self.pImageView.layer.borderWidth = 1;
    [self.contentView addSubview: self.pImageView];
    
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 80, 30)];

    self.label.backgroundColor = [UIColor whiteColor];
    self.label.textColor = [UIColor redColor];
    self.label.text = @"测试";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.layer.borderWidth = 1;
    [self.contentView addSubview:self.label];
    
//    self.contentView.maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];

}

- (void)layoutSubviewsWithUrl:(NSURL *)url{
    
    self.url = url;
//    UIImage *placeholderImage = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
//                                                             config:[QSProcessImageConfig defaultConfigWithOutputSize:CGSizeMake(80, 80)]];
    
    UIImage *placeholderImage = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                             config:_normalConfig ];
    
    self.pImageView.image = placeholderImage;
//    [self.pImageView qs_setImageWithURL:url placeholderImage:placeholderImage config:self.normalConfig];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan");
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesEnded");
    [super touchesEnded:touches withEvent:event];
}


+ (CGFloat)cellHeight{

    return 80 + 15 * 2;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
//        [self.contentView addSubview:self.maskContentView];
//         self.maskContentView.alpha = 1.0f;
//         self.maskContentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
        
        self.contentView.backgroundColor = [UIColor grayColor];
        self.pImageView.image = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                             config:_selectedConfig];
        
    } else {
        // 增加延迟消失动画效果，提升用户体验
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.maskContentView.backgroundColor = [UIColor whiteColor];
//            self.maskContentView.alpha = 0.0f;
            
            self.contentView.backgroundColor = [UIColor whiteColor];
            
            
            
        } completion:^(BOOL finished) {
//            [self.maskContentView removeFromSuperview];
            self.pImageView.image = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                                 config:_normalConfig];
        }];
    }
}

// 配置cell选中状态
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    if (selected) {
//        self.contentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
//        self.pImageView.image = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
//                                                             config:_selectedConfig];
////        self.maskContentView.alpha = 1.0f;
////        self.maskContentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
//    } else {
//        
//        self.contentView.backgroundColor = [UIColor colorWithRGB:0xe3e3e3 alpha:0.4];
//        self.pImageView.image = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
//                                                             config:_normalConfig];
////        self.maskContentView.alpha = 0.0f;
////        self.maskContentView.backgroundColor = [UIColor whiteColor];
//    }
//}

@end
