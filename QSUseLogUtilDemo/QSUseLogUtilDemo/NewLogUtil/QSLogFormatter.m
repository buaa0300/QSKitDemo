//
//  QSLogFormatter.m
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSLogFormatter.h"

NSString *QSLogFlagToString(DDLogFlag flag) {

    NSString *flagStr = @"";
    switch (flag) {
        case DDLogFlagVerbose:
            flagStr = @"[Verbose]";
        break;
        
        case DDLogFlagDebug:
            flagStr = @"[Debug]";
        break;
        
        case DDLogFlagInfo:
            flagStr = @"[Info]";
        break;
        
        case DDLogFlagWarning:
            flagStr = @"[Warn]";
        break;
        
        case DDLogFlagError:
            flagStr = @"[Error]";
        break;
        default:
            NSLog(@"unknown log flag");
        break;
    }
    return flagStr;
}

@interface QSLogFormatter()

@property (nonatomic,strong)NSDateFormatter *dateFormatter;

@end

@implementation QSLogFormatter

- (instancetype)init{

    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage{

    NSString *timeStr = [self.dateFormatter stringFromDate:logMessage.timestamp];
    NSString *flagStr = QSLogFlagToString(logMessage.flag);
    
    NSString *formatStr = [NSString stringWithFormat:@"%@ %@ %@ %@ line:%ld %@ %@",timeStr,flagStr,logMessage.queueLabel,logMessage.fileName,(long)logMessage.line,logMessage.function,logMessage.message];

    return formatStr;
}

@end
