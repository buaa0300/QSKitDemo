//
//  QSExportObject.m
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSExportObject.h"

@implementation QSExportObject

- (void)print:(NSString *)text{

    NSLog(@"print text = %@",text);
}

- (void)alert:(NSString *)text{
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    [vc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [self.vc presentViewController:vc animated:YES completion:nil];
}

@end
