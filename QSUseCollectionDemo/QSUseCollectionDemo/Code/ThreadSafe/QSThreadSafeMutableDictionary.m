//
//  QSThreadSafeMutableDictionary.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSThreadSafeMutableDictionary.h"

@interface QSThreadSafeMutableDictionary ()

@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableDictionary* dict;

@end

@implementation QSThreadSafeMutableDictionary

- (instancetype)initCommon{
    
    self = [super init];
    if (self) {
        NSString* uuid = [NSString stringWithFormat:@"com.buaa.jzp.dictionary_%p", self];
        _syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)init{
    
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems{
    
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    return self;
}

- (NSDictionary *)initWithContentsOfFile:(NSString *)path{
    
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [self initCommon];
    if (self) {
        _dict = [[NSMutableDictionary alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt{
    
    self = [self initCommon];
    if (self) {
        _dict = [NSMutableDictionary dictionary];
        for (NSUInteger i = 0; i < cnt; ++i) {
            _dict[keys[i]] = objects[i];
        }
        
    }
    return self;
}

- (NSUInteger)count{
    
    __block NSUInteger count;
    dispatch_sync(_syncQueue, ^{
        count = _dict.count;
    });
    return count;
}

- (id)objectForKey:(id)aKey{
    
    __block id obj;
    dispatch_sync(_syncQueue, ^{
        obj = _dict[aKey];
    });
    return obj;
}

- (NSEnumerator *)keyEnumerator{
    
    __block NSEnumerator *enu;
    dispatch_sync(_syncQueue, ^{
        enu = [_dict keyEnumerator];
    });
    return enu;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    
    aKey = [aKey copyWithZone:NULL];
    dispatch_barrier_async(_syncQueue, ^{
        _dict[aKey] = anObject;
    });
}

- (void)removeObjectForKey:(id)aKey{
    
    dispatch_barrier_async(_syncQueue, ^{
        [_dict removeObjectForKey:aKey];
    });
}

- (void)removeAllObjects{
    
    dispatch_barrier_async(_syncQueue, ^{
        [_dict removeAllObjects];
    });
}

- (id)copy{
    __block id copyInstance;
    dispatch_sync(_syncQueue, ^{
        copyInstance = [_dict copy];
    });
    return copyInstance;
}

@end
