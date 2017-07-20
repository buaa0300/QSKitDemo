//
//  QSAsyncTask.h
//  QSUseGCDDemo
//
//  Created by shaoqing on 2017/7/20.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QSAsyncTaskStatus){

    QSAsyncTaskStatusReady = 0,
    QSAsyncTaskStatusExecuting = 1,
    QSAsyncTaskStatusCanceled = 2,
    QSAsyncTaskStatusFinished = 3
};

@interface QSAsyncTask : NSObject

@property (nonatomic,copy)NSString *taskName;
@property (nonatomic,assign)QSAsyncTaskStatus taskStatus;
@property (nonatomic,strong)dispatch_block_t taskBlock;

- (instancetype)initWithName:(NSString *)taskName block:(dispatch_block_t)taskBlock;

- (BOOL)isEnd;

- (void)start;

- (void)cancel;

@end
