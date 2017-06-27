//
//  QSLevelDB.m
//  QSUseLevelDBDemo
//
//  Created by zhongpingjiang on 2017/6/9.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "QSLevelDB.h"
#import "LevelDB.h"

#define QSLevelDBDirectory [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"QSLevelDB"]

static NSString const * DB_SUFFIX = @".ldb";
static NSTimeInterval DEFAULT_UPDATE_TIMEINTERVAL = 60 * 60 * 24 * 7;  //7 * 24hour


@interface QSLevelDB()

@property (nonatomic,strong)LevelDB *ldb;
@property (nonatomic,assign)NSTimeInterval updateInterval;

@end

@implementation QSLevelDB

- (instancetype)initWithDBName:(NSString *)dbName{

    return [[QSLevelDB alloc]initWithDBName:dbName updatePolicy:QSLevelDBUpdatePolicyLowest];
}

- (instancetype)initWithDBName:(NSString *)dbName
                  updatePolicy:(QSLevelDBUpdatePolicy)updatePolicy{

    NSTimeInterval updateInterval = [self updateIntervalForPolicy:updatePolicy];
    return [self initWithDBName:dbName updateInterval:updateInterval];
}

- (instancetype)initWithDBName:(NSString *)dbName updateInterval:(NSTimeInterval) updateInterval{
    
    self = [super init];
    if (self) {
        LevelDBOptions options = [LevelDB makeOptions];
        NSString *dbFullName = [NSString stringWithFormat:@"%@%@",dbName,DB_SUFFIX];
        NSString *dbFullPath = [QSLevelDBDirectory stringByAppendingPathComponent:dbFullName];
        
        self.ldb = [[LevelDB alloc]initWithPath:dbFullPath name:dbFullName andOptions:options];
        if (updateInterval <= 0 ) {
            updateInterval = DEFAULT_UPDATE_TIMEINTERVAL;
        }
        self.updateInterval = updateInterval;
    }
    return self;
}

- (NSTimeInterval )updateIntervalForPolicy:(QSLevelDBUpdatePolicy)updatePolicy{
    
    NSTimeInterval timeInterval = DEFAULT_UPDATE_TIMEINTERVAL;
    
    switch (updatePolicy) {
        case QSLevelDBUpdatePolicyLowest:
            timeInterval = DEFAULT_UPDATE_TIMEINTERVAL;  //7 * 24hour
            break;
            
        case QSLevelDBUpdatePolicyLow:
            timeInterval = 60 * 60 * 24;   //24hour
            break;
            
        case QSLevelDBUpdatePolicyMiddle:
            timeInterval = 60 * 60;   //1hour
            break;
            
        case QSLevelDBUpdatePolicyHight:
            timeInterval = 60;   //1min
            break;
            
            
        case QSLevelDBUpdatePolicyHightest:
            timeInterval = 10;   //10s
            break;
            
        default:
            break;
    }
    return timeInterval;

}

- (void)setObject:(id)model forKey:(NSString *)modelKey{

    
    if (!model) {
        [self removeObjectForKey:modelKey];
    }
    
    if (![model isKindOfClass:[QSBaseModel class]]) {
        NSLog(@"Sorry,%@ need inherit QSBaseModel",NSStringFromClass([model class]));
        return;
    }
    
    ((QSBaseModel *)model).updateTimeStamp = [[NSDate date]timeIntervalSince1970];
    [self.ldb setObject:model forKey:modelKey];
}

- (QSBaseModel *)objectForKey:(NSString *)modelKey{

    NSTimeInterval nowTimeInterval = [[NSDate date]timeIntervalSince1970];
    id model = [self.ldb objectForKey:modelKey];
    
    
    if (!model || ![model isKindOfClass:[QSBaseModel class]]) {
        return nil;
    }

    NSTimeInterval distanceTimeInterval = nowTimeInterval - ((QSBaseModel *)model).updateTimeStamp;
//    NSLog(@"nowTimeInterval = %.2lf, distanceTimeInterval = %.2lf , updateInterval = %.2lf",nowTimeInterval,distanceTimeInterval,self.updateInterval);
    if (distanceTimeInterval < self.updateInterval) {
        return model;
    }else{
        NSLog(@"data need update!!!");
        [self removeObjectForKey:modelKey];
        return nil;
    }
}

- (void)removeObjectForKey:(NSString *)modelKey{

    [self.ldb removeObjectForKey:modelKey];
}

- (void) removeObjectsForKeys:(NSArray *)modelKeyArray {

    [self.ldb removeObjectsForKeys:modelKeyArray];
}

- (void) removeAllObjects {
    
    [self.ldb removeAllObjects];
}

- (void)deleteDatabaseFromDisk{
    
    [self.ldb deleteDatabaseFromDisk];
}

+ (void)deleteAllDBFromDisk{

    [self deleteAllDBFromDiskWithComplete:nil];
}

+ (void)deleteAllDBFromDiskWithComplete:(void(^)())completedBlock{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *levelDBDirectory = QSLevelDBDirectory;
        //删除
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:levelDBDirectory]) {
            [fileManager removeItemAtPath:levelDBDirectory error:nil];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (completedBlock) {
                completedBlock();
            }
        });
    });
}

+ (void)deleteDatabaseFromDiskWithName:(NSString *)dbName{
    
    [self deleteDatabaseFromDiskWithName:dbName complete:nil];
}

+ (void)deleteDatabaseFromDiskWithName:(NSString *)dbName complete:(void(^)())completedBlock{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *dbFullPath = [self dbFullPathWithName:dbName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:dbFullPath]) {
            [fileManager removeItemAtPath:dbFullPath error:nil];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (completedBlock) {
                completedBlock();
            }
        });
    });
}

+ (NSString *)dbFullPathWithName:(NSString *)dbName{
    
    NSString *dbFullName = [NSString stringWithFormat:@"%@%@",dbName,DB_SUFFIX];
    NSString *dbFullPath = [QSLevelDBDirectory stringByAppendingPathComponent:dbFullName];
    return dbFullPath;
}

@end
