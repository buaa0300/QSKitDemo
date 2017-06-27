//
//  QSBaseModel.m
//  QSUseModelDemo
//
//  Created by zhongpingjiang on 2017/5/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseModel.h"
#import "YYModel.h"

@implementation QSBaseModel

#pragma mark - 模型转换（public）
+ (instancetype)modelFromJSON:(id)json{

    return [self yy_modelWithJSON:json];
}

- (NSString *)modelToJSONString {

    return [self yy_modelToJSONString];
}

#pragma mark - 序列化和反序列化
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [self yy_modelEncodeWithCoder:aCoder];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    return [self yy_modelInitWithCoder:aDecoder];
}

#pragma mark - 实现copy方法（实现深拷贝）
- (id)copyWithZone:(NSZone *)zone {
    
    return [self yy_modelCopy];
}

#pragma mark -重写hash、isEqual:和description方法
- (NSUInteger)hash {
    
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    
    return [self yy_modelIsEqual:object];
}

- (NSString *)description{
    
    return [self yy_modelDescription];
}

@end
