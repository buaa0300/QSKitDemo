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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //将网络请求整合进去
    
    
    QSAsyncTask *task1 = [[QSAsyncTask alloc]initWithName:@"network" block:^{
    
        sleep(0.3);
        NSLog(@"do network");
    }];
    
    QSAsyncTask *task2 = [[QSAsyncTask alloc]initWithName:@"writing" block:^{
        
        sleep(0.3);
        NSLog(@"do writing");
    }];
    
    QSAsyncTask *task3 = [[QSAsyncTask alloc]initWithName:@"reading" block:^{
        
        sleep(0.3);
        NSLog(@"do reading");
    }];
    
    QSAsyncTaskQueue *queue = [[QSAsyncTaskQueue alloc]init];
    [queue setCompleteBlock:^{
    
        NSLog(@"全部执行完毕!");
        
    }];
    
    [queue addAsyncTask:task1];
    [queue addAsyncTask:task2];
    [queue addAsyncTask:task3];
    [queue start];
    
    
    
    
    
    
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
