//
//  QSTool.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTool.h"

@implementation QSTool

@end


#pragma mark - 函数实现
NSString * QSString(NSString * value, NSString * defaultString){
    
    if (CHECK_VALID_STRING(value))
        return value;
    
    if (defaultString && ![defaultString isKindOfClass:[NSString class]]){
        defaultString = @"";
    }
    return defaultString;
}
