//
//  NSData+Length.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/18.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSData+Length.h"

@implementation NSData (Length)

/**
 获取大小描述
 */
- (NSString *)lengthString{
    
    NSUInteger length = [self length];
    //MAC上，文件大小采用的是1000进制换算
    CGFloat scale = 1000.0f;
    
    CGFloat fileSize = 0.0f;
    NSString *unitStr = @"";
    if(length >= pow(scale, 3)) {
        fileSize =  length * 1.0 / pow(scale, 3);
        unitStr = @"GB";
    }else if (length >= pow(scale, 2)) {
        
        fileSize = length * 1.0 / pow(scale, 2);
        unitStr = @"MB";
    }else if (length >= scale) {
        
        fileSize = length * 1.0 / scale;
        unitStr = @"KB";
    }else {
        fileSize = length * 1.0;
        unitStr = @"B";
    }
    
    NSString *fileSizeInUnitStr = [NSString stringWithFormat:@"%.2f %@",
                                   fileSize,unitStr];
    return fileSizeInUnitStr;
}

@end
