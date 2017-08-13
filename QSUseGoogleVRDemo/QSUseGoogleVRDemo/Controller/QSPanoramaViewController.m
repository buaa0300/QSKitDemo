//
//  QSPanoramaViewController.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/14.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSPanoramaViewController.h"
#import "QSPanoramaView.h"

@interface QSPanoramaViewController ()<GVRWidgetViewDelegate>{

    QSPanoramaView *_panoView;

}

@end

@implementation QSPanoramaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"全景图片+VR";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    NSString *urlString = @"https://d3fvwbt1l4ic3o.cloudfront.net/image/median/bab7026b-e692-42b6-9ffe-581a8b8ef0b7.jpg";
    
    _panoView = [[QSPanoramaView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [_panoView loadImageUrl:[NSURL URLWithString:urlString]];
    [self.view addSubview:_panoView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
}

- (void)dealloc{

    NSLog(@"全景图片+VR VC释放");

}



@end
