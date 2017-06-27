//
//  QSTestViewController.m
//  QSUseTimerDemo
//
//  Created by zhongpingjiang on 17/4/27.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTestViewController.h"
#import "CADisplayLink+QSTool.h"
#import "NSTimer+QSTool.h"
#import "YYWeakProxy.h"

@interface QSTestViewController ()

@property (nonatomic,strong)NSTimer *timer;

@property (nonatomic,strong)CADisplayLink *displayLink;

@end

@implementation QSTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"QSUseTimerDemo";
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer qs_scheduledTimerWithTimeInterval:2 executeBlock:^(NSTimer *timer) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf executeTimer:timer];
    } repeats:YES];
    [self.timer fire];
    

    self.displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(executeDispalyLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)executeTimer:(NSTimer *)timer{

    NSLog(@"%.2lfs的定时器触发",timer.timeInterval);
}

- (void)dealloc{
    
    [self.timer invalidate];
    [self.displayLink invalidate];
    NSLog(@"%@被释放了",NSStringFromClass([self class]));
}

- (void)executeDispalyLink:(CADisplayLink *)displayLink{

    NSLog(@"%.3lfs同屏幕刷新",displayLink.duration);
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
