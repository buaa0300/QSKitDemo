//
//  QSPage1Controller.m
//  QSRotationScreenDemo
//
//  Created by zhongpingjiang on 2017/6/14.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSPage1Controller.h"
#import "QSShow1Controller.h"
#import "QSShow2Controller.h"
#import "QSShow3Controller.h"
#import "QSShow4Controller.h"

@interface QSPage1Controller ()

@end

@implementation QSPage1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Page 1页";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 200, 40);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"视图1" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 200, 200, 40);
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"展示(Masonry)" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btn2Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(100, 300, 300, 40);
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"强制横屏(present controller)" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(btn3Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(100, 400, 300, 40);
    btn4.backgroundColor = [UIColor redColor];
    [btn4 setTitle:@"强制横屏（push controller）" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(btn4Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];


}

- (void)btnClick:(UIButton *)button {

    QSShow1Controller *vc = [[QSShow1Controller alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)btn2Click:(UIButton *)button {
    
    QSShow2Controller *vc = [[QSShow2Controller alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btn3Click:(UIButton *)button {
    
    QSShow3Controller *vc = [[QSShow3Controller alloc]init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)btn4Click:(UIButton *)button {
    
    QSShow4Controller *vc = [[QSShow4Controller alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
