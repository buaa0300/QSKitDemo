//
//  QSAccountManager.m
//  QSUseGCDDemo
//
//  Created by zhongpingjiang on 2017/6/28.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSAccountManager.h"

@implementation QSAccountManager

static QSAccountManager *_shareManager = nil;

+ (instancetype)shareManager{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _shareManager = [[self alloc] init];
    });
    return _shareManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareManager = [super allocWithZone:zone];
    });
    
    return _shareManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone{
    
    return _shareManager;
}

@end
