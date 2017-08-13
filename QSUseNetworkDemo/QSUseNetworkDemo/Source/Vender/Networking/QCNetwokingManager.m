  //
//  QCNetwokingManager.m
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QCNetwokingManager.h"
#import "QCBaseRequest.h"
#import "AFNetworking.h"

typedef void (^QCNetwokingSuccessBlock)(NSURLSessionDataTask * task, id responseObject);
typedef void (^QCNetwokingFailureBlock)(NSURLSessionDataTask * task, id responseObject);
typedef void (^QCNetwokingProgressBlock)(NSProgress * progress);

/**
 *   创建同步队列，用来添加网络处理
 */
static dispatch_queue_t qc_network_task_creation_queue() {
    static dispatch_queue_t qc_network_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qc_network_task_creation_queue =
        dispatch_queue_create("com.qqcar.com.networking.api.creation", DISPATCH_QUEUE_SERIAL);
    });
    return qc_network_task_creation_queue;
}

static QCNetwokingManager *sharedManager = nil;

@interface QCNetwokingManager (){

    NSString *_realBaseUrl;    //真正的baseUrl
}

@property (nonatomic, strong) NSCache *sessionManagerCache;                  //缓存sessionManager
@property (nonatomic, strong) NSCache *sessionTasksCache;                    //缓存dataTask

@end


@implementation QCNetwokingManager

+ (QCNetwokingManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (!sharedManager) {
        sharedManager                    = [super init];
        sharedManager.configuration      = [[QCNetworkConfig alloc]init];   //网络的基本配置
    }
    return sharedManager;
}


- (NSCache *)sessionManagerCache {
    if (!_sessionManagerCache) {
        _sessionManagerCache = [[NSCache alloc] init];
    }
    return _sessionManagerCache;
}

- (NSCache *)sessionTasksCache {
    if (!_sessionTasksCache) {
        _sessionTasksCache = [[NSCache alloc] init];
    }
    return _sessionTasksCache;
}


#pragma mark - Send Request
/**
 *  发送请求
 */
- (void)sendRequest:(nonnull QCBaseRequest *)request {
    
    NSParameterAssert(request);
    NSAssert(self.configuration, @"Configuration Can not be nil");
    _realBaseUrl = [self requestBaseUrlWithRequest:request];
    
    dispatch_async(qc_network_task_creation_queue(), ^{
        //获得sessionManager
        AFHTTPSessionManager *sessionManager = [self sessionManagerWithRequest:request];
        if (!sessionManager) {
            return;
        }
        [self sendSingleRequest:request sessionManager:sessionManager];
    });
}

#pragma mark - Send Batch Requests 批量发送网络请求，下一个版本更新
- (void)sendBatchRequests:(nonnull QCBatchRequests *)requests {
    
    NSParameterAssert(requests);
    
    NSAssert([[requests.requestsSet valueForKeyPath:@"hash"] count] == [requests.requestsSet count],
             @"Should not have same API");
    
    dispatch_group_t batch_api_group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [requests.requestsSet enumerateObjectsUsingBlock:^(id request, BOOL * stop) {
        dispatch_group_enter(batch_api_group);
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        _realBaseUrl = [self requestBaseUrlWithRequest:request];
        AFHTTPSessionManager *sessionManager = [strongSelf sessionManagerWithRequest:request];
        
        if (!sessionManager) {
            *stop = YES;
            dispatch_group_leave(batch_api_group);
        }
        sessionManager.completionGroup = batch_api_group;
        
        [strongSelf sendSingleRequest:request
                   withSessionManager:sessionManager
                   andCompletionGroup:batch_api_group];
    }];
    dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
        
        if (requests.completionBlock) {
            requests.completionBlock(nil);
        }
    });
}

- (void)sendSingleRequest:(QCBaseRequest *)request sessionManager:(AFHTTPSessionManager *)sessionManager {
    
    [self sendSingleRequest:request withSessionManager:sessionManager andCompletionGroup:nil];
}

/**
 *  封装AF的核心代码
 *
 */
- (void)sendSingleRequest:(QCBaseRequest *)request
         withSessionManager:(AFHTTPSessionManager *)sessionManager
         andCompletionGroup:(dispatch_group_t)completionGroup {
    
    NSParameterAssert(request);
    NSParameterAssert(sessionManager);
    
    __weak typeof(self) weakSelf = self;
    //根据request计算出来
    NSString *hashKey = [NSString stringWithFormat:@"%lu", (unsigned long)[request hash]];
    //如果是重复的请求
    if ([self.sessionTasksCache objectForKey:hashKey]) {
    
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
        return;
    }

    //检测网络是否可达
    SCNetworkReachabilityRef hostReachable = SCNetworkReachabilityCreateWithName(NULL, [sessionManager.baseURL.host UTF8String]);
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(hostReachable, &flags);
    bool isReachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    if (hostReachable) {
        CFRelease(hostReachable);
    }
   
    if (!isReachable) {
        //网络不可达的处理
        NSError *unreachError = [self createErrorWithDesc:self.configuration.networkNotReachableErrorDesc
                                               code:NSURLErrorCannotConnectToHost
                                             reason:[NSString stringWithFormat:@"%@ unreachable", sessionManager.baseURL.host]];
        [self completionHandler:request responseData:nil error:unreachError];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
        return;
    }
    
    //http响应成功的处理
    QCNetwokingSuccessBlock successBlock = ^(NSURLSessionDataTask * task, id responseObject) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.configuration.isNetworkingActivityIndicatorEnabled) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [strongSelf handleSuccWithResponse:responseObject andRequest:request];
        //移除dataTask
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    //http响应失败的处理
    QCNetwokingFailureBlock failureBlock = ^(NSURLSessionDataTask * task, NSError * error) {
        
        NSLog(@"error = %@",error);
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.configuration.isNetworkingActivityIndicatorEnabled) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [strongSelf handleFailureWithError:error andRequest:request];
        //移除dataTask
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    //http响应进度
    QCNetwokingProgressBlock progressBlock = request.progressBlock ? ^(NSProgress *progress) {
        
        if (progress.totalUnitCount <= 0) {
            return;
        }
        request.progressBlock(progress);
    } : nil;
    
    //转菊花
    if (self.configuration.isNetworkingActivityIndicatorEnabled) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    
    //创建和启动SessionDataTask实例
    NSURLSessionDataTask *dataTask = [self setAndResumeDataTaskWithSessionManager:sessionManager
                                                                    request:request
                                                               successBlock:successBlock
                                                               failureBlock:failureBlock
                                                              progressBlock:progressBlock];
    if (dataTask && CHECK_VALID_STRING(hashKey)) {
        [self.sessionTasksCache setObject:dataTask forKey:hashKey];
    }
    
    dispatch_main_sync_safe(^{
        [request requestDidSent];
    });
}

/**
 *  创建和启动SessionDataTask实例
 *
 */
- (NSURLSessionDataTask *)setAndResumeDataTaskWithSessionManager:(AFHTTPSessionManager *)sessionManager
                                                   request:(QCBaseRequest *)request
                                              successBlock:(QCNetwokingSuccessBlock)success
                                              failureBlock:(QCNetwokingFailureBlock)failure
                                             progressBlock:(QCNetwokingProgressBlock)progress{
    //创建dataTask
    NSURLSessionDataTask *dataTask;
    
    QCNetwokingSuccessBlock  successBlock = [success copy];
    QCNetwokingFailureBlock failureBlock = [failure copy];
    QCNetwokingProgressBlock progressBlock = [progress copy];
    
    NSString *requestUrlString = [request requestWholeUrl];
    NSDictionary *requestParams = [request requestParameters];
    
    if (CHECK_VALID_STRING(requestUrlString)) {
        requestUrlString = [requestUrlString stringByReplacingOccurrencesOfString:_realBaseUrl
                                                                    withString:@""];
    }
    
    switch ([request requestMethodType]) {
        case QCRequestMethodTypeGET:
        {
            dataTask =
            [sessionManager GET:requestUrlString
                     parameters:requestParams
                       progress:progressBlock
                        success:successBlock
                        failure:failureBlock];
        }
            break;
        case QCRequestMethodTypeDELETE:
        {
            dataTask =
            [sessionManager DELETE:requestUrlString parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case QCRequestMethodTypePATCH:
        {
            dataTask =
            [sessionManager PATCH:requestUrlString parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case QCRequestMethodTypePUT:
        {
            dataTask =
            [sessionManager PUT:requestUrlString parameters:requestParams success:successBlock failure:failureBlock];
        }
            break;
        case QCRequestMethodTypeHEAD:
        {
            dataTask =
            [sessionManager HEAD:requestUrlString
                      parameters:requestParams
                         success:^(NSURLSessionDataTask * _Nonnull task) {
                             if (successBlock) {
                                 successBlock(task, nil);
                             }
                         }
                         failure:failureBlock];
        }
            break;
        case QCRequestMethodTypePOST:
        {
            if (![request requestConstructingBodyBlock]) {
                dataTask =
                [sessionManager POST:requestUrlString
                          parameters:requestParams
                            progress:progressBlock
                             success:successBlock
                             failure:failureBlock];
            } else {
                void (^block)(id <AFMultipartFormData> formData)
                = ^(id <AFMultipartFormData> formData) {
                    request.requestConstructingBodyBlock((id<AFMultipartFormData>)formData);
                };
                dataTask =
                [sessionManager POST:requestUrlString
                          parameters:requestParams
           constructingBodyWithBlock:block
                            progress:progressBlock
                             success:successBlock
                             failure:failureBlock];
            }
        }
            break;
        default:
            dataTask =
            [sessionManager GET:requestUrlString
                     parameters:requestParams
                       progress:progressBlock
                        success:successBlock
                        failure:failureBlock];
            break;
    }
    return dataTask;
}

/**
 *  创建对应的网络错误
 */
- (NSError *)createErrorWithDesc:(NSString *)desc code:(NSInteger)code reason:(NSString *)reason{
    
    // NSLocalizedDescriptionKey : 失败描述 & NSLocalizedFailureReasonErrorKey : 失败原因
    if (!reason) {
        reason = @"";
    }
    
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey : desc,
                               NSLocalizedFailureReasonErrorKey : reason
                               };
    NSError *networkError = [NSError errorWithDomain:NSURLErrorDomain
                                                code:code
                                            userInfo:userInfo];
    
    return networkError;
}

/**
 *  取消请求 (取消的是尚未执行的请求)
 */
- (void)cancelRequest:(nonnull QCBaseRequest  *)request {
    
    dispatch_async(qc_network_task_creation_queue(), ^{
        
        NSString *hashKey = [NSString stringWithFormat:@"%lu", (unsigned long)[request hash]];
        NSURLSessionDataTask *dataTask = [self.sessionTasksCache objectForKey:hashKey];
        [self.sessionTasksCache removeObjectForKey:hashKey];
        if (dataTask) {
            [dataTask cancel];
        }
    });
}

#pragma mark - AFHTTPSessionManager的封装部分
/**
 *  根据Request创建sessionManager
 *
 */
- (AFHTTPSessionManager *)sessionManagerWithRequest:(QCBaseRequest *)request {

    NSParameterAssert(request);
    //1、请求序列化实例化
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    if (!requestSerializer) {
        return nil;
    }
    
    //2、响应序列化实例化
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForRequst:request];
    if (!responseSerializer) {
        return nil;
    }
    
    //3、安全策略实例化
    AFSecurityPolicy *securityPolicy = [self securityPolicyWithRequest:request];
    if (!securityPolicy) {
        return nil;
    }
    
    //4、根据请求获取baseUrl，然后根据baseUrlStr建立sessionManage并设置相关参数
//    NSString *baseUrl = [self requestBaseUrlWithRequest:request];
    
    
    
    AFHTTPSessionManager *sessionManager = [self.sessionManagerCache objectForKey:_realBaseUrl];
    if (!sessionManager) {
        //创建session
        sessionManager = [self createSessionManagerWithBaseUrl:_realBaseUrl];
        [self.sessionManagerCache setObject:sessionManager forKey:_realBaseUrl];
    }
    
    
    sessionManager.requestSerializer     = requestSerializer;
    sessionManager.responseSerializer    = responseSerializer;
    sessionManager.securityPolicy        = securityPolicy;   //安全策略
    
    return sessionManager;
}

/**
 * 根据QCBaseRequest创建AFHTTPRequestSerializer实例
 */
- (AFHTTPRequestSerializer *)requestSerializerForRequest:(QCBaseRequest *)request {
    
    NSParameterAssert(request);
    
    AFHTTPRequestSerializer *requestSerializer;
    if ([request requestSerializerType] == QCRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.cachePolicy          = request.requestCachePolicy;
    requestSerializer.timeoutInterval      = request.requestTimeoutInterval;

    if (CHECK_VALID_STRING(request.authCookie)) {
        [requestSerializer setValue:request.authCookie forHTTPHeaderField:@"Cookie"];
    }
    
    //处理请求头
    NSDictionary *headerFieldParams = request.requestHttpHeaderField;
    if (![[headerFieldParams allKeys] containsObject:@"User-Agent"] && self.configuration.userAgent) {
        [requestSerializer setValue:self.configuration.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    
    if (headerFieldParams) {
        [headerFieldParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requestSerializer;
}

/**
 *  根据QCBaseRequest创建AFHTTPResponseSerializer实例
 *
 */
- (AFHTTPResponseSerializer *)responseSerializerForRequst:(QCBaseRequest *)request {
    
    NSParameterAssert(request);
    
    AFHTTPResponseSerializer *responseSerializer;
    if ([request responseSerializerType] == QCResponseSerializerTypeHTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    //HTTP 请求的返回可接受的内容类型
    responseSerializer.acceptableContentTypes = [request responseAcceptableContentTypes];
    return responseSerializer;
}

/**
 *  根据QCBaseRequest创建AFSecurityPolicy实例
 *
 */
- (AFSecurityPolicy *)securityPolicyWithRequest:(QCBaseRequest *)request {
    
    NSUInteger pinningMode                  = request.securityPolicy.SSLPinningMode;
    AFSecurityPolicy *securityPolicy        = [AFSecurityPolicy policyWithPinningMode:pinningMode];
    securityPolicy.allowInvalidCertificates = request.securityPolicy.allowInvalidCertificates;
    securityPolicy.validatesDomainName      = request.securityPolicy.validatesDomainName;
    return securityPolicy;
}

/**
 *  实际创建SessionManager部分
 *
 */
- (AFHTTPSessionManager *)createSessionManagerWithBaseUrl:(NSString *)baseUrl {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    if (self.configuration) {
        sessionConfig.HTTPMaximumConnectionsPerHost = self.configuration.maxHttpConnectionPerHost;
    } else {
        sessionConfig.HTTPMaximumConnectionsPerHost = MAX_HTTP_CONNECTION_PER_HOST;   //共享session允许的最大的连接数
    }
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]
                                    sessionConfiguration:sessionConfig];
}

/**
 *  根据request的requestWholeUrl,baseUrl和configuration的baseUrl确定真正的baseUrl
 *  其中requestWholeUrl解析出的baseUrl优先级最高
 */
- (NSString *)requestBaseUrlWithRequest:(QCBaseRequest *)request {
    
    NSParameterAssert(request);
    
    NSString *requestUrl = [request requestWholeUrl];
    if (CHECK_VALID_STRING(requestUrl)) {
        return [self rootStringFromUrl:requestUrl];
    }
    
    NSAssert(request.baseUrl != nil || self.configuration.baseUrl != nil,
             @"api baseURL or self.configuration.baseurl can't be nil together");
    
    NSString *baseUrl = request.baseUrl ? : self.configuration.baseUrl;
    
    //防止用户将整个url地址写进 baseUrl，对baseUrl 进行一次切割
    return [self rootStringFromUrl:baseUrl];
}

- (NSString *)rootStringFromUrl:(NSString *)url{
    
    NSString *rootString = nil;
    if (!CHECK_VALID_STRING(url)) {
        return rootString;
    }
    
    NSURL *root = [NSURL URLWithString:@"/" relativeToURL:[NSURL URLWithString:url]];
    rootString = [NSString stringWithFormat:@"%@", root.absoluteString];
    
    return rootString;
}

- (id)requestParamsWithRequest:(QCBaseRequest *)request {

    NSParameterAssert(request);
    return [request requestParameters];
}

#pragma mark - 处理http响应部分
/**
 *  拦截"成功"响应数据，可以实现rpcDelegate，用以特殊处理
 *
 */
- (void)handleSuccWithResponse:(id)responseObject andRequest:(QCBaseRequest *)request {
    
    [self completionHandler:request responseData:responseObject error:nil];
}

/**
  *  拦截"失败"响应数据，可以实现rpcDelegate，用以特殊处理
  *
  */
- (void)handleFailureWithError:(NSError *)error andRequest:(QCBaseRequest *)request {
    
    // Error -999, representing API Cancelled
    if ([error.domain isEqualToString: NSURLErrorDomain] && error.code == NSURLErrorCancelled) {
        [self completionHandler:request responseData:nil error:error];
        return;
    }
    
    //构建错误NSError实例
    NSString *errorDesc = self.configuration.generalErrorDesc;
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]initWithDictionary:error.userInfo copyItems:NO];
    if (![[userInfo allKeys] containsObject:NSLocalizedFailureReasonErrorKey]) {
        [userInfo setValue: NSLocalizedString(errorDesc, nil) forKey:NSLocalizedFailureReasonErrorKey];
    }
    if (![[userInfo allKeys] containsObject:NSLocalizedRecoverySuggestionErrorKey]) {
        [userInfo setValue: NSLocalizedString(errorDesc, nil)  forKey:NSLocalizedRecoverySuggestionErrorKey];
    }
    
    if (self.configuration.isErrorCodeDisplayEnabled) {
        errorDesc = [errorDesc stringByAppendingFormat:@" code:(%ld)",(long)error.code];
    }
    
    [userInfo setValue:NSLocalizedString(errorDesc, nil) forKey:NSLocalizedDescriptionKey];   //错误描述
    NSError *newError = [NSError errorWithDomain:error.domain
                                       code:error.code
                                   userInfo:[userInfo copy]];
    
    [self completionHandler:request responseData:nil error:newError];
}

/**
 *  真正处理网络请求的地方:统一处理错误，无论是网络层的错误，还是业务数据的错误
 *
 */
- (void)completionHandler:(QCBaseRequest *)request
                 responseData:(id)responseData
                        error:(NSError *)error {
    
    QCNetworkingError *netWorkingError = nil;
    NSDictionary *responseDic = nil;
  
    //responseData是返回的数据，要么二进制，要么字典
    if ([responseData isKindOfClass:[NSData class]]) {
        responseDic = [NSJSONSerialization JSONObjectWithData: responseData
                                                      options: NSJSONReadingMutableContainers
                                                        error: nil];
    }else{
        responseDic = (NSDictionary *)responseData;
    }
    
    if (error == nil) {
        //无网络错误，校验数据
        if (!CHECK_VALID_DICTIONARY(responseDic)){
        
            NSLog(@"接口数据错误");
            netWorkingError = [QCNetworkingError noDataError];
        }
    }else{
        NSLog(@"网络层错误");
        netWorkingError = [[QCNetworkingError alloc]initWithCode:error.code desc:[error.userInfo objectForKey:NSLocalizedDescriptionKey]];
    }
    
    if (netWorkingError == nil) {
        if ([request successBlock]) {
            //主线程处理，更新UI
            dispatch_main_sync_safe(^{
                request.successBlock(responseDic);
            });
        }
    }else{
        //失败处理
        if ([request failureBlock]) {
            dispatch_main_sync_safe(^{
                request.failureBlock(netWorkingError);
            });
        }
    }
}


@end
