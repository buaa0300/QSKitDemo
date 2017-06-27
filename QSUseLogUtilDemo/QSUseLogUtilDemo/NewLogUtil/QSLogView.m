//
//  QSLogView.m
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/3.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSLogView.h"
#import "YYWeakProxy.h"
#import "QSLogUtil.h"



@interface QSLogView(){

    CADisplayLink *_displayLink;
    NSUInteger _count;
    NSTimeInterval _lastTime;
    
}

@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIButton *showLogBtn;
@property (nonatomic,strong)UIButton *closeLogBtn;

@end


@implementation QSLogView

- (instancetype)init{

    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 60, 90, 40)];
        [self addSubview:({
            _showLogBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
            [_showLogBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_showLogBtn setTitle:@"loading..." forState:UIControlStateNormal];
            _showLogBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_showLogBtn addTarget:self action:@selector(onShowLogAction) forControlEvents:UIControlEventTouchUpInside];
            _showLogBtn.backgroundColor = [UIColor lightGrayColor];
            _showLogBtn.hidden = NO;
            _showLogBtn;
        })];
        
        [self addSubview:({
            
            _closeLogBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 90, 40)];
            _closeLogBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_closeLogBtn setTitle:@"loading..." forState:UIControlStateNormal];
            [_closeLogBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_closeLogBtn addTarget:self action:@selector(onCloseLogAction) forControlEvents:UIControlEventTouchUpInside];
            _closeLogBtn.backgroundColor = [UIColor lightGrayColor];
            _closeLogBtn.hidden = YES;
            _closeLogBtn;
        })];
        
        [self addSubview:({
            
            _textView = [[UITextView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
            _textView.textColor = [UIColor blackColor];
            _textView.backgroundColor = [UIColor whiteColor];
            _textView.scrollEnabled = YES;
            _textView.editable = NO;
            _textView.hidden = YES;
            _textView;
        })];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:[YYWeakProxy proxyWithTarget:self] selector:@selector(timerFire:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

+ (void)show{

    QSLogView *logView = [[QSLogView alloc]init];
    NSArray *rootVCViewSubViews = [[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    for (UIView *logView in rootVCViewSubViews) {
        if ([logView isKindOfClass:[QSLogView class]]) {
            return;
        }
    }
    [[((NSObject <UIApplicationDelegate> *)([UIApplication sharedApplication].delegate)) window].rootViewController.view addSubview:logView];
}

+ (void)close {
    
    NSArray *rootVCViewSubViews=[[UIApplication sharedApplication].delegate window].rootViewController.view.subviews;
    
    for (QSLogView *view in rootVCViewSubViews) {
        if ([view isKindOfClass:[QSLogView class]]) {
            QSLogView *logView = (QSLogView *)view;
            [logView removeFromSuperview];
        }
    }
}
- (void)onShowLogAction{

    _showLogBtn.hidden = YES;
    _closeLogBtn.hidden = NO;
    _textView.hidden = NO;
    
    [self setFrame:[UIScreen mainScreen].bounds];
    
    NSString *content = [QSLogUtil logContent];
    [_textView setText:content];
    [self scrollTextViewToBottom:_textView];
}

- (void)scrollTextViewToBottom:(UITextView *)textView {
    
    if(textView.text.length > 0 ) {
        NSRange bottom = NSMakeRange(textView.text.length -1, 1);
        [textView scrollRangeToVisible:bottom];
    }
}

- (void)onCloseLogAction{

    _showLogBtn.hidden = NO;
    _closeLogBtn.hidden = YES;
    _textView.hidden = YES;
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 60, 90, 40)];
}

- (void)dealloc {
    
    [_displayLink invalidate];
    QSLOG(@"%@被释放了",NSStringFromClass([self class]));
}

- (void)timerFire:(CADisplayLink *)link{
    
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    NSString *fpsString = [NSString stringWithFormat:@"[%d FPS]",(int)round(fps)];
    if (!self.showLogBtn.hidden) {
        [self.showLogBtn setTitle:[NSString stringWithFormat:@"[显示]%@",fpsString] forState:UIControlStateNormal];
    }
    
    if (!self.closeLogBtn.hidden) {
        [self.closeLogBtn setTitle:[NSString stringWithFormat:@"[关闭]%@",fpsString] forState:UIControlStateNormal];
    }
}

@end
