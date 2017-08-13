//
//  QCNetwokingDefine.h
//  NetWorking
//
//  Created by shaoqing on 16/6/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#ifndef QCNetwokingDefine_h
#define QCNetwokingDefine_h

#define REQUEST_BEGIN_PAGE_NUM  1
#define REQUEST_PAGE_SIZE   20

// 重复请求处理策略
typedef NS_ENUM(NSUInteger, QCRepeatRequestPolicy) {
    QCRepeatRequestPolicyDefault  = 0, //默认策略: 前一个请求没有结束，后一个相同请求无效
    QCRepeatRequestPolicyAgressive   = 1 //激进策略:前一个请求没有结束，后一个相同请求毫无顾忌地发出
};


// 网络请求类型
typedef NS_ENUM(NSUInteger, QCRequestMethodType) {
    QCRequestMethodTypeGET     = 0,
    QCRequestMethodTypePOST    = 1,
    QCRequestMethodTypeHEAD    = 2,
    QCRequestMethodTypePUT     = 3,
    QCRequestMethodTypePATCH   = 4,
    QCRequestMethodTypeDELETE  = 5
};

// 请求的序列化格式
typedef NS_ENUM(NSUInteger, QCRequestSerializerType) {
    QCRequestSerializerTypeHTTP    = 0,
    QCRequestSerializerTypeJSON    = 1
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, QCResponseSerializerType) {
    QCResponseSerializerTypeHTTP    = 0,
    QCResponseSerializerTypeJSON    = 1
};

/**
 *  SSL Pinning
 */
typedef NS_ENUM(NSUInteger, QCSSLPinningMode) {
    /**
     *  不校验Pinning证书
     */
    QCSSLPinningModeNone,
    /**
     *  校验Pinning证书中的PublicKey.
     */
    QCSSLPinningModePublicKey,
    /**
     *  校验整个Pinning证书
     */
    QCSSLPinningModeCertificate,
};

#endif /* QCNetwokingDefine_h */
