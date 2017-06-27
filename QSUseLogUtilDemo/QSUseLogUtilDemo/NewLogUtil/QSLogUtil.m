//
//  QSLogUtil.m
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSLogUtil.h"
#import "QSLogFormatter.h"

static DDFileLogger *fileLogger = nil;

@implementation QSLogUtil

+ (void)openLog{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setupConfig];
    });
}

+ (void)setupConfig{

    //添加控制台输出Logger

    [[DDTTYLogger sharedInstance] setLogFormatter:[[QSLogFormatter alloc] init]];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:ddLogLevel]; // TTY = Xcode console
//    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs

#if DEBUG
    //初始化 fileLogger
    fileLogger = [[DDFileLogger alloc] init];
    fileLogger.logFormatter = [[QSLogFormatter alloc] init];
    fileLogger.rollingFrequency = 0;
    fileLogger.maximumFileSize = 1000 * 1000;  //限制1MB
    [DDLog addLogger:fileLogger withLevel:ddLogLevel];   //日志文件
    QSLOG(@"********************************\n");
#endif

}

+ (NSString *)logContent{
    
    NSString *filePath = [self logFilePath];
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return content;
}

+ (NSString *)logFilePath {
    
    return [[fileLogger currentLogFileInfo] filePath];
}

@end
