//
//  QSAsyncTaskQueue.h
//  QSUseGCDDemo
//
//  Created by shaoqing on 2017/7/20.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSAsyncTask.h"

@interface QSAsyncTaskQueue : NSObject

@property (nonatomic,strong)dispatch_block_t completeBlock;

- (void)addAsyncTask:(QSAsyncTask *)asyncTask;

- (void)removeAsyncTask:(QSAsyncTask *)asyncTask;

- (void)start;

@end
