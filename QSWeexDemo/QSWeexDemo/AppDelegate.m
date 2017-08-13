//
//  AppDelegate.m
//  QSWeexDemo
//
//  Created by zhongpingjiang on 16/12/16.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WXRootViewController.h"
#import "WXAppConfiguration.h"
#import "WXSDKEngine.h"
#import "WXLog.h"
#import "QSWeexImageDownloader.h"
#import "QSWeexButton.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self configWeexEnvironment];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc]init];
    self.window.rootViewController = [[WXRootViewController alloc] initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    return YES;
}

//真正初始化Weex环境
- (void)configWeexEnvironment{
    
    //业务配置，非必需
    [WXAppConfiguration setAppGroup:@"AliApp"];
    [WXAppConfiguration setAppName:@"QSWeexDemo"]; //QSWeexDemo是我的项目名
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    //初始化SDK环境
    [WXSDKEngine initSDKEnviroment];
    
    //设置Log输出等级,DEBUG下为WXLogLevelAll，release等其他版本不输出日志
#if DEBUG
    [WXLog setLogLevel:WXLogLevelAll];
#elif
    [WXLog setLogLevel:WXLogLevelOff];
#endif
    
    //注册图片加载器
    [WXSDKEngine registerHandler:[QSWeexImageDownloader new] withProtocol:@protocol(WXImgLoaderProtocol)];
    
    //        [WXSDKEngine registerComponent:@"weex-button" withClass:[QSWeexButton class]];
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
