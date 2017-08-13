//
//  QCBaseRequest+Create.h
//  QSUseNetworkDemo
//
//  Created by zhongpingjiang on 17/4/5.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QCBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^QCRequestCompleteBlock)(BOOL isSuccess,_Nullable id responseObj,NSString *errorDesc);

typedef void (^QCPageRequestCompleteBlock)(BOOL isSuccess,BOOL hasMoreData,BOOL isReset,_Nullable id dataArray, NSString *errorDesc);

@interface QCBaseRequest (Create)

#pragma mark - 普通请求处理 (两步)

+ (QCBaseRequest *)normalRequestWithUrl:(NSString *)urlString
                              parameters:(nullable NSDictionary *)parameters
                       requestMethodType:(QCRequestMethodType)requestMethodType;

+ (QCBaseRequest *)normalRequestWithUrl:(NSString *)urlString
                              parameters:(nullable NSDictionary *)parameters
                       requestMethodType:(QCRequestMethodType)requestMethodType
                     repeatRequestPolicy:(QCRepeatRequestPolicy)repeatRequestPolicy;

/**
 适用于简单的请求(支持大部分业务)：1、不支持分页，2、允许选择重复请求策略
 */
- (void)startWithCompleteBlock:(QCRequestCompleteBlock)completeBlock;


#pragma mark - 分页请求处理（两步）

/**
 1、初始化Request
 */
+ (QCBaseRequest *)pagingRequestWithMethodType:(QCRequestMethodType)requestMethodType
                                    parameters:(nullable NSDictionary *)parameters;


/**
 2、请求处理
 */
- (void)startPagingRequestUrl:(NSString *)urlString
                completeBlock:(QCPageRequestCompleteBlock)completeBlock;


NS_ASSUME_NONNULL_END

@end
