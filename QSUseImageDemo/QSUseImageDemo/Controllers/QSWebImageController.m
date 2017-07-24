//
//  QSWebImageController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebImageController.h"
#import "QSProcessImageManager.h"
#import "UIImageView+SDWebImageExtension.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"


@interface QSWebImageController ()

@property (nonatomic,strong)UIImageView *originImageView;
@property (nonatomic,strong)UIImageView *scaleImageView;

@property (nonatomic,strong)UIButton *downImageBtn;

@end

@implementation QSWebImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.title = @"网络图片处理";
    
    [self.view addSubview:({
        _originImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 0, 100, 100)];
        _originImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _originImageView.layer.borderWidth = 1.0f;
        [_originImageView sd_setShowActivityIndicatorView:YES];
        _originImageView;
    })];
    

    
    [self.view addSubview:({
        _scaleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_originImageView.frame) + 15, 100, 100)];
        _scaleImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _scaleImageView.layer.borderWidth = 1.0f;
        _scaleImageView;
    })];
    
    [self.view addSubview:({
        _downImageBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_scaleImageView.frame) + 15, 100, 40)];
        [_downImageBtn setTitle:@"下载图片" forState:UIControlStateNormal];
        [_downImageBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_downImageBtn addTarget:self action:@selector(onDownLoad) forControlEvents:UIControlEventTouchUpInside];
        _scaleImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _downImageBtn.layer.borderWidth = 1.0f;
        _downImageBtn;
    })];
}
     
- (void)onDownLoad{
    
    UIImage *originImage = [UIImage imageNamed:@"icon.jpeg"];
    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]init];
    config.outputSize = CGSizeMake(100, 100);
    config.cornerRadius = 30;
    config.bgColor = [UIColor whiteColor];
    //对比
    [self.originImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:originImage];
    [self.scaleImageView qs_setImageWithURL:[NSURL URLWithString:@"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg"] placeholderImage:originImage config:config];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    NSLog(@"释放");

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
