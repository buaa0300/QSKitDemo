//
//  QSAsyncTask.m
//  QSUseGCDDemo
//
//  Created by shaoqing on 2017/7/20.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSAsyncTask.h"

@interface QSAsyncTask()


@end

@implementation QSAsyncTask

- (instancetype)initWithName:(NSString *)taskName
                       block:(dispatch_block_t)taskBlock{

    self = [super init];
    if (self) {
        _taskName = taskName;
        _taskBlock = taskBlock;
        _taskStatus = QSAsyncTaskStatusReady;
    }
    return self;
}

- (BOOL)isEqual:(id)object{

    if ([self class] != [object class]) {
        return NO;
    }
    
    QSAsyncTask *asyncTask = (QSAsyncTask *)object;
    if ([self.taskName isEqual:asyncTask.taskName]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEnd{

    return (self.taskStatus == QSAsyncTaskStatusCanceled) || (self.taskStatus == QSAsyncTaskStatusFinished);
}

/**
 开始
 */
- (void)start{
    
    _taskStatus = QSAsyncTaskStatusExecuting;
    if (self.taskBlock) {
        self.taskBlock();
    }
}

/**
 取消
 */
- (void)cancel{
    
    _taskStatus = QSAsyncTaskStatusCanceled;
}

- (NSString *)description{
    
    return [NSString stringWithFormat:@"taskName:%@,taskStatus:%d",self.taskName,(int)self.taskStatus];
}

@end
