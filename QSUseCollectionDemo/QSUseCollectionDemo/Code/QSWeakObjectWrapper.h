//
//  QSWeakObjectWrapper.h
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSWeakObjectWrapper : NSObject

@property (nonatomic, weak, readonly) id weakObject;

- (id)initWithWeakObject:(id)weakObject;

@end
