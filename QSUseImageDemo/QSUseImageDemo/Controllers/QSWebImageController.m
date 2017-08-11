//
//  QSWebImageController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebImageController.h"
#import "UIImageView+WebCache.h"
#import "QSImageProcess.h"
#import "UIImageView+QSImageProcess.h"

@interface QSWebImageController ()

@property (nonatomic,strong)UIImageView *sdImageView;
@property (nonatomic,strong)UIImageView *qsImageView;
@property (nonatomic,strong)NSMutableArray *processImageViews;

@end

@implementation QSWebImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.title = @"网络图片的处理";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.processImageViews = [NSMutableArray array];
    
    NSInteger imageCount = 3;
    CGFloat margin = 30;
    CGFloat cornerRadius = 30;
    
    CGFloat width = ceilf((SCREEN_WIDTH - margin * (imageCount + 1))/imageCount);
    
    QSImageProcessConfig *config = [[QSImageProcessConfig alloc]initWithOutputSize:CGSizeMake(width, width)];
    config.option = QSImageProcessOptionCircle;
    UIImage *placeholderImage = [[QSImageProcess sharedImageProcess]processImage:[UIImage imageNamed:@"icon_lena@3x.png"] config:config];
    
    [self.view addSubview:({
        _sdImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - width * 2 + 20)/2, 0, width, width)];
        _sdImageView;
    })];
    
    [_sdImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:placeholderImage];
    
    [self.view addSubview:({
        _qsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sdImageView.frame) + 20, 0, width, width)];
        _qsImageView;
    })];
    
    [_qsImageView qs_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:placeholderImage];
    
    NSArray *configs = [self p_processConfigArrayWithOutputSize:CGSizeMake(width, width) cornerRadius:cornerRadius];
    for (NSInteger i = 0; i < 12; i++) {
        
        CGFloat offsetX = margin + (width + margin) * (i%3);
        CGFloat offsetY = CGRectGetMaxY(_sdImageView.frame) + 15 + ((width + 15) * (i/3));
        
        UIImageView *pImageView = [[UIImageView alloc]initWithFrame:CGRectMake(offsetX, offsetY, width, width)];
        [self.view addSubview:pImageView];
        [pImageView qs_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"]
                      placeholderImage:placeholderImage
                                config:configs[i]];
    }
}

- (NSArray *)p_processConfigArrayWithOutputSize:(CGSize)outputSize cornerRadius:(CGFloat)cornerRadius{
    
    QSImageProcessConfig *config1 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerTopLeft];
    QSImageProcessConfig *config2 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerBottomLeft];
    QSImageProcessConfig *config3 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerTopRight];
    QSImageProcessConfig *config4 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerBottomRight];
    QSImageProcessConfig *config5 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerTopLeft | UIRectCornerBottomLeft];
    QSImageProcessConfig *config6 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerTopRight | UIRectCornerBottomRight];
    QSImageProcessConfig *config7 = [QSImageProcessConfig configWithOutputSize:outputSize cornerRadius:cornerRadius corners:UIRectCornerAllCorners];
    QSImageProcessConfig *config8 = [QSImageProcessConfig circleConfigWithOutputSize:outputSize clipBgColor:[UIColor whiteColor]];  //不透明圆形图片
    QSImageProcessConfig *config9 = [QSImageProcessConfig circleConfigWithOutputSize:outputSize];  //透明圆形图片
 
    QSImageProcessConfig *config10 = [QSImageProcessConfig defaultConfigWithOutputSize:outputSize clipBgColor:[UIColor whiteColor]];
    config10.option = QSImageProcessOptionRound;

    QSImageProcessConfig *config11 = [QSImageProcessConfig defaultConfigWithOutputSize:outputSize clipBgColor:[UIColor whiteColor]];
    config11.option = QSImageProcessOptionAddGradationMask;
    
    QSImageProcessConfig *config12 = [QSImageProcessConfig defaultConfigWithOutputSize:outputSize clipBgColor:[UIColor whiteColor]];
    config12.option = QSImageProcessOptionAddWholeMask;
    
    return @[config1,config2,config3,config4,config5,config6,config7,config8,config9,config10,config11,config12];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"释放");
    
}

@end
