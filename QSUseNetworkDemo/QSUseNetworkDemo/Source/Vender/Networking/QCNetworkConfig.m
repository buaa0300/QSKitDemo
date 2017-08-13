//
//  QCNetworkConfig.m
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QCNetworkConfig.h"
#import "QCBaseRequest.h"

static const NSInteger kDefaultmaxHttpConnectionPerHost = 2;

NSString * QCDefaultGeneralErrorDesc            = @"服务器连接错误，请稍候重试";
NSString * QCDefaultFrequentRequestErrorDesc    = @"请求过于频繁，请稍后再试";
NSString * QCDefaultNetworkNotReachableDesc     = @"网络不可用，请稍后重试";

@implementation QCNetworkConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.generalErrorDesc                   = QCDefaultGeneralErrorDesc;
        self.frequentRequestErrorDesc              = QCDefaultFrequentRequestErrorDesc;
        self.networkNotReachableErrorDesc          = QCDefaultNetworkNotReachableDesc;
        self.isNetworkingActivityIndicatorEnabled = YES;
        self.isErrorCodeDisplayEnabled            = YES;
        self.maxHttpConnectionPerHost             = kDefaultmaxHttpConnectionPerHost;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    
    QCNetworkConfig *config                  = [[QCNetworkConfig allocWithZone:zone] init];
    config.generalErrorDesc               = self.generalErrorDesc;
    config.frequentRequestErrorDesc          = self.frequentRequestErrorDesc;
    config.networkNotReachableErrorDesc      = self.networkNotReachableErrorDesc;
    config.isErrorCodeDisplayEnabled         = self.isErrorCodeDisplayEnabled;
    config.baseUrl                           = self.baseUrl;
    config.userAgent                         = self.userAgent;
    config.maxHttpConnectionPerHost          = self.maxHttpConnectionPerHost;
    return config;
}


@end
