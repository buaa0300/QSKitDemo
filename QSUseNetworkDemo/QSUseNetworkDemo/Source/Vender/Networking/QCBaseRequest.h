//
//  QCBaseRequest.h
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QCNetwokingDefine.h"
#import "QCSecurityPolicy.h"
#import "AFURLRequestSerialization.h"
#import "QCNetworkingError.h"

@class QCBaseRequest;

NS_ASSUME_NONNULL_BEGIN

/**
 *  block类型
 */
typedef void (^QCRequestSuccess)(id responseData);
typedef void (^QCRequestFailure)(QCNetworkingError *netError);
typedef void (^QCRequestProgressBlock)(NSProgress *progress);
typedef void (^QCRequestConstructingBodyBlock)(id<AFMultipartFormData> formData);


@interface QCBaseRequest : NSObject

#pragma mark - 请求中设置的基本参数
/**
 *  baseURL : 请求url的域名等
 *  注意：如果API子类有设定baseURL, 则 Configuration 里的baseURL不起作用
 *  即： Request里的baseURL 优先级更高
 */
@property (nonatomic, copy, nullable) NSString *baseUrl;

/**
 *  完整的请求链接
 */
@property (nonatomic,copy)NSString *requestWholeUrl;


/**
 *  post请求，requestParameters放到消息主体
 *  get请求，requestParameters拼接，作为url的一部分
 *
 */
@property (nonatomic,strong)NSDictionary *requestParameters;

/**
 *  Cookie 信息
 */
@property (nonatomic,copy)NSString *authCookie;


/**
 请求的类型:GET, POST,...
 */
@property (nonatomic, assign)QCRequestMethodType requestMethodType;


/**
 Request 序列化类型：JSON, HTTP
 */
@property (nonatomic, assign)QCRequestSerializerType requestSerializerType;


/**
 Response 序列化类型： JSON, HTTP
 */
@property (nonatomic, assign)QCResponseSerializerType responseSerializerType;


/**
 *  HTTP 请求的Cache策略
 */
@property (nonatomic, assign)NSURLRequestCachePolicy requestCachePolicy;

/**
 *  HTTP 请求超时的时间
 */
@property (nonatomic, assign)NSTimeInterval requestTimeoutInterval;

/**
 *  HTTP 请求的头部区域自定义
 */
@property (nonatomic, strong)NSDictionary *requestHttpHeaderField;

/**
 *  HTTP 请求的返回可接受的内容类型
 */
@property (nonatomic, strong)NSSet *responseAcceptableContentTypes;

/**
 *  HTTPS 请求的Security策略
 */
@property (nonatomic, strong)QCSecurityPolicy *securityPolicy;


#pragma mark - 重复请求

/**
 重复请求处理策略
 */
@property (nonatomic, assign)QCRepeatRequestPolicy repeatRequestPolicy;


#pragma mark - 分页相关属性

/**
 用于分页：当前的页码
 */
@property (nonatomic, assign) NSInteger currentPageNum;


/**
 用于分页：一页的数据大小
 */
@property (nonatomic, assign) NSInteger pageSize;

/**
 用于分页：是否还有数据
 */
@property (nonatomic, assign) BOOL hasMoreData;


#pragma mark - 网络请求处理block

/**
 *  用于组织POST体的block，可以通过表单处理上传图片
 */
@property (nonatomic, copy, nullable)QCRequestConstructingBodyBlock requestConstructingBodyBlock;


/**
 *  请求成功返回block
 *
 */
@property (nonatomic, copy, nullable) QCRequestSuccess successBlock;

/**
 *  请求失败返回block
 */
@property (nonatomic, copy, nullable) QCRequestFailure failureBlock;

/**
 *  上传、下载等长时间执行的Progress进度
 */
@property (nonatomic, copy, nullable) QCRequestProgressBlock progressBlock;



#pragma mark - 请求进度
/**
 *  开始请求
 */
- (void)startWithSuccess:(void (^)(id responseDic))success
                 failure:(void (^)(QCNetworkingError *netError))failure;


/**
 *  设置处理数据方式，不自动发出请求，用于批量处理
 */
- (void)setRequestSuccess:(void (^)(id responseDic))success
                  failure:(void (^)(QCNetworkingError *netError))failure;

/**
 开启请求,调用前需要设置successBlock & failureBlock
 */
- (void)start;

/**
 *  请求已被Sent
 */
- (void)requestDidSent;

/**
 请求已经返回
 */
- (void)requestDidBack;

/**
 强迫请求失败,默认返回NO
 */
- (BOOL)makeRequestFailed;

/**
 *  取消请求
 */
- (void)cancel;


@end


NS_ASSUME_NONNULL_END
