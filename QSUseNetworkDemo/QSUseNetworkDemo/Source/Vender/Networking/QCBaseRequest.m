//
//  QCBaseRequest.m
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QCBaseRequest.h"
#import "QCNetwokingManager.h"

@interface QCBaseRequest()

/**
 重复请求Flag,用来区分相同url、相同参数和相同请求类型的请求,随机生成
 */
@property (nonatomic, assign)NSUInteger repeatRequestFlag;

@end

@implementation QCBaseRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRequestConfig];
        self.pageSize = REQUEST_PAGE_SIZE;
        self.currentPageNum = REQUEST_BEGIN_PAGE_NUM;
    }
    return self;
}

/**
 请求属性的基本设置
 */
- (void)setupRequestConfig{
    
    //默认GET请求
    self.requestMethodType = QCRequestMethodTypeGET;
    
    //请求和响应的数据格式
    self.requestSerializerType = QCRequestSerializerTypeJSON;
    self.responseSerializerType = QCResponseSerializerTypeJSON;
    
    //Content-Type定义请求信息的格式：JSON数据格式，utf8编码
    self.requestHttpHeaderField = @{@"Content-Type" : @"application/json; charset=utf-8"};
    self.responseAcceptableContentTypes = [NSSet setWithObjects:
                                           @"text/json",
                                           @"text/html",
                                           @"application/json",
                                           @"text/javascript", nil];
    //默认
    self.requestTimeoutInterval = 15.0f;
    self.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    self.repeatRequestPolicy = QCRepeatRequestPolicyDefault; //默认
    
    //默认
    self.securityPolicy = [QCSecurityPolicy policyWithPinningMode:QCSSLPinningModeNone]; //QCSSLPinningModePublicKey(防止中间人攻击)
}

- (void)setRepeatRequestPolicy:(QCRepeatRequestPolicy)repeatRequestPolicy{
    
    if (repeatRequestPolicy == QCRepeatRequestPolicyDefault) {
        _repeatRequestFlag = 0;
        
    }else if(repeatRequestPolicy == QCRepeatRequestPolicyAgressive){
        
        _repeatRequestFlag = arc4random() % 10000 + 1; //[1,10000]
    }
    _repeatRequestPolicy = repeatRequestPolicy;
}

#pragma mark - 请求进度

/**
 *  开始请求
 */
- (void)startWithSuccess:(void (^)(id responseDic))success
                 failure:(void (^)(QCNetworkingError *netError))failure{

    [self setRequestSuccess:success failure:failure];
    [self start];
}

/**
 *  设置处理数据方式，不自动发出请求，用于批量处理
 */
- (void)setRequestSuccess:(void (^)(id responseDic))success
                  failure:(void (^)(QCNetworkingError *netError))failure{
    
    self.successBlock = [success copy];
    self.failureBlock = [failure copy];
}

/**
 开启请求,调用前需要设置successBlock & failureBlock
 */
- (void)start{
    
    NSAssert(self.successBlock, @"successBlock Can not be nil");
    NSAssert(self.failureBlock, @"failureBlock Can not be nil");
    
    [[QCNetwokingManager sharedManager]sendRequest:(QCBaseRequest *)self];
}


/**
 *  请求已发送
 */
- (void)requestDidSent{
    
    NSLog(@"%@",[NSString stringWithFormat:@"request did send,request is:\n%@",self.description]);
}

/**
 请求已经返回
 */
- (void)requestDidBack{

    NSLog(@"request did back.....");
}

/**
 强迫请求失败,默认返回NO
 */
- (BOOL)makeRequestFailed{

    return NO;
}

/**
 *  取消请求
 */
- (void)cancel {
    
    [[QCNetwokingManager sharedManager]cancelRequest:(QCBaseRequest *)self];
}

#pragma mark - 重写hash、isEqual和description等方法
- (NSUInteger)hash {
    
    //根据请求类型、请求参数和请求url计算hash串
    NSDictionary *requestParametersDic = self.requestParameters;
    NSString *requestParametersString = nil;
    if (CHECK_VALID_DICTIONARY(requestParametersDic)) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParametersDic options:NSJSONWritingPrettyPrinted error:nil];
        requestParametersString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    if (!CHECK_VALID_STRING(requestParametersString)) {
        requestParametersString = @"";
    }
    
    NSMutableString *hashStr = [NSMutableString stringWithFormat:@"%d_%@_%@",
                               (int)self.requestSerializerType, requestParametersString,self.requestWholeUrl];
    
    
    //重复请求策略
    if (self.repeatRequestPolicy == QCRepeatRequestPolicyAgressive) {
    
        [hashStr appendFormat:@"_%d",(int)self.repeatRequestFlag];
    }
//    NSLog(@"request hasStr = %@",hashStr);
    
    if (CHECK_VALID_STRING(hashStr)) {
        return [hashStr hash];
    }else{
        return [super hash];
    }
}

- (BOOL)isEqual:(id)object {
    
    if (self == object) //内存地址相同，即同一个对象
        return YES;
    
    if (![object isKindOfClass:[QCBaseRequest class]])
        return NO;
    
    return [self hash] == [(QCBaseRequest *)object hash];
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"请求url:%@\n请求参数:%@\t请求类型:%d\trepeatRequestFlag:%d",self.requestWholeUrl,self.requestParameters,(int)self.requestMethodType,(int)self.repeatRequestFlag];
}

@end
