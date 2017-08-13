//
//  MBProgressHUD+Load.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "MBProgressHUD+Load.h"

@implementation MBProgressHUD (Load)

+ (MBProgressHUD *)showHUDWithContent:(NSString *)content toView:(UIView *)view{
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.label.text = content;
    [view addSubview:hud];
    [hud showAnimated:NO];
    return hud;
}

+ (BOOL)hideHUDInView:(UIView *)view{
    
   return [MBProgressHUD hideHUDForView:view animated:NO];
}




@end
