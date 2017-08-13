//
//  QCNetworkConfig.h
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *QCDefaultGeneralErrorDesc;
FOUNDATION_EXPORT NSString *QCDefaultFrequentRequestErrorDesc;
FOUNDATION_EXPORT NSString *QCDefaultNetworkNotReachableDesc;

FOUNDATION_EXPORT NSString *QCNetworkConfigUrlStringKey;
FOUNDATION_EXPORT NSString *QCNetworkConfigPostParamDicKey;

#define MAX_HTTP_CONNECTION_PER_HOST 5

/**
 *  QCNetworkConfig配置处理
 */

@class QCBaseRequest;

@interface QCNetworkConfig : NSObject

/**
 *  网络无法连接的情况下，使用错误提示文字(默认QCDefaultGeneralErrorString)
 */
@property (nonatomic, copy) NSString *generalErrorDesc;

/**
 *  用户频繁发送同一个请求，使用的错误提示文字(默认QCDefaultFrequentRequestErrorString)
 */
@property (nonatomic, copy) NSString *frequentRequestErrorDesc;

/**
 *  网络请求开始时，会先检测相应网络域名的Reachability，如果不可达，则直接返回该错误文字(默认QCDefaultNetworkNotReachableString)
 */
@property (nonatomic, copy) NSString *networkNotReachableErrorDesc;

/**
 *  出现网络请求错误时，是否在请求错误的文字后加上(code)
 *  默认为：YES
 */
@property (nonatomic, assign) BOOL isErrorCodeDisplayEnabled;

/**
 *  修改的baseUrl，字符串
 */
@property (nonatomic, copy, nullable) NSString *baseUrl;

/**
 *  UserAgent
 */
@property (nonatomic, copy, nullable) NSString *userAgent;

/**
 *  每个Host的最大连接数
 *  默认为2
 */
@property (nonatomic, assign) NSUInteger maxHttpConnectionPerHost;

/**
 *  NetworkingActivityIndicator
 *  Default by YES
 */
@property (nonatomic, assign) BOOL isNetworkingActivityIndicatorEnabled;


@end
NS_ASSUME_NONNULL_END
