//
//  QSRetainCycleLoggerPlugin.h
//  QSFindRetainCycleDemo
//
//  Created by zhongpingjiang on 2017/7/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Example of FBMemoryProfiler plugin that will NSLog all retain cycles found
 within FBMemoryProfiler. This could, for instance, send it somewhere to the backend.
 */

@interface QSRetainCycleLoggerPlugin : NSObject <FBMemoryProfilerPluggable>

@end
