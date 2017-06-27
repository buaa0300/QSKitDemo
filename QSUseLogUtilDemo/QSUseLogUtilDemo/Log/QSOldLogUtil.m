//
//  QSOldLogUtil.m
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSOldLogUtil.h"

@implementation QSOldLogUtil

+ (void)openRedirectLogToDoc{
    
    NSString *logFilePath = [self logFilePath];
    NSData *data = [NSData dataWithContentsOfFile:logFilePath];
    if ([data length] > 1000 * 1000) {
        //大小超过1MB,删除文件（iphone中文件大小进制1000，不是1024）
        [[NSFileManager defaultManager] removeItemAtPath:logFilePath error:nil];
    }
    
    //标准输出文件stdout，标准错误输出文件stderr
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stdout);
    freopen([logFilePath cStringUsingEncoding:NSUTF8StringEncoding], "a+", stderr);
    QSLOG(@"\n\n********************************\n");
}

+ (NSString *)logContent{
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:[self logFilePath] encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        return content;
    }
    return error.description;
}

#pragma mark - private methods
+ (NSString *)logFilePath{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"appName-log.log"];
    return [docDir stringByAppendingPathComponent:fileName];
}

@end
