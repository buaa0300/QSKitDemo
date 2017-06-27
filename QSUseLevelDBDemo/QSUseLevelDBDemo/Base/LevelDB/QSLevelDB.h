//
//  QSLevelDB.h
//  QSUseLevelDBDemo
//
//  Created by zhongpingjiang on 2017/6/9.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSBaseModel.h"

/**
 存储的更新策略
 */
typedef NS_ENUM(NSInteger,QSLevelDBUpdatePolicy){

    QSLevelDBUpdatePolicyLowest, //最低 7 * 24hour后更新
    QSLevelDBUpdatePolicyLow ,   //低 24hour后更新
    QSLevelDBUpdatePolicyMiddle, //中 1hour后更新
    QSLevelDBUpdatePolicyHight,  //高  1min后更新
    QSLevelDBUpdatePolicyHightest,  //最高  10s后更新
};

@interface QSLevelDB : NSObject

#pragma mark - 初始化
- (instancetype)initWithDBName:(NSString *)dbName;

- (instancetype)initWithDBName:(NSString *)dbName
                  updatePolicy:(QSLevelDBUpdatePolicy)updatePolicy;

- (instancetype)initWithDBName:(NSString *)dbName
                updateInterval:(NSTimeInterval) updateInterval;

#pragma mark - 存 和 取model
- (void)setObject:(id)model forKey:(NSString *)modelKey;

- (QSBaseModel *)objectForKey:(NSString *)modelKey;

#pragma mark - 删除Object & db
- (void)removeObjectForKey:(NSString *)modelKey;

- (void)removeObjectsForKeys:(NSArray *)modelKeyArray;

- (void)removeAllObjects;

- (void)deleteDatabaseFromDisk;

#pragma mark - 静态方法 用于删除指定数据库 和 所有数据库
+ (void)deleteAllDBFromDisk;

+ (void)deleteAllDBFromDiskWithComplete:(void(^)())completedBlock;

+ (void)deleteDatabaseFromDiskWithName:(NSString *)dbName;

+ (void)deleteDatabaseFromDiskWithName:(NSString *)dbName complete:(void(^)())completedBlock;

@end
