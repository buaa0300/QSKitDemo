//
//  QSPage1ViewController.m
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/31.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSPage1ViewController.h"

static NSInteger i = 0;

@interface QSPage1ViewController ()

@property (nonatomic,strong)NSTimer *timer;

@end

@implementation QSPage1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"hello";
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    
    
    
}

- (void)onTimer{
    
    NSLog(@"output = %ld",(long)i++);
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
