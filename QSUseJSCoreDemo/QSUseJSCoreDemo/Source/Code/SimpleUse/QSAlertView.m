//
//  QSAlertView.m
//  QQSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSAlertView.h"
#import <JavaScriptCore/JSManagedValue.h>

@interface QSAlertView() <UIAlertViewDelegate>

@property (nonatomic,strong) JSContext *context;
@property (nonatomic,strong) JSManagedValue *successHandler;
@property (nonatomic,strong) JSManagedValue *failureHandler;

@end

@implementation QSAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
               successHandler:(JSValue *)successHandler
               failureHandler:(JSValue *)failureHandler
                      context:(JSContext *)context{

    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    if (self) {
        _context = context;
        _context = context;
        _successHandler = [JSManagedValue managedValueWithValue:successHandler];
        _failureHandler = [JSManagedValue managedValueWithValue:failureHandler];
        
        //添加JSManagedValue对象到JSVirtualMachine对象中，防止使用过程被释放
        [_context.virtualMachine addManagedReference:_successHandler withOwner:self];
        [_context.virtualMachine addManagedReference:_failureHandler withOwner:self];
    }
    
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([btnTitle isEqualToString:@"YES"]) {
        
        JSValue *function = [self.successHandler value];
        [function callWithArguments:@[]];
        
    }else{
        JSValue *function = [self.failureHandler value];
        [function callWithArguments:@[]];
    }
    //移除JSManagedValue对象
    [self.context.virtualMachine removeManagedReference:_successHandler withOwner:self];
    [self.context.virtualMachine removeManagedReference:_failureHandler withOwner:self];
}

@end
