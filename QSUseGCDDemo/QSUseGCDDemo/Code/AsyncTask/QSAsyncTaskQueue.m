//
//  QSAsyncTaskQueue.m
//  QSUseGCDDemo
//
//  Created by shaoqing on 2017/7/20.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSAsyncTaskQueue.h"
#import "YYDispatchQueuePool.h"

@interface QSAsyncTaskQueue()

@property (nonatomic,strong)NSMutableArray *asyncTasks;

@end

@implementation QSAsyncTaskQueue

- (instancetype)init{

    self = [super init];
    if (self) {
        _asyncTasks = [NSMutableArray array];
    }
    return self;
}

- (void)addAsyncTask:(QSAsyncTask *)asyncTask{

    if (asyncTask && ![_asyncTasks containsObject:asyncTask]) {
        [_asyncTasks addObject:asyncTask];
    }
}

- (void)removeAsyncTask:(QSAsyncTask *)asyncTask{

    if (asyncTask) {
        [_asyncTasks removeObject:asyncTask];
    }
}

//开始执行
- (void)start{
    
    QSAsyncTask *asyncTask = [self p_queueHeadAsyncTask];
    if (asyncTask) {
        [self p_executerTask:asyncTask];
    }
}

- (void)p_executerTask:(QSAsyncTask *)asyncTask{
    
    if (!asyncTask || asyncTask.taskStatus != QSAsyncTaskStatusReady) {
        return;
    }
    
    //分配线程
    dispatch_queue_t queue = YYDispatchQueueGetForQOS(NSQualityOfServiceBackground);

    dispatch_async(queue, ^{
        NSLog(@"开始执行的任务是:%@ -- thread:%@",asyncTask.taskName,[NSThread currentThread]);
        [asyncTask start];
         
        //执行结束
        QSAsyncTask *asyncTask = [self p_queueHeadAsyncTask];
        if (asyncTask) {
            
            [self p_executerTask:asyncTask];
            
        }else{
            
            if ([self p_isAllFinishTasks]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                
                    if (self.completeBlock) {
                        self.completeBlock();
                    }
                });
                
               
            }
        }
    });
}

- (BOOL)p_isAllFinishTasks{

    __block BOOL isAllFinish = NO;
    [_asyncTasks enumerateObjectsUsingBlock:^(QSAsyncTask *asyncTask, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (asyncTask.taskName && asyncTask.taskBlock && ![asyncTask isEnd]) {
           
            isAllFinish = YES;
            *stop = YES;
        }
    }];
    
    return isAllFinish;
}


- (QSAsyncTask *)p_queueHeadAsyncTask{
    
    __block NSInteger index = -1;
    [_asyncTasks enumerateObjectsUsingBlock:^(QSAsyncTask *asyncTask, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (asyncTask.taskName && asyncTask.taskBlock && asyncTask.taskStatus == QSAsyncTaskStatusReady) {
            index = idx;
            *stop = YES;
        }
        
    }];
    
    if (index == -1) {
        return nil;
    }
    QSAsyncTask *asyncTask = [_asyncTasks objectAtIndex:index];
    return asyncTask;
}

@end
