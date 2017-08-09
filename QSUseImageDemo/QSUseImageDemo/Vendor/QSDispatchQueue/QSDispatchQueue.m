//
//  QSDispatchQueue.m
//
//  Created by zhongpingjiang on 2017/7/21.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDispatchQueue.h"

static const NSUInteger kDefaultConcurrentCount = 1; //默认/最小并发数
static const NSUInteger kGlobalConcurrentCount = 4; //默认全局队列线程并发数
static const NSUInteger kMaxConcurrentCount = 32;    //最大并发数

@interface QSDispatchQueue()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic,assign)NSUInteger concurrentCount;

@end


@implementation QSDispatchQueue

#pragma mark - main queue + global queue
+ (QSDispatchQueue *)mainThreadQueue {
    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
                      queue = [[QSDispatchQueue alloc] initWithQueue:dispatch_get_main_queue()];
                  });
    
    return queue;
}

+ (QSDispatchQueue *)defaultGlobalQueue{
    
    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[QSDispatchQueue alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (QSDispatchQueue *)lowGlobalQueue{
    
    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[QSDispatchQueue alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (QSDispatchQueue *)highGlobalQueue{
    
    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[QSDispatchQueue alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (QSDispatchQueue *)backGroundGlobalQueue{
    
    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[QSDispatchQueue alloc]initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
                                      concurrentCount:kGlobalConcurrentCount];
    });
    return queue;
}

+ (QSDispatchQueue *)processImageQueue{

    static QSDispatchQueue *queue;
    static dispatch_once_t onceToken;
    static dispatch_queue_t processImageQueue;
    dispatch_once(&onceToken, ^{
        
        processImageQueue = dispatch_queue_create("com.jzp.com.process.image.queue", DISPATCH_QUEUE_CONCURRENT);
        queue = [[QSDispatchQueue alloc]initWithQueue:processImageQueue
                                      concurrentCount:kGlobalConcurrentCount];
    });
    
    return queue;
}

#pragma mark - lifycycle
- (instancetype)init{

    return [self initWithQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
               concurrentCount:kDefaultConcurrentCount];
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue{

    return [self initWithQueue:queue
               concurrentCount:kDefaultConcurrentCount];
}

- (instancetype)initWithQueue:(dispatch_queue_t)queue
              concurrentCount:(NSUInteger)concurrentCount{

    self = [super init];
    if (self) {
        if (!queue) {
            queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        }else{
            _queue = queue;
        }
        
        _concurrentCount = MIN(concurrentCount, kMaxConcurrentCount);
        if (concurrentCount < kDefaultConcurrentCount) {
            concurrentCount = kDefaultConcurrentCount;
        }
        
        _concurrentCount = concurrentCount; //concurrentCount在[kDefaultConcurrentCount,kMaxConcurrentCount]之间
        if (!_semaphore) {
            _semaphore = dispatch_semaphore_create(concurrentCount);
            
        }
        if (!_serialQueue) {
            _serialQueue = dispatch_queue_create([[NSString stringWithFormat:@"com.buaa.nanhua.serial_%p", self] UTF8String], DISPATCH_QUEUE_SERIAL);
        }
    }
    return self;
}

#pragma mark -- sync && async

//同步
- (void)sync:(dispatch_block_t)block {
    
    if (!block) {
        return;
    }
    
    dispatch_sync(_serialQueue,^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);  //semaphore - 1
        dispatch_sync(self.queue,^{
            if (block) {
                block();
            }
            dispatch_semaphore_signal(self.semaphore);  //semaphore + 1
        });
    });
}

//异步
- (void)async:(dispatch_block_t)block {
    
    if (!block) {
        return;
    }

    dispatch_async(_serialQueue,^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);  //semaphore - 1
            dispatch_async(self.queue,^{
            if (block) {
                block();
            }
            dispatch_semaphore_signal(self.semaphore);  //semaphore + 1
        });
    });
}

@end
