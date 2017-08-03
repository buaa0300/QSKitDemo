//
//  ViewController.m
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSPage1ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"QSFindRetainCycleDemo";
    
    [self.view addSubview:({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 150, 300, 40);
        [btn setTitle:@"点击" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(onTap) forControlEvents:UIControlEventTouchUpInside];
        btn;
    })];
}

- (void)onTap{

    QSPage1ViewController *pageVC = [QSPage1ViewController new];
    [self.navigationController pushViewController:pageVC animated:YES];
}
                           
                           
                           


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
