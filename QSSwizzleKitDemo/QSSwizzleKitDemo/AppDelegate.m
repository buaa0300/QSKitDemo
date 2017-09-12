//
//  AppDelegate.m
//  QSSwizzleKitDemo
//
//  Created by zhongpingjiang on 2017/9/7.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [self setupTabBarController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (UITabBarController *)setupTabBarController{
    //显示
    ViewController *vc1 = [[ViewController alloc]init];
    UINavigationController *navVc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    navVc1.tabBarItem.title = @"显示1";

    UIViewController *vc2 = [[UIViewController alloc]init];
    UINavigationController *navVc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    navVc2.tabBarItem.title = @"显示2";
    
    UIViewController *vc3 = [[UIViewController alloc]init];
    UINavigationController *navVc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    navVc3.tabBarItem.title = @"显示3";

    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[navVc1,navVc2,navVc3];
    tabBarController.selectedIndex = 0;
    return tabBarController;
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
