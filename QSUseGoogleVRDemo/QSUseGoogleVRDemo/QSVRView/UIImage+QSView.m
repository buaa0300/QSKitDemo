//
//  UIImage+QSView.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/20.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIImage+QSView.h"

@implementation UIImage (QSView)

+ (UIImage *)vrBundleImageNamed:(NSString *)imageName{

    NSString * path = [[NSBundle mainBundle] pathForResource:@"QSVRView" ofType:@"bundle"];
    path = [path stringByAppendingPathComponent:imageName];
    UIImage *image = [UIImage imageNamed:path];
    return image;
}

@end
