//
//  QCNetwokingManager.h
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCNetworkConfig.h"
#import "QCBatchRequests.h"

NS_ASSUME_NONNULL_BEGIN

@class QCBaseRequest;

/**
 *  封装AFHTTPSessionManager.AFHTTPSessionManager是AF框架处理网络数据接口,
 *  如果后期替换网络框架或AF，可以在此部分对新框架进行封装或者对原来框架进行调整
 */
@interface QCNetwokingManager : NSObject

@property (nonatomic, strong) QCNetworkConfig *configuration;

+ (nullable QCNetwokingManager *)sharedManager;



/**
 *  核心：发送请求
 */
- (void)sendRequest:(nonnull QCBaseRequest *)request;

/**
 *  核心：取消请求
 */
- (void)cancelRequest:(nonnull QCBaseRequest*)request;

/**
 *  发送一系列API请求
 */
- (void)sendBatchRequests:(nonnull QCBatchRequests *)requests;

@end




NS_ASSUME_NONNULL_END
