//
//  QSCornerImageController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSCornerImageController.h"
#import "QSProcessImageManager.h"
#import "UIImageView+SDWebImageExtension.h"
#import "UIImageView+WebCache.h"


@interface QSCornerImageController ()

@property (nonatomic,strong)UIImageView *sdImageView;
@property (nonatomic,strong)NSMutableArray *processImageViews;

@end

@implementation QSCornerImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.title = @"网络图片圆角的处理";
    
    self.processImageViews = [NSMutableArray array];
    
    NSInteger imageCount = 3;
    CGFloat margin = 10;
    CGFloat cornerRadius = 30;
    
    CGFloat width = ceilf((SCREEN_WIDTH - margin * (imageCount + 1))/imageCount);
    
    
    UIImage *placeholderImage = [QSProcessImageManager processImage:[UIImage imageNamed:@"icon_lena@3x.png"]
                                                             config:[QSProcessImageConfig defaultConfigWithOutputSize:CGSizeMake(width, width)]];
    [self.view addSubview:({
        _sdImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 0, width, width)];
        _sdImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _sdImageView.layer.borderWidth = 1.0f;
        _sdImageView;
    })];
    
    [_sdImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:placeholderImage];
    
    NSArray *configs = [self p_processConfigArrayWithOutputSize:CGSizeMake(width, width) cornerRadius:cornerRadius];

    for (NSInteger i = 0; i < 9; i++) {
        
        CGFloat offsetX = margin + (width + margin) * (i%3);
        CGFloat offsetY = CGRectGetMaxY(_sdImageView.frame) + 15 + ((width + 15) * (i/3));
        
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectMake(offsetX, offsetY, width, width)];
        pImageView.layer.borderColor = [UIColor blueColor].CGColor;
        pImageView.layer.borderWidth = 1.0f;
        [self.view addSubview:pImageView];
        [pImageView qs_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:placeholderImage config:configs[i]];
    }
}

- (NSArray *)p_processConfigArrayWithOutputSize:(CGSize)outputSize cornerRadius:(CGFloat)cornerRadius{

    QSProcessImageConfig *config1 = [QSProcessImageConfig defaultConfigWithOutputSize:outputSize];  //没有任何圆角
    
    QSProcessImageConfig *config2 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerLeftTop];
    QSProcessImageConfig *config3 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerLeftBottom];
    QSProcessImageConfig *config4 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerRightTop];
    QSProcessImageConfig *config5 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerRightBottom];
    
    QSProcessImageConfig *config6 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerLeftTop | QSProcessImageCornerLeftBottom];
    QSProcessImageConfig *config7 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerRightTop | QSProcessImageCornerRightBottom];
    
    QSProcessImageConfig *config8 = [QSProcessImageConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:QSProcessImageCornerRightTop | QSProcessImageCornerAllCorners];
    QSProcessImageConfig *config9 = [QSProcessImageConfig roundCofigWithOutputSize:outputSize];
    
    return @[config1,config2,config3,config4,config5,config6,config7,config8,config9];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"释放");
    
}

@end
