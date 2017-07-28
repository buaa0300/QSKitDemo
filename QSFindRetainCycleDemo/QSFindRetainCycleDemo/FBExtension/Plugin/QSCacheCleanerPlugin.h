//
//  QSCacheCleanerPlugin.h
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Example of FBMemoryProfiler plugin that will clear NSURLCache every time
 we hit mark generation.
 */
@interface QSCacheCleanerPlugin : NSObject<FBMemoryProfilerPluggable>

@end
