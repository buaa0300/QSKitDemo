//
//  QSNavigationController.m
//  QSRotationScreenDemo
//
//  Created by zhongpingjiang on 16/9/28.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QSNavigationController.h"


@interface QSNavigationController ()



@end

@implementation QSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 初始化rootViewController
    if ([[self viewControllers] count] == 0){
        
        [super pushViewController:viewController animated:animated];
        return;
    }
    
    UIViewController *rootController;
    if (self.parentViewController) {
        rootController = self.parentViewController;
    }else {
        rootController = self;
    }
    
    // 从带tabbar的页面push到 不带tabbar的页面
    if ([rootController isKindOfClass:[UITabBarController class]] && [[self viewControllers] count] == 1) {
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}


#pragma mark - 控制屏幕旋转方法
//是否支持旋转
- (BOOL)shouldAutorotate{
    
    return [[self.viewControllers lastObject]shouldAutorotate];
}

//支持屏幕旋转种类
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [[self.viewControllers lastObject]supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
