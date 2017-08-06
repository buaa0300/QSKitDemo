//
//  QSCompareViewController.m
//  QSUseWebViewDemo
//
//  Created by shaoqing on 2017/8/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSCompareViewController.h"
#import <WebKit/WebKit.h>

@interface QSCompareViewController ()<UIWebViewDelegate,WKNavigationDelegate>

@property(nonatomic,strong)UIWebView *uiWebView;
@property(nonatomic,strong)WKWebView *wkWebView;

@property(nonatomic,assign)CFTimeInterval uiBeginTimeStamp;
@property(nonatomic,assign)CFTimeInterval wkBeginTimeStamp;

@property(nonatomic,assign)NSInteger testUrlIndex;

@property(nonatomic,assign)BOOL endLoadUIWebView;
@property(nonatomic,assign)BOOL endLoadWKWebView;

@end

@implementation QSCompareViewController

- (instancetype)init{

    self = [super init];
    if (self) {
        _testUrlIndex = 0;
        _endLoadUIWebView = NO;
        _endLoadWKWebView = NO;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"加载速度对比";
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]initWithTitle:@"开始" style:UIBarButtonItemStyleDone target:self action:@selector(onRightAction)];
    
    [self setupWebViews];
}

- (void)onRightAction{

    NSLog(@"开始吧!");
    [self compareLoadSpeed:_testUrlIndex];
}

-(void)setupWebViews{
    
    if (_uiWebView) {
        _uiWebView.delegate = nil;
        _uiWebView = nil;
    }
    
    if (_wkWebView) {
        _wkWebView.navigationDelegate = nil;
        _wkWebView = nil;
    }
    
    _uiWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, (SCREEN_HEIGHT - 20)/2)];
    _uiWebView.delegate = self;
    _uiWebView.layer.borderColor = [UIColor redColor].CGColor;
    _uiWebView.layer.borderWidth = 1;
    [self.view addSubview:_uiWebView];
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, _uiWebView.frame.origin.y +_uiWebView.frame.size.height + 5, SCREEN_WIDTH, (SCREEN_HEIGHT - 20)/2) configuration:[[WKWebViewConfiguration alloc]init]];
    _wkWebView.navigationDelegate = self;
    _wkWebView.layer.borderColor = [UIColor blueColor].CGColor;
    _wkWebView.layer.borderWidth = 1;
    [self.view addSubview:_wkWebView];
}

- (void)compareLoadSpeed:(NSInteger)index{
    
    switch (index) {
        case 0:
            NSLog(@"------ load baidu url ------");
            [self loadUrlString:@"https://www.baidu.com"];
            break;
        case 1:
            NSLog(@"------ load tencent url ------");
            [self loadUrlString:@"http://xw.qq.com/index.htm"];
            break;
        case 2:
            NSLog(@"------ load taobao url ------");
            [self loadUrlString:@"https://m.taobao.com/#index"];
            break;
    }
}

- (void)loadUrlString:(NSString *)urlString{
    
    _endLoadUIWebView = NO;
    _endLoadWKWebView = NO;
    
    NSURLRequest *req = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    _uiBeginTimeStamp = CFAbsoluteTimeGetCurrent(); //开始当前时间
    [_uiWebView loadRequest:req];
    
    _wkBeginTimeStamp = CFAbsoluteTimeGetCurrent();
    [_wkWebView loadRequest:req];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"[UIWebView] load (%@),waste time is(%@)",[webView.request.URL absoluteString],
          [NSString stringWithFormat:@"%.3fs",CFAbsoluteTimeGetCurrent() - _uiBeginTimeStamp]);
    _endLoadUIWebView = YES;
    if (_endLoadWKWebView) {
        [self compareLoadSpeed:++_testUrlIndex];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"[WKWebView] load (%@),waste time is(%@)",[webView.URL absoluteString],[NSString stringWithFormat:@"%.3fs",CFAbsoluteTimeGetCurrent() - _wkBeginTimeStamp]);
    
    _endLoadWKWebView = YES;
    if (_endLoadUIWebView) {
        [self compareLoadSpeed:++_testUrlIndex];
    }
}

@end
