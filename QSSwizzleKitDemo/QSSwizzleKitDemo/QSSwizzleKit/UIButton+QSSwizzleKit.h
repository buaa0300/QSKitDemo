//
//  UIButton+QSSwizzleKit.h
//  QSSwizzleKitDemo
//
//  Created by zhongpingjiang on 2017/9/7.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 通过hook UIControl的sendAction:to:forEvent:方法防止重复点击,并不能解决 网络请求结束后才允许点击这个场景
 */
@interface UIButton (QSSwizzleKit)

@property (nonatomic, assign) NSTimeInterval qs_acceptEventInterval; // 重复点击的间隔
@property (nonatomic, assign) NSTimeInterval qs_acceptEventTime;


@end
