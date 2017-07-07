//
//  ViewController.m
//  QSUseGCDDemo
//
//  Created by zhongpingjiang on 2017/6/28.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSAccountManager.h"

@interface ViewController (){

    dispatch_queue_t _syncQueue;
}

@property (atomic,copy)NSString *someString;

@end

@implementation ViewController

@synthesize someString = _someString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
//    QSAccountManager *account1 = [QSAccountManager shareManager];
//    QSAccountManager *account2 = [QSAccountManager new];
//    QSAccountManager *account3 = [[QSAccountManager alloc]init];
//    QSAccountManager *account4 = [account3 copy];
//    
//    NSLog(@"account1 = %@",account1);
//    NSLog(@"account2 = %@",account2);
//    NSLog(@"account3 = %@",account3);
//    NSLog(@"account4 = %@",account4);
    _syncQueue = dispatch_queue_create("com.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_queue_create("com.jzp.syncQueue",NULL);;
    
    
//    self.someString = @"哈哈";

//    NSLog(@"some = %@",self.someString);
    
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_async(mainQueue, ^{
//        NSLog(@"%@",[NSThread currentThread]);
//    });
    
    //

//    dispatch_sync(mainQueue, ^{
//        NSLog(@"错误做法:%@",[NSThread currentThread]);
//    });
    
    
//    [self useSerialQueueSync];
//    [self useConcurrentQueueSync];
//    [self useConcurrentQueueAsync];
    
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group, queue, ^{
//        // 异步任务1
//        NSLog(@"1:%@",[NSThread currentThread]);
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        // 异步任务2
//        NSLog(@"2:%@",[NSThread currentThread]);
//    });
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        NSLog(@"dispatch_group_wait 结束");
//        //任务完成后
//    });
    
    // 等待group中多个异步任务执行完毕，做一些事情，介绍两种方式
    
    // 方式1（会阻塞当前线程）
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    
    // 方式2（不会阻塞当前线程）
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        // 任务完成后，在主队列中做一些操作
//        NSLog(@"3");
//      
//    });

    
//    dispatch_group_leave(<#dispatch_group_t  _Nonnull group#>)
    
    dispatch_queue_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    


    /**
     @param 10 指定重复次数，这里指定10次
     @param gQueue 追加对象的Dispatch Queue
     @param index 带有参数的Block, index的作用是为了按执行的顺序区分各个Block
     */
    dispatch_apply(10, gQueue, ^(size_t index) {
       
        NSLog(@"%zu",index);
        
    });
    
    
    // NSEC_PER_SEC，每秒有多少纳秒。
    // USEC_PER_SEC，每秒有多少毫秒。
    // NSEC_PER_USEC，每毫秒有多少纳秒。
    // DISPATCH_TIME_NOW 从现在开始
    // DISPATCH_TIME_FOREVE 永久
    
    // time为5s
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(5.0 * NSEC_PER_SEC));
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(time, queue, ^{
        // 在queue里面延迟执行的一段代码
        // ...
        
    });
    
    
    
    
    
    
    
    

 
}


-(NSString *)someString {
    
    __block NSString *localSomeString;
    dispatch_sync (_syncQueue, ^{
        NSLog(@"getter:%@",[NSThread currentThread]);
        localSomeString = _someString;
    });
    return localSomeString;
}
- (void)setSomeString:(NSString *)someString {
   
//    __block NSString *localSomeString;
//    dispatch_sync (_syncQueue, ^{
//        NSLog(@"getter:%@",[NSThread currentThread]);
//        localSomeString = _someString;
//    });
//    return localSomeString;
    
    dispatch_barrier_sync(_syncQueue, ^{
        NSLog(@"setter:%@",[NSThread currentThread]);
        _someString = someString;
    });
}

//- (NSString *)someString {
//    
//    __block NSString *localSomeString;
//    dispatch_sync(_syncQueue, ^{
//         NSLog(@"getter:%@",[NSThread currentThread]);
//        localSomeString = _someString;
//    });
//    return localSomeString;
//}
//- (void)setSomeString:(NSString *)someString {
//    
//    dispatch_sync(_syncQueue, ^{
//         NSLog(@"setter:%@",[NSThread currentThread]);
//        _someString = someString;
//    });
//}


- (void)useSerialQueueSync{
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.serial.queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t serialQueue = dispatch_queue_create("com.serial.queue", NULL);
    //
    dispatch_sync(serialQueue, ^{
        NSLog(@"串行队列 + 同步:%@",[NSThread currentThread]);
    });
    NSLog(@"1");
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"串行队列 + 同步:%@",[NSThread currentThread]);
    });
    NSLog(@"2");
    
    dispatch_sync(serialQueue, ^{
        NSLog(@"串行队列 + 同步:%@",[NSThread currentThread]);
    });
    NSLog(@"3");
}



- (void)useSerialQueueAsync{
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.serial.queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t serialQueue = dispatch_queue_create("com.serial.queue", NULL);
    //
    dispatch_async(serialQueue, ^{
        NSLog(@"串行队列 + 异步:%@",[NSThread currentThread]);
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"串行队列 + 异步:%@",[NSThread currentThread]);
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"串行队列 + 异步:%@",[NSThread currentThread]);
    });
}





- (void)useConcurrentQueueSync{
 
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"并发队列 + 同步1：%@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"并发队列 + 同步2：%@",[NSThread currentThread]);
    });
    
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"并发队列 + 同步3：%@",[NSThread currentThread]);
    });
}

- (void)useConcurrentQueueAsync{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.concurrent.queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列 + 异步：%@",[NSThread currentThread]);
    });
    NSLog(@"1");
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列 + 异步：%@",[NSThread currentThread]);
    });
    NSLog(@"2");
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"并行队列 + 异步：%@",[NSThread currentThread]);
    });
    NSLog(@"3");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
