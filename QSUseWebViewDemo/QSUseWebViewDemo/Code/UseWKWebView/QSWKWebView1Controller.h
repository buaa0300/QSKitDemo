//
//  QSWKWebView1Controller.h
//  QSUseWebViewDemo
//
//  Created by shaoqing on 2017/8/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "QSBaseController.h"

@interface QSWKWebView1Controller : QSBaseController

@property (nonatomic,strong,readonly) WKWebView *wkWebView;
@property (nonatomic,copy)NSString *urlString;

- (instancetype)initWithUrlString:(NSString *)urlString;

@end
