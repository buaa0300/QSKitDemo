//
//  QSLogFormatter.h
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 实现DDLogFormatter接口协议，在formatLogMessage方法中规定输出格式
 */
@interface QSLogFormatter : NSObject<DDLogFormatter>

@end
