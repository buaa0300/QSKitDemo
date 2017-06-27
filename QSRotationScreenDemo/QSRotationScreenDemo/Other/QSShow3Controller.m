//
//  QSShow3Controller.m
//  QSRotationScreenDemo
//
//  Created by zhongpingjiang on 2017/6/15.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSShow3Controller.h"

@interface QSShow3Controller ()

@end

@implementation QSShow3Controller

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationLandscapeRight;
}

@end
