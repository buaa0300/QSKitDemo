//
//  QSWKWebView1Controller.m
//  QSUseWebViewDemo
//
//  Created by shaoqing on 2017/8/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWKWebView1Controller.h"

static NSString * const kWKWebViewTitleKeyPath = @"title";
static NSString * const kWKWebViewEstimatedProgressKeyPath = @"estimatedProgress";
static NSString * const kWKWebViewLoadingKeyPath = @"loading";

@interface QSWKWebView1Controller ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation QSWKWebView1Controller

#pragma mark - lifecycle
- (instancetype)initWithUrlString:(NSString *)urlString{
    
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.wkWebView];
    [self p_addWKWebViewObserver];
    
    if (!_urlString || _urlString.length <= 0) {
        return;
    }
 
    [self showLoadingView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //    另一种现象是 webView.titile 会被置空, 因此，可以在 viewWillAppear 的时候检测 webView.title 是否为空来 reload 页面。
    if (self.wkWebView.title == nil) {
        [self.wkWebView reload];
    }
}

- (void)onBackAction{
    
    if([_wkWebView canGoBack]){
        [_wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//KVC监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != self.wkWebView) {
        return;
    }
    
   	if ([keyPath isEqualToString:kWKWebViewTitleKeyPath]) {
        
        self.title = self.wkWebView.title;
        
    } else if([keyPath isEqualToString:kWKWebViewEstimatedProgressKeyPath]) {
        
        double progress = self.wkWebView.estimatedProgress;
        NSLog(@"estimatedProgress = %.2lf",progress);
        
    }else if([keyPath isEqualToString:kWKWebViewLoadingKeyPath]){
        
        NSLog(@"loading:%d",self.wkWebView.loading);
    }
}

- (void)dealloc{
    
    NSLog(@"%@释放",NSStringFromClass([self class]));
    [self p_removeWKWebViewObserver];
}

- (WKWebView *)wkWebView{
    
    if (!_wkWebView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        
        WKUserContentController *contentController = [[WKUserContentController alloc]init];
//        WKUserScript *cookieScript = [[WKUserScript alloc]initWithSource:@"document.cookie = 'myCookie=this is 没my cookie!;'" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//        [contentController addUserScript:cookieScript];
        
        //注入js
        WKUserScript *showCookieScript = [[WKUserScript alloc] initWithSource:@"alert(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        [contentController addUserScript:showCookieScript];
        
        
        configuration.userContentController = contentController;
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:configuration];
        //允许右滑返回上一个链接
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        //允许链接3D Touch
        _wkWebView.allowsLinkPreview = YES;
        _wkWebView.customUserAgent = @"QSUseWebViewDemo"; //自定义UA
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        _wkWebView.layer.borderColor = [UIColor redColor].CGColor;
        _wkWebView.layer.borderWidth = 1;
    }
    return _wkWebView;
}

- (void)p_addWKWebViewObserver{
    
    [self.wkWebView addObserver:self forKeyPath:kWKWebViewTitleKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:kWKWebViewEstimatedProgressKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self forKeyPath:kWKWebViewLoadingKeyPath options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)p_removeWKWebViewObserver{
    
    [self.wkWebView removeObserver:self forKeyPath:kWKWebViewTitleKeyPath];
    [self.wkWebView removeObserver:self forKeyPath:kWKWebViewEstimatedProgressKeyPath];
    [self.wkWebView removeObserver:self forKeyPath:kWKWebViewLoadingKeyPath];
}


#pragma mark - WKNavigationDelegate 监控加载进度，服务器跳转、身份认证
//在发送请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //根据webView、navigationAction相关信息决定这次跳转是否可以继续进行,这些信息包含HTTP发送请求，如头部包含User-Agent,Accept。
    
    //    NSURL *requestURL = [navigationAction.request URL];
    //    NSString *scheme = [[requestURL scheme] lowercaseString];
    //    NSLog(@"url is : %@",[[requestURL absoluteString] lowercaseString]);
    //    if ([@[@"http",@"https",@"file"] containsObject:scheme]) {
    //        decisionHandler(WKNavigationActionPolicyAllow); //允许http/https请求,本地文件
    //    }else{
    //        decisionHandler(WKNavigationActionPolicyCancel);
    //    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"1--请求之前");
}

//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"2--页面开始加载");
    
}

//接收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"3--接收到响应后，是否跳转");
    
}


//主机地址被重定向时调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"4--主机地址被重定向");
    
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"5--页面加载失败");
    //处理，如点击重新加载
    
    
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    
    
    NSLog(@"6--内容开始返回时");
}

//页面加载完毕时调用
//加载https://baidu.com,被回调两次
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"7--页面加载完毕");
    [self hideLoadingView];
    NSString *js = @"alert('加载结束')";
    [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@"response: %@ error: %@", response, error);
    }];
    
    //    NSString *jsCode =  @"document.getElementsByClassName('dfflcwsjmki')[0].style.display = 'none'";
    //    [self.wkWebView evaluateJavaScript:jsCode completionHandler:nil];
    
}



//跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"8--跳转失败");
    
}

// 需要响应身份验证时调用，如果不要求验证，传默认就行；如果需要验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

//9.0之后才可以用，web内容处理中断时会触发
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    //解决白屏问题(此时webView.URL值尚不为nil)
    [webView reload];
    NSLog(@"9--web内容中断时会触发");
}

#pragma mark - WKUIDelegate web界面的三种提示框（警告框、确认框、输入框）的弹出事件捕捉

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%@", message);
}

// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
}

// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


@end
