//
//  ViewController.m
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSTestViewController.h"

#define  SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define  SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic,strong)UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"QSUseTimerDemo";
    [self.view addSubview:({
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn setTitle:@"去看定时器页面" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn.frame = CGRectMake(0, 100, SCREEN_WIDTH/2, 30);
        _btn;
    })];
}

- (void)clickBtnAction:(UIButton *)btn{
    
    QSTestViewController *vc = [[QSTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
