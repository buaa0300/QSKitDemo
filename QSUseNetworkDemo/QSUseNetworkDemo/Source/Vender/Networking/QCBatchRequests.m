//
//  QCBatchRequest.m
//  QQAuto
//
//  Created by shaoqing on 16/7/11.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "QCBatchRequests.h"
#import "QCBaseRequest.h"
#import "QCNetwokingManager.h"
#import "QCNetworkingError.h"

static  NSString * const kQCBatchRequestHintString = @"API should be kind of QCBaseRequest";

@interface QCBatchRequests()

@property (nonatomic, strong, readwrite) NSMutableSet *requestsSet;

@end


@implementation QCBatchRequests

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestsSet = [NSMutableSet set];
    }
    return self;
}

#pragma mark - Add Requests
- (void)addRequest:(QCBaseRequest *)api {
    
    NSParameterAssert(api);
    NSAssert([api isKindOfClass:[QCBaseRequest class]],
             kQCBatchRequestHintString);
    if ([self.requestsSet containsObject:api]) {
#ifdef DEBUG
        NSLog(@"Add SAME API into BatchRequest set");
#endif
    }
    
    [self.requestsSet addObject:api];
}

- (void)addRequests:(NSSet *)apis {
    
    NSParameterAssert(apis);
    NSAssert([apis count] > 0, @"Apis amounts should greater than ZERO");
    [apis enumerateObjectsUsingBlock:^(id  obj, BOOL * stop) {
        if ([obj isKindOfClass:[QCBaseRequest class]]) {
            [self.requestsSet addObject:obj];
        } else {
            __unused NSString *hintStr = [NSString stringWithFormat:@"%@ %@",
                                          [[obj class] description],
                                          kQCBatchRequestHintString];
            NSAssert(NO, hintStr);
            return ;
        }
    }];
}


- (void)startWithCompletion:(void(^)(id result))completion{
    
    self.completionBlock = [completion copy];
    NSAssert([self.requestsSet count] != 0, @"Batch API Amount can't be 0");
    [[QCNetwokingManager sharedManager] sendBatchRequests:self];
}

@end

