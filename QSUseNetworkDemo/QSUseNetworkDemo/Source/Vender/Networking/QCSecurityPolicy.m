//
//  QCSecurityPolicy.m
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QCSecurityPolicy.h"


@interface QCSecurityPolicy()

@property (readwrite, nonatomic, assign) QCSSLPinningMode SSLPinningMode;

@end

@implementation QCSecurityPolicy

+ (instancetype)policyWithPinningMode:(QCSSLPinningMode)pinningMode {
    QCSecurityPolicy *securityPolicy = [[QCSecurityPolicy alloc] init];
    if (securityPolicy) {
        securityPolicy.SSLPinningMode           = pinningMode;
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName      = YES;
    }
    return securityPolicy;
}

@end
