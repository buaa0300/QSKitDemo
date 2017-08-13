//
//  ViewController.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSPanoramaViewController.h"
#import "QSVideoViewController.h"

#import "QSDownloadManager.h"
#import "MBProgressHUD+Load.h"

@interface ViewController ()

@property (nonatomic,strong)UIButton *imageBtn;
@property (nonatomic,strong)UIButton *videoBtn;
@property (nonatomic,strong)UIButton *clearBtn;
@property (nonatomic,strong)UILabel *fileSizeLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"QSUseGoogleVRDemo";
    
    [self.view addSubview:({
        _imageBtn = [self p_btnWithTitle:@"全景图片+VR"];
        _imageBtn.frame = CGRectMake(15, 100, 100, 60);
        _imageBtn;
    })];
    
    [self.view addSubview:({
        _videoBtn = [self p_btnWithTitle:@"全景视频+VR"];
        _videoBtn.frame = CGRectMake(15, 200, 100, 60);
        _videoBtn;
    })];
    
    [self.view addSubview:({
        _clearBtn = [self p_btnWithTitle:@"清除所有缓存"];
        _clearBtn.frame = CGRectMake(15, 300, 100, 60);
        _clearBtn;
    })];
    
    [self.view addSubview:({
        _fileSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 400, 100, 60)];
        _fileSizeLabel.textColor = [UIColor blueColor];
        _fileSizeLabel.font = [UIFont systemFontOfSize:16];
        _fileSizeLabel;
    })];
}


- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    self.fileSizeLabel.text = [[QSDownloadManager sharedInstance]getAllCacheFileSizeString];
}

- (UIButton *)p_btnWithTitle:(NSString *)title{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightTextColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onOpenContentAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)onOpenContentAction:(UIButton *)btn{
    
    if (btn == self.imageBtn) {
        
        QSPanoramaViewController *vc = [[QSPanoramaViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(btn == self.videoBtn){
        
        QSVideoViewController *vc = [[QSVideoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if(btn == self.clearBtn){
    
        [MBProgressHUD showHUDWithContent:@"清理缓存中..." toView:self.view];
        [[QSDownloadManager sharedInstance] deleteAllFileCache];
        self.fileSizeLabel.text = [[QSDownloadManager sharedInstance]getAllCacheFileSizeString];
        [MBProgressHUD hideHUDInView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
