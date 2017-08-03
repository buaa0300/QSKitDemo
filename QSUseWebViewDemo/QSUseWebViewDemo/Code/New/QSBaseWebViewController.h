//
//  QSBaseWebViewController.h
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 2017/8/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseController.h"
#import <WebKit/WebKit.h>

@interface QSBaseWebViewController : QSBaseController

@property (nonatomic,strong,readonly) WKWebView *wkWebView;
@property (nonatomic,copy)NSString *urlString;

- (instancetype)initWithUrlString:(NSString *)urlString;

@end
