//
//  NSObject+QSMessageCenter.h
//  QSUseMessageCenterDemo
//
//  Created by zhongpingjiang on 17/4/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CHECK_VALID_STRING(x)                       (x && [x isKindOfClass:[NSString class]] && [x length])

@interface NSObject (QSMessageCenter)


/**
 注册成为消息接受者

 @param receiverKey 接受者key,值为nil时，key值选用注册者对象的类名
 */
- (void)registerMessageReceiverWithKey:(NSString *)receiverKey;

/**
 发送者发送消息，并指定接收者
 @param msg 消息对象，可以是任意对象
 @param msgId 消息id
 @param receiverKey 接受者key，值为nil时,receiverKey选用发送者对象的类名
 */
- (void)sendMessage:(id)msg messageId:(NSString *)msgId receiverKey:(NSString *)receiverKey;


/**
 删除消息接收者
 */
- (void)removeMessageReceiverWithKey:(NSString *)receiverKey;

@end
