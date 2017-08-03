//
//  QSWebView2Controller.m
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 2017/8/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebView2Controller.h"

#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface QSWebView2Controller ()<WKUIDelegate,WKNavigationDelegate>


@end

@implementation QSWebView2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlString = @"https://baidu.com";
    //@"http://www.17k.com/list/1859126.html";
//    @"https://baidu.com";
    [self showLoadingView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
