//
//  QSJSObjectModel.h
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSJSObjectModelExport <JSExport>

JSExportAs(validateInput,-(void)validateInput:(NSString *)inputString callback:(NSString *)callback);

JSExportAs(loadImage,-(void)loadImage:(NSString *)imageUrlString callBack:(NSString *)callBack);

@end


#pragma mark - 注入JS的模型，达到js调用OC的目的
@interface QSJSObjectModel : NSObject<QSJSObjectModelExport>


@property(weak, nonatomic) UIWebView *webView;




@end
