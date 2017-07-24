//
//  UIView+SnapShot.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/17.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIView+SnapShot.h"

@implementation UIView (SnapShot)

/**
 获得View的截图
 */
- (UIImage *)snapShotImage{

    UIImage *image = nil;
    if (self && self.frame.size.height && self.frame.size.width) {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

@end
