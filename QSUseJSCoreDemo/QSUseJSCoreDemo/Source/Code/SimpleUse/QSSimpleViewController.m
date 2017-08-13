//
//  QSSimpleViewController.m
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSSimpleViewController.h"
#import "QSExportObject.h"
#import "QSAlertView.h"

@interface QSSimpleViewController()

@property (nonatomic,strong)JSContext *context;

@end


@implementation QSSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"JavaScriptCore基础使用";
    // Do any additional setup after loading the view.

//    [self ocCallJsCode];
//    [self ocCallJsCodeInFile];
    
//    [self jsCallOc1];
//    [self jsCallOc2];

//    [self safeUseContextInBlock1];
//    [self safeUseContextInBlock2];
//
//    [self normalUseJSValue];
    [self safeUseJSValue];
}

#pragma mark - OC 调用 JS
- (void)ocCallJsCode{

    JSContext *context = [[JSContext alloc]init];
    [context evaluateScript:@"var a = 5,b = 7"];
    [context evaluateScript:@"function add(a,b){return a+b}"];
    JSValue *addValue = [context evaluateScript:@"add(5,7)"];
    NSLog(@"addValue = %d",addValue.toInt32);
}

- (void)ocCallJsCodeInFile{
    
    JSContext *context = [[JSContext alloc]init];
    NSString *jsFilePath = [[NSBundle mainBundle]pathForResource:@"occalljs" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:jsContent];
    
    JSValue *addValue = [context[@"add"] callWithArguments:@[@5,@7]];
    NSLog(@"5 + 7 = %d",addValue.toInt32);
    
    JSValue *subValue = [context[@"sub"] callWithArguments:@[@5,@7]];
    NSLog(@"5 - 7 = %d",subValue.toInt32);
    
    JSValue *mulValue = [context[@"mul"] callWithArguments:@[@5,@7]];
    NSLog(@"5 * 7 = %d",mulValue.toInt32);
    
    JSValue *divValue = [context[@"div"] callWithArguments:@[@5,@7.0]];
    NSLog(@"5 / 7 = %.2lf",divValue.toDouble);
}

#pragma mark - JS 调用 OC
- (void)jsCallOc1{

    JSContext *context = [[JSContext alloc]init];
    NSString *jsFilePath = [[NSBundle mainBundle]pathForResource:@"jscalloc1" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:jsContent];
    
    //block替换js中的print方法
    context[@"print"] = ^(NSString *printStr){
    
        NSLog(@"printStr = %@",printStr);
    };
    
    __weak typeof(self) weakSelf = self;
    //block替换js中的alert方法
    context[@"alert"] = ^(NSString *alertStr){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:alertStr preferredStyle:UIAlertControllerStyleAlert];
        [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
        [strongSelf presentViewController:vc animated:YES completion:nil];
    };
    
    //执行
    [context[@"sayHello"] callWithArguments:nil];
    [context[@"showAlert"] callWithArguments:nil];
}

- (void)jsCallOc2{
    
    JSContext *context = [[JSContext alloc]init];
    NSString *jsFilePath = [[NSBundle mainBundle]pathForResource:@"jscalloc2" ofType:@"js"];
    NSString *jsContent = [NSString stringWithContentsOfFile:jsFilePath encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:jsContent];
    
    QSExportObject *qsObj = [QSExportObject new];
    qsObj.vc = self;
    context[@"qsobj"] = qsObj;
    
    //执行
    [context[@"sayHello"] callWithArguments:nil];
    [context[@"showAlert"] callWithArguments:nil];
}

#pragma mark - 内存管理
- (JSContext *)context{

    if (!_context) {
        _context = [[JSContext alloc]init];
    }
    return _context;
}

- (void)safeUseContextInBlock1{

    [self.context evaluateScript:@"function printAppVersion() { print(getAppVersion())}"];
    self.context[@"print"] = ^(NSString *printStr){

        NSLog(@"printStr = %@",printStr);
    };
    
    self.context[@"getAppVersion"] = ^{
        
        NSString* versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        versionString = [@"App Version " stringByAppendingString:versionString];
        JSContext *context = [JSContext currentContext]; // 这里不要直接使用self.context,否则发生循环引用
        JSValue *version = [JSValue valueWithObject:versionString inContext:context];
        return version;
    };

    [self.context[@"printAppVersion"] callWithArguments:nil];
}

- (void)safeUseContextInBlock2{
    
    [self.context evaluateScript:@"function printAppVersion() { print(getAppVersion())}"];
    self.context[@"print"] = ^(NSString *printStr){
        
        NSLog(@"printStr = %@",printStr);
    };
    
    __weak typeof(self) weakSelf = self;
    self.context[@"getAppVersion"] = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString* versionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        versionString = [@"App Version " stringByAppendingString:versionString];
        JSContext *context = strongSelf.context; // 这里不要直接使用self.context,否则发生循环引用
        JSValue *version = [JSValue valueWithObject:versionString inContext:context];
        return version;
    };
    
    [self.context[@"printAppVersion"] callWithArguments:nil];
}

- (void)normalUseJSValue{
    
    [self.context evaluateScript:@"function log() { }"];
    JSValue *value = [JSValue valueWithObject:@"test content" inContext:self.context];

    self.context[@"log"] = ^(){
        NSLog(@"%@",value);
    };

    [self.context[@"log"] callWithArguments:nil];
}

- (void)safeUseJSValue{
    
    [self.context evaluateScript:@"function success() {print('success') }"];
    [self.context evaluateScript:@"function failure() {print('failure') }"];
    self.context[@"print"] = ^(NSString *printStr){
        NSLog(@"printStr = %@",printStr);
    };
    
    
    self.context[@"presentNativeAlert"] = ^(NSString *title,
                                            NSString *message,
                                            JSValue *successHandler,
                                            JSValue *failureHandler) {
        JSContext *context = [JSContext currentContext];
        QSAlertView *alertView = [[QSAlertView alloc] initWithTitle:title
                                                            message:message
                                                            successHandler:successHandler
                                                     failureHandler:failureHandler
                                                            context:context];
        [alertView show];
    };
    [self.context evaluateScript:@"presentNativeAlert('提示','这是一条警告',success,failure)"];
}

- (void)dealloc{
    
    NSLog(@"%@ 被释放了",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
