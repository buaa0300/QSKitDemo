//
//  QSBaseModel.h
//  QSUseModelDemo
//
//  Created by zhongpingjiang on 2017/5/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QSBaseModel : NSObject<NSCoding,NSCopying>

@property (nonatomic,assign)NSInteger updateTimeStamp; //更新model的时间戳

+ (instancetype)modelFromJSON:(id)json;

- (NSString *)modelToJSONString;

@end
