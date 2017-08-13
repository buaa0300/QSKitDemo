//
//  MBProgressHUD+Load.h
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Load)

+ (MBProgressHUD *)showHUDWithContent:(NSString *)content toView:(UIView *)view;

+ (BOOL)hideHUDInView:(UIView *)view;

@end
