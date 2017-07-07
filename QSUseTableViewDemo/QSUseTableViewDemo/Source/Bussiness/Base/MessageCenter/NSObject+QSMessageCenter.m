//
//  NSObject+QSMessageCenter.m
//  QSUseMessageCenterDemo
//
//  Created by zhongpingjiang on 17/4/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "NSObject+QSMessageCenter.h"
#import "QSMessageCenter.h"
#import <objc/runtime.h>

@interface NSObject ()<QSMessageCenterDelegate>

@property (nonatomic, weak) id<QSMessageCenterDelegate> QSMessageCenterDelegate;

@end

@implementation NSObject (QSMessageCenter)

- (void)setQSMessageCenterDelegate:(id<QSMessageCenterDelegate>)QSMessageCenterDelegate{

    objc_setAssociatedObject(self, @selector(QSMessageCenterDelegate), QSMessageCenterDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<QSMessageCenterDelegate>)QSMessageCenterDelegate{

    return objc_getAssociatedObject(self, @selector(QSMessageCenterDelegate));
}


#pragma mark - 成为 & 取消成为 消息接受者
/**
   成为消息接受者
 */
- (void)registerMessageReceiverWithKey:(NSString *)receiverKey{
    
    //将自己设置成为代理
    self.QSMessageCenterDelegate = self;
    if (!CHECK_VALID_STRING(receiverKey)) {
        receiverKey = [self getClassName];
    }
    
    [QSMessageCenter addMessageReceiver:self.QSMessageCenterDelegate
                                         receiverKey:receiverKey];
}

/**
 发送者发送消息，并指定接收者
 */
- (void)sendMessage:(id)msg messageId:(NSString *)msgId receiverKey:(NSString *)receiverKey{

    if (!CHECK_VALID_STRING(receiverKey)) {
        receiverKey = [self getClassName];
    }
    
    [QSMessageCenter sendMessage:msg messageId:msgId receiverKey:receiverKey];
}

/**
 删除消息接收者
 */
- (void)removeMessageReceiverWithKey:(NSString *)receiverKey{
    
    if (!CHECK_VALID_STRING(receiverKey)) {
        receiverKey = NSStringFromClass([self class]);
    }
    
    [QSMessageCenter removeMessageReceiverWithKey:receiverKey];
}


#pragma mark - private methods
- (NSString *)getClassName{

    return NSStringFromClass([self class]);

}

@end
