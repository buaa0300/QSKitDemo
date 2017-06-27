//
//  QSWeakObjectWrapper.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWeakObjectWrapper.h"

@implementation QSWeakObjectWrapper

- (id)initWithWeakObject:(id)weakObject{
    
    if (self = [super init]) {
        _weakObject = weakObject;
    }
    
    return self;
}

@end
