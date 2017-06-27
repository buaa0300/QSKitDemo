//
//  QSThreadSafeCounter.h
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSThreadSafeCounter : NSObject

@property (atomic, readonly) int32_t value;

- (int32_t)value;

- (int32_t)increase;



@end
