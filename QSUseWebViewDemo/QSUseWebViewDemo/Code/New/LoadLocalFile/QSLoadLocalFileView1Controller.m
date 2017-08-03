//
//  QSLoadLocalFileView1Controller.m
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 2017/8/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSLoadLocalFileView1Controller.h"
#import "WKWebViewJavascriptBridge.h"

@interface QSLoadLocalFileView1Controller ()

@property (nonatomic,strong)WKWebViewJavascriptBridge* bridge;

@end

@implementation QSLoadLocalFileView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupJSBridge];
    //allInhtml onlyhtml
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"onlyhtml" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    
//    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:baseURL]];
    [self.wkWebView loadHTMLString:appHtml baseURL:baseURL];
}

- (void)setupJSBridge{
    
    [WKWebViewJavascriptBridge enableLogging];
    
    //页面加载
    @weakify(self);
    [self.bridge registerHandler:@"_app_setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        //js传过来的数据
        responseCallback(@"this is callback data to JS");
        @strongify(self);
        if ([data isKindOfClass:[NSString class]]) {
            self.title = (NSString *)data;
            return ;
        }
        if (data) {
            self.title = [NSString stringWithFormat:@"%@",data];
        }
    }];
}

- (WKWebViewJavascriptBridge *)bridge{
    
    if (!_bridge) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
