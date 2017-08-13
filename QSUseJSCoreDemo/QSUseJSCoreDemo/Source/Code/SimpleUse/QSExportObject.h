//
//  QSExportObject.h
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSExport <JSExport>

- (void)print:(NSString *)text;

- (void)alert:(NSString *)text;

//JSExportAs(print,- (void)print:(NSString *)text);

//JSExportAs(alert,- (void)alert:(NSString *)text);

@end


@interface QSExportObject : NSObject<QSExport>

@property (nonatomic,weak)UIViewController *vc;

@end
