//
//  AppDelegate.m
//  QSUseGCDDemo
//
//  Created by zhongpingjiang on 2017/6/28.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "AppDelegate.h"
#import "YYDispatchQueuePool.h"
#import "QSAsyncTaskQueue.h"
#import "QSDispatchQueue.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第2次操作，线程：%@", [NSThread currentThread]);
    }];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    
    
    
    
//    dispatch_queue_t workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);

    
    
    
    //方式一
//    QSDispatchQueue *queue = [[QSDispatchQueue alloc]initWithQueue:workConcurrentQueue concurrentCount:3];
//    for (NSInteger i = 0; i < 10; i++) {
//        [queue async:^{
//            NSLog(@"thread-info:%@开始执行任务%d",[NSThread currentThread],(int)i);
//            sleep(1);
//            NSLog(@"thread-info:%@结束执行任务%d",[NSThread currentThread],(int)i);
//        }];
//    }
//    
//    
//    NSLog(@"主线程...,");
    //方式2
//    dispatch_queue_t workConcurrentQueue = dispatch_queue_create("cccccccc", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t serialQueue = dispatch_queue_create("sssssssss",DISPATCH_QUEUE_SERIAL);
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
//    
//    for (NSInteger i = 0; i < 10; i++) {
//        dispatch_async(serialQueue, ^{
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            dispatch_async(workConcurrentQueue, ^{
//                NSLog(@"thread-info:%@开始执行任务%d",[NSThread currentThread],(int)i);
//                sleep(1);
//                NSLog(@"thread-info:%@结束执行任务%d",[NSThread currentThread],(int)i);
//                dispatch_semaphore_signal(semaphore);});
//        });
//    }
    
    
    
    
    
    
    
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    for (NSInteger i = 0; i < 10; i++) {
//        
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_group_async(group, queue, ^{
//            NSLog(@"thread-name:%@执行任务%d",[NSThread currentThread],(int)i);
//            sleep(1);
//            dispatch_semaphore_signal(semaphore);
//        });
//    }
//    
//    dispatch_group_notify(group, queue, ^{
//       
//        NSLog(@"任务全部执行结束");
//    });
//
//    NSLog(@"主线程...,消耗时间:%.2lfms",[[NSDate date]timeIntervalSinceDate:date] * 1000);
    
    
//   dispatch_queue_t serialQueue = dispatch_queue_create("ssssssssss",DISPATCH_QUEUE_SERIAL);
//   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//   dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
//
//    for (NSInteger i = 0; i < 10; i++) {
//        dispatch_async(serialQueue, ^{
//            NSLog(@"serialQueue-thread-name:%@",[NSThread currentThread]);
//            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//            dispatch_async(queue, ^{
//                NSLog(@"thread-name:%@执行任务%d",[NSThread currentThread],(int)i);
//                sleep(1);
//                dispatch_semaphore_signal(semaphore);
//            });
//        });
//    }

    

    
    
    
    
    
    
    
//    /* 任务1 */
//    dispatch_async(queue, ^{
//        /* 耗时任务1 */
//        NSLog(@"任务1开始");
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"任务1结束");
//        /* 任务1结束，发送信号告诉任务2可以开始了 */
//        dispatch_semaphore_signal(semaphore);
//    });
//    
//    /* 任务2 */
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        /* 等待任务1结束获得信号量, 无限等待 */
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        /* 如果获得信号量则开始任务2 */
//        NSLog(@"任务2开始");
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"任务2结束");
//    });
//    [NSThread sleepForTimeInterval:10];
    
    
    
    
    
//    QSAsyncTask *task1 = [[QSAsyncTask alloc]initWithName:@"network" block:^{
//    
//        sleep(0.3);
//        NSLog(@"do network");
//    }];
//    
//    QSAsyncTask *task2 = [[QSAsyncTask alloc]initWithName:@"writing" block:^{
//        
//        sleep(0.3);
//        NSLog(@"do writing");
//    }];
//    
//    QSAsyncTask *task3 = [[QSAsyncTask alloc]initWithName:@"reading" block:^{
//        
//        sleep(0.3);
//        NSLog(@"do reading");
//    }];
//    
//    QSAsyncTaskQueue *queue = [[QSAsyncTaskQueue alloc]init];
//    [queue setCompleteBlock:^{
//    
//        NSLog(@"全部执行完毕!");
//        
//    }];
//    
//    [queue addAsyncTask:task1];
//    [queue addAsyncTask:task2];
//    [queue addAsyncTask:task3];
//    [queue start];
//    
//    NSLog(@"主线程...!");
    

    
    
    
    
    
    
    
    
//    
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//
//    dispatch_async(queue, ^{
//        
//        NSLog(@"thread-name = %@",[NSThread currentThread]);
//        sleep(0.3);
//        
//        NSLog(@"读取缓存数据");
//        
//        dispatch_async(queue, ^{
//           
//             NSLog(@"thread-name = %@",[NSThread currentThread]);
//            sleep(0.4);
//            NSLog(@"网络请求");
//            
//        });
//        
//        
//    });

    
    
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
