//
//  QSWebViewViewController.m
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebViewViewController.h"

@interface QSWebViewViewController ()

@property (nonatomic,strong)UIWebView *webView;

@end

@implementation QSWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"网站";
    
    [self.view addSubview:({
    
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView;
    })];
    
    if (self.url) {
        [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }}

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
