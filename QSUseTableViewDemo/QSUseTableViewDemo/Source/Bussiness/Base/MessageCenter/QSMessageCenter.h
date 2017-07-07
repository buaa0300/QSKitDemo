//
//  QSMessageCenter.h
//  QSUseMessageCenterDemo
//
//  Created by zhongpingjiang on 17/4/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QSMessageCenterDelegate <NSObject>

@optional

/**
 接收到message对象
 */
- (void)qsReceiveMessage:(id)message messageId:(NSString *)msgId;

@end

@interface QSMessageCenter : NSObject

/**
 添加消息接收者
 @param msgReceiver 消息接收对象
 @param receiverKey 消息接收对象key
 */
+ (void)addMessageReceiver:(id<QSMessageCenterDelegate>)msgReceiver receiverKey:(NSString *)receiverKey;


/**
 发送消息
 @param msg 消息对象
 @param msgId 消息id
 @param receiverKey 消息接收对象key
 */
+ (void)sendMessage:(id)msg messageId:(NSString *)msgId receiverKey:(NSString *)receiverKey;


/**
 删除消息接收者
 @param receiverKey 消息接收者名
 */
+ (void)removeMessageReceiverWithKey:(NSString *)receiverKey;

@end
