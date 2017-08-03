//
//  QSBaseController.m
//  QSRotationScreenDemo
//
//  Created by zhongpingjiang on 16/9/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QSBaseController.h"

@interface QSBaseController (){

   
}

@property (nonatomic,strong)UIActivityIndicatorView *loadingView;

@end

@implementation QSBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - page loading
- (UIActivityIndicatorView *)loadingView{

    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.frame = CGRectMake((SCREEN_WIDTH - 50)/2, (SCREEN_HEIGHT - 64  - 50)/2, 50, 50);
    }
    return _loadingView;
}

- (void)showLoadingView{

    if (self.loadingView.superview == nil) {
        [self.view addSubview:self.loadingView];
    }
    [self.loadingView startAnimating];
}

- (void)hideLoadingView{

    [self.loadingView stopAnimating];
    if (self.loadingView.superview != nil) {
        [self.loadingView removeFromSuperview];

    }
}

#pragma mark - 控制屏幕旋转方法
//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    
    return NO;
}

//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}






@end
