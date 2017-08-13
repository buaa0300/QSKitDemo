//
//  QCBatchRequest.h
//  QQAuto
//
//  Created by shaoqing on 16/7/11.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QCBatchRequests;
@class QCBaseRequest;

/**
 *  批量请求
 */
@interface QCBatchRequests : NSObject

@property (nonatomic, strong, readonly,nullable) NSMutableSet *requestsSet;

///**
// *  执行完成之后调用的delegate
// *
@property (nonatomic, copy, nullable) void(^completionBlock)(_Nullable id result);

/**
 *  将Request 加入到BatchRequests Set 集合中
 */
- (void)addRequest:(nonnull QCBaseRequest *)api;

/**
 *  将带有Request集合的Sets 赋值
 *
 */
- (void)addRequests:(nonnull NSSet *)requests;

/**
 *  开启API 请求
 */
- (void)startWithCompletion:(void(^)(id result))completion;

@end
