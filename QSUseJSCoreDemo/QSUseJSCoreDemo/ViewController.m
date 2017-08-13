//
//  ViewController.m
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSSimpleViewController.h"

@interface ViewController ()

@property (nonatomic,strong)UIButton *btn1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"QSUseJSCoreDemo";
    
    [self.view addSubview:({
        _btn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 250, 60)];
        [_btn1 setTitle:@"JavaScriptCore基础使用" forState:UIControlStateNormal];
        [_btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _btn1;
    })];
}

- (void)onClickBtn:(UIButton *)btn{

    QSSimpleViewController *vc = [[QSSimpleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
