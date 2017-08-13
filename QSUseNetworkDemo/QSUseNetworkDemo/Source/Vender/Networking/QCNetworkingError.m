//
//  QCNetworkingError.m
//  QSNetworking
//
//  Created by shaoqing on 16/9/13.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QCNetworkingError.h"

@implementation QCNetworkingError

- (instancetype)initWithCode:(NSInteger)code desc:(NSString *)desc{
    
    self = [super init];
    if (self) {
        _code = code;
        _desc = desc;
    }
    return self;
}

+ (QCNetworkingError *)noDataError{
    
    QCNetworkingError *error = [[QCNetworkingError alloc]initWithCode:QCNetWorkingErrorCodeNoData desc:@"暂无数据"];
    return error;
}

+ (QCNetworkingError *)noNetWorkError{
    
    QCNetworkingError *error = [[QCNetworkingError alloc]initWithCode:QCNetWorkingErrorCodeNoNetWork desc:@"网络异常"];
    return error;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"errorCode = %ld , errorDesc = %@",(long)self.code,self.desc];
}

@end
