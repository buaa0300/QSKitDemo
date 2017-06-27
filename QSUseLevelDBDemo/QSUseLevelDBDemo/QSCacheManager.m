//
//  QSCacheManager.m
//  QSUseLevelDBDemo
//
//  Created by shaoqing on 2017/6/6.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "QSCacheManager.h"

@implementation QSCacheManager
    
+ (void)sss{

    LevelDB *ldb = [LevelDB databaseInLibraryWithName:@"test.ldb"];
    [ldb setObject:@"laval" forKey:@"string_test"];
    NSLog(@"String Value: %@", [ldb objectForKey:@"string_test"]);

}

@end
