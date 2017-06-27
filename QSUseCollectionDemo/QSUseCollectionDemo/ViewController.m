//
//  ViewController.m
//  QSUseCollectionDemo
//
//  Created by zhongpingjiang on 2017/6/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSThreadSafeMutableArray.h"
#import "QSThreadSafeMutableDictionary.h"
#import "QSThreadSafeCounter.h"


@interface ViewController ()

@property (nonatomic,strong) NSMutableArray* someArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //安全
    QSThreadSafeMutableArray *safeArray = [[QSThreadSafeMutableArray alloc]init];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(queue, ^{
            NSString *str = [NSString stringWithFormat:@"数组%d",(int)i+1];
            [safeArray addObject:str];
        });
    }

    sleep(1);
    NSLog(@"打印数组");
    [safeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"%@",obj);
    }];
    
    
    QSThreadSafeMutableDictionary *safeDic = [[QSThreadSafeMutableDictionary alloc]init];
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(queue, ^{
            
            NSString *str = [NSString stringWithFormat:@"字典value%d",(int)i+1];
            [safeDic setObject:str forKey:@(i+1)];
        });
    }
    
    sleep(1);
    NSLog(@"打印字典");
    [safeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSLog(@"key = %@ , value = %@",key,obj);
    }];
    
    QSThreadSafeCounter *counter = [[QSThreadSafeCounter alloc]init];
    for (NSInteger i = 0; i < 10; i++) {
        
        dispatch_async(queue, ^{
            
            [counter increase];
        });
    }
    
    sleep(1);
    NSLog(@"打印数值");
    NSLog(@"%d",[counter value]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
