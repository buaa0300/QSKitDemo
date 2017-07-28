//
//  QSCacheCleanerPlugin.m
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSCacheCleanerPlugin.h"

@implementation QSCacheCleanerPlugin

- (void)memoryProfilerDidMarkNewGeneration {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
