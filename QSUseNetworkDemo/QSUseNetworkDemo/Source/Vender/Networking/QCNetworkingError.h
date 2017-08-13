//
//  QCNetworkingError.h
//  QSNetworking
//
//  Created by shaoqing on 16/9/13.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QCNetWorkingErrorCode){
    
    QCNetWorkingErrorCodeNoData = 0,
    QCNetWorkingErrorCodeNoNetWork = 1,
};


/**
 *  网络错误
 */
@interface QCNetworkingError : NSObject

@property (nonatomic,assign) NSInteger code;
@property (nonatomic,copy) NSString *desc;

- (instancetype)initWithCode:(NSInteger)code desc:(NSString *)desc;


+ (QCNetworkingError *)noDataError;
+ (QCNetworkingError *)noNetWorkError;

@end
