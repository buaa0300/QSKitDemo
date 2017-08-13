//
//  QSAlertView.h
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface QSAlertView : UIAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               successHandler:(JSValue *)successHandler
               failureHandler:(JSValue *)failureHandler
                      context:(JSContext *)context;

@end
