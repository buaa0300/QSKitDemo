//
//  QSDispatchQueue.h
//  QSUseGCDDemo
//
//  Created by zhongpingjiang on 2017/7/21.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QSDispatchQueue : NSObject

#pragma mark - main queue + global queue

/**
 全局并发队列的最大并发数，默认4
 */
+ (QSDispatchQueue *)mainThreadQueue;

+ (QSDispatchQueue *)defaultGlobalQueue;

+ (QSDispatchQueue *)lowGlobalQueue;

+ (QSDispatchQueue *)highGlobalQueue;

+ (QSDispatchQueue *)backGroundGlobalQueue;


#pragma mark -

@property (nonatomic,assign,readonly)NSUInteger concurrentCount;

- (instancetype)init;

/**
 默认最大并发数是1
 @param queue 创建的并发队列
 */
- (instancetype)initWithQueue:(dispatch_queue_t)queue;


/**
 @param queue 创建的并发队列
 @param concurrentCount 最大并发数，应大于1
 */
- (instancetype)initWithQueue:(dispatch_queue_t)queue
              concurrentCount:(NSUInteger)concurrentCount;

//同步
- (void)sync:(dispatch_block_t)block;


//异步
- (void)async:(dispatch_block_t)block;


@end
