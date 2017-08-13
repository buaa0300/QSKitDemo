//
//  QSWebViewController.m
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebViewController.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "QSJSObjectModel.h"


@interface QSWebViewController ()<TSWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation QSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"JavaScriptCore高级使用";
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.layer.borderColor =  [UIColor redColor].CGColor;
    self.webView.layer.borderWidth = 1;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:[[NSBundle mainBundle] bundlePath]]];
}

//JSContext创建的时候回调,获取JSContext对象
- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx{

    QSJSObjectModel *model = [[QSJSObjectModel alloc]init];
    model.webView = self.webView;
    ctx[@"qs"] = model; //对象注入context中
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
