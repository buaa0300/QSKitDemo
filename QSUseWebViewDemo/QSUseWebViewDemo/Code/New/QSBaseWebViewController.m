//
//  QSWebView3Controller.m
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 2017/8/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseWebViewController.h"

@interface QSBaseWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation QSBaseWebViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onBackAction)];
    
//    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');"; // 根据JS字符串初始化WKUserScript对象 WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES]; // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init]; [config.userContentController addUserScript:script]; _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config]; [_webView loadHTMLString:@"<head></head><img src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />"baseURL:nil];
//    [self.view addSubview:_wkWebView];

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
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)p_addWKWebViewObserver{

    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //estimatedProgress加载进度
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView addObserver:self
                   forKeyPath:@"loading"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
}

- (void)p_removeWKWebViewObserver{

    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"loading"];

}

- (WKWebView *)wkWebView{
    
    if (!_wkWebView) {
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
        
        WKUserContentController *contentController = [[WKUserContentController alloc]init];
        WKUserScript *cookieScript = [[WKUserScript alloc]initWithSource:@"document.cookie = 'myCookie=this is 没my cookie!;'" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [contentController addUserScript:cookieScript];
        
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

//- (WKWebView *)wkWebView{
//    
//    if (!_wkWebView) {
//        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
//        _wkWebView.layer.borderColor = [UIColor redColor].CGColor;
//        _wkWebView.layer.borderWidth = 1;
//        _wkWebView.UIDelegate = self;
//        _wkWebView.navigationDelegate = self;
//    }
//    return _wkWebView;
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != self.wkWebView) {
        return;
    }
    
   	if ([keyPath isEqualToString:@"title"]) {
//        self.title = self.wkWebView.title;
        
    } else  if ([keyPath isEqualToString:@"estimatedProgress"]) {
        double progress = self.wkWebView.estimatedProgress;
        NSLog(@"estimatedProgress = %.2lf",progress);
        
    }else if([keyPath isEqualToString:@"isloading"]){
    
        NSLog(@"loading");
    }
    
    // 加载完成
    if (!self.wkWebView.loading) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
        NSString *js = @"callJsAlert()";
        [self.wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
            NSLog(@"call js alert by native");
        }];
        
        NSLog(@"加载结束");
    }
//        [UIView animateWithDuration:0.5 animations:^{
//            self.progressView.alpha = 0;
//        }];
    //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)dealloc{
    
    NSLog(@"释放");
    [self p_removeWKWebViewObserver];
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
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"7--页面加载完毕");
    [self hideLoadingView];
    NSString *jsCode =  @"document.getElementsByClassName('dfflcwsjmki')[0].style.display = 'none'";
    [self.wkWebView evaluateJavaScript:jsCode completionHandler:nil];
    
}

//跳转失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"8--跳转失败");
    
}

// 需要响应身份验证时调用。
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
//
//
//}

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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:@"JS调用alert"                 preferredStyle:UIAlertControllerStyleAlert];
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
