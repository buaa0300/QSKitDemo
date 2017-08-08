//
//  QSProcessImageConfig.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSProcessImageConfig.h"

@implementation QSProcessImageConfig

- (NSString *)description{
    
    return [NSString stringWithFormat:@"%@-%.0lf",NSStringFromCGSize(self.outputSize), round(self.cornerRadius)];
}

@end
