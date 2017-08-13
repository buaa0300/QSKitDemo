//
//  QCSecurityPolicy.h
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCNetwokingDefine.h"

/**
 *  http安全部分，暂时不考虑
 */

@interface QCSecurityPolicy : NSObject

/**
 *  SSL Pinning证书的校验模式
 *  默认为 DRDSSLPinningModeNone
 */
@property (readonly, nonatomic, assign) QCSSLPinningMode SSLPinningMode;

/**
 *  是否允许使用Invalid 证书
 *  默认为 NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 *  是否校验在证书 CN 字段中的 domain name
 *  默认为 YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 *  创建新的SecurityPolicy
 *
 *  @param pinningMode 证书校验模式
 *
 *  @return 新的SecurityPolicy
 */
+ (instancetype)policyWithPinningMode:(QCSSLPinningMode)pinningMode;

@end
