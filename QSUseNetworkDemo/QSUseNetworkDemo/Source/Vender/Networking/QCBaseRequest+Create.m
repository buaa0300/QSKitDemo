//
//  QCBaseRequest+Create.m
//  QSUseNetworkDemo
//
//  Created by zhongpingjiang on 17/4/5.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QCBaseRequest+Create.h"

@implementation QCBaseRequest (Create)

#pragma mark - 普通请求相关
/**
 初始化请求：1、不支持分页，2、重复请求无效
 */
+ (QCBaseRequest *)normalRequestWithUrl:(NSString *)urlString
                              parameters:(nullable NSDictionary *)parameters
                       requestMethodType:(QCRequestMethodType)requestMethodType{
    
    return [self normalRequestWithUrl:urlString parameters:parameters requestMethodType:requestMethodType repeatRequestPolicy:QCRepeatRequestPolicyDefault];
}

+ (QCBaseRequest *)normalRequestWithUrl:(NSString *)urlString
                              parameters:(nullable NSDictionary *)parameters
                       requestMethodType:(QCRequestMethodType)requestMethodType
                     repeatRequestPolicy:(QCRepeatRequestPolicy)repeatRequestPolicy{
    
    QCBaseRequest *bRequest = [self p_setupWithRequestMethodType:requestMethodType
                                                 requestWholeUrl:urlString
                                               requestParameters:parameters
                                           requestSerializerType:QCRequestSerializerTypeJSON
                                          responseSerializerType:QCResponseSerializerTypeJSON
                                             repeatRequestPolicy:repeatRequestPolicy];
    return bRequest;
}

/**
 适用于简单的请求(支持大部分业务)：1、不支持分页，2、允许选择重复请求策略
 */
- (void)startWithCompleteBlock:(QCRequestCompleteBlock)completeBlock{
    
    [self startWithSuccess:^(id  _Nonnull responseDic) {
        
        if (completeBlock) {
            completeBlock(YES,responseDic,@"");
        }
        
    } failure:^(QCNetworkingError * _Nonnull netError) {
        
        if (completeBlock) {
            completeBlock(NO,nil,netError.desc);
        }
    }];
}

#pragma mark - 分页请求相关
+ (QCBaseRequest *)pagingRequestWithMethodType:(QCRequestMethodType)requestMethodType
                                    parameters:(nullable NSDictionary *)parameters{
    
    QCBaseRequest *bRequest = [self p_setupWithRequestMethodType:requestMethodType
                                                 requestWholeUrl:@""
                                               requestParameters:parameters
                                           requestSerializerType:QCRequestSerializerTypeJSON
                                          responseSerializerType:QCResponseSerializerTypeJSON
                                             repeatRequestPolicy:QCRepeatRequestPolicyDefault];
    return bRequest;
}

- (void)startPagingRequestUrl:(NSString *)urlString
                completeBlock:(QCPageRequestCompleteBlock)completeBlock{
    
    NSString *wholeUrlString = [NSString stringWithFormat:@"%@&page=%d&pagesize=%d",urlString,(int)self.currentPageNum,(int)self.pageSize];
    
    //更新url
    self.requestWholeUrl = wholeUrlString;
    @weakify(self);
    [self startWithSuccess:^(id  _Nonnull responseDic) {
        @strongify(self);
        NSArray *dataArray = [responseDic objectForKey:@"data"];
        self.hasMoreData = ([dataArray count] < self.pageSize)? NO : YES;
        
        if (completeBlock) {
            completeBlock(YES,self.hasMoreData,self.currentPageNum == REQUEST_BEGIN_PAGE_NUM,dataArray,NULL_STRING);
        }
        //更新请求page号
        self.currentPageNum = self.hasMoreData ? (self.currentPageNum + 1) : self.currentPageNum;
        
    } failure:^(QCNetworkingError * _Nonnull netError) {
        
        if (completeBlock) {
            completeBlock(NO,self.hasMoreData,self.currentPageNum == REQUEST_BEGIN_PAGE_NUM,nil,netError.desc);
        }
    }];
}

#pragma mark - private method
+ (QCBaseRequest *)p_setupWithRequestMethodType:(QCRequestMethodType)requestMethodType
                              requestWholeUrl:(NSString *)requestWholeUrl
                            requestParameters:(NSDictionary *)requestParameters
                        requestSerializerType:(QCRequestSerializerType)requestSerializerType
                       responseSerializerType:(QCResponseSerializerType)responseSerializerType
                          repeatRequestPolicy:(QCRepeatRequestPolicy)repeatRequestPolicy{
    
    QCBaseRequest *request  = [[QCBaseRequest alloc]init];
    
    request.requestWholeUrl = requestWholeUrl;
    request.requestParameters = requestParameters;
    request.requestSerializerType = requestSerializerType;
    request.responseSerializerType = responseSerializerType;
    request.repeatRequestPolicy = repeatRequestPolicy;
    request.requestWholeUrl = requestWholeUrl;
    return request;
}


@end
