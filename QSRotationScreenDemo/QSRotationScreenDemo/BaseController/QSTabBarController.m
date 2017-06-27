//
//  QSTabBarController.m
//  QSViewKit
//
//  Created by zhongpingjiang on 16/6/27.
//  Copyright © 2016年 qingshao. All rights reserved.
//

#import "QSTabBarController.h"
#import "QSNavigationController.h"
#import "QSPage1Controller.h"

@interface QSTabBarController ()


@end

@implementation QSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate{
    
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
}

//Presentation推出支持的屏幕旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{

    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

+ (QSTabBarController *)tabBarController{
    
    QSPage1Controller *firstPageController = [[QSPage1Controller alloc]init];
    QSNavigationController *firstNav = [[QSNavigationController alloc]initWithRootViewController:firstPageController];
    //设置UITabBarItem的 选中和非选中图片和title
    firstNav.tabBarItem.image = nil;
    firstNav.tabBarItem.selectedImage = nil;
    firstNav.tabBarItem.title = @"Page 1";
    
    UIViewController *secondPageController = [[UIViewController alloc]init];
    QSNavigationController *secondNav = [[QSNavigationController alloc]initWithRootViewController:secondPageController];
    secondNav.tabBarItem.image = nil;
    secondNav.tabBarItem.selectedImage = nil;
    secondNav.tabBarItem.title = @"Page 2";
    
    UIViewController *thirdPageController = [[UIViewController alloc]init];
    QSNavigationController *thirdNav = [[QSNavigationController alloc]initWithRootViewController:thirdPageController];
    thirdNav.tabBarItem.image = nil;
    thirdNav.tabBarItem.selectedImage = nil;
    thirdNav.tabBarItem.title = @"Page 3";
    
    UIViewController *fourthPageController = [[UIViewController alloc]init];
    QSNavigationController *fourthNav = [[QSNavigationController alloc]initWithRootViewController:fourthPageController];
    fourthNav.tabBarItem.image = nil;
    fourthNav.tabBarItem.selectedImage = nil;
    fourthNav.tabBarItem.title = @"Page 4";
    
    QSTabBarController *tabBarController = [[QSTabBarController alloc]init];
    tabBarController.viewControllers = [NSArray arrayWithObjects:firstNav,secondNav,thirdNav,fourthNav,nil];
    tabBarController.selectedIndex = 0;
    
    return tabBarController;
}





@end
