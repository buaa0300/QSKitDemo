//
//  QSVideoView.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSVideoView.h"
#import "MBProgressHUD+Load.h"
#import "QSDownloadManager.h"
#import<AVFoundation/AVFoundation.h>
#import "UIImage+QSView.h"

@interface QSVideoView()<GVRWidgetViewDelegate>

@property (nonatomic,strong)NSURL *videoUrl;

@property (nonatomic,strong)UIImageView *placeholderView;
@property (nonatomic,strong)UIButton *playBtn;
@property (nonatomic,strong)UIProgressView *playProgressView;

@property (nonatomic,assign)BOOL isPlaying;    //是否正在播放

@end

@implementation QSVideoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
        [self addSubview:self.playProgressView];
        [self addSubview:self.playBtn];

        //监听耳机事件
        [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
    }
    return self;
}

- (void)setupConfig{
    
    //隐藏消息按钮
    self.enableInfoButton = NO;
    self.enableFullscreenButton = NO;
    self.enableCardboardButton = YES;
    self.hidesTransitionView = YES;
    self.enableTouchTracking = YES;
    self.delegate = self;
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIImageView *)placeholderView{

    if (!_placeholderView) {
        _placeholderView = [[UIImageView alloc]initWithFrame:self.bounds];
        _placeholderView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (UIButton *)playBtn{

    if (!_playBtn) {
        _playBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [_playBtn setImage:[UIImage vrBundleImageNamed:@"Images/icon_play.png"] forState:UIControlStateNormal];
        _playBtn.backgroundColor = [UIColor lightTextColor];
        [_playBtn addTarget:self action:@selector(onTapPlayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIProgressView *)playProgressView{

    if (!_playProgressView) {
        _playProgressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _playProgressView.progressTintColor =  [UIColor blueColor];
        _playProgressView.trackTintColor = [UIColor lightGrayColor];
        _playProgressView.transform = CGAffineTransformMakeScale(1.0, 3.0);
        _playProgressView.frame = CGRectMake(0, 0, self.bounds.size.width, 5);
        _playProgressView.hidden = YES;
    }
    return _playProgressView;
}

/**
 加载线上的视频
 */

- (void)loadFromOnlineUrl:(NSURL*)videoUrl{

    [self loadFromOnlineUrl:videoUrl ofType:kGVRVideoTypeMono];
}

- (void)loadFromOnlineUrl:(NSURL *)videoUrl ofType:(GVRVideoType)videoType{
    
    if ([self.videoUrl isEqual:videoUrl]) {
        return;
    }
    
    self.videoUrl = videoUrl;
    
    [MBProgressHUD showHUDWithContent:@"视频加载中..." toView:self];
    self.placeholderView.alpha = 1.0f;  //遮盖
    [self loadFromUrl:videoUrl ofType:videoType];
}


#pragma mark - GVRVideoViewDelegate
- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {

    NSLog(@"视频加载结束...");
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.placeholderView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_placeholderView removeFromSuperview];
        _placeholderView = nil;
        [MBProgressHUD hideHUDInView:self];
        [self seekTo:0];
    }];
}

- (void)widgetView:(GVRWidgetView *)widgetView didFailToLoadContent:(id)content withErrorMessage:(NSString *)errorMessage {
    NSLog(@"Failed to load video: %@", errorMessage);
    
    [MBProgressHUD hideHUDInView:self];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"⚠️"  message:@"视频加载失败..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)videoView:(GVRVideoView*)videoView didUpdatePosition:(NSTimeInterval)position {
    // Loop the video when it reaches the end.
    CGFloat progress = position / videoView.duration;
    NSLog(@"播放进度: %lf", progress);
    BOOL isAnimation = (progress == 0);
    [self.playProgressView setProgress:progress animated:isAnimation];
}

- (void)onTapPlayAction:(UIButton *)btn{

    [UIView animateWithDuration:1.0 animations:^{
        
        btn.alpha = 0;
    
    } completion:^(BOOL finished) {
        
        [btn removeFromSuperview];
        [self play];
        self.playProgressView.hidden = NO;
    }];
}

#pragma mark - 耳机的处理
//监听耳机拔出和插入的处理
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            NSLog(@"耳机插入");
            [self play];
            [self updateUI];
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            NSLog(@"耳机拔出，停止播放操作");
            [self pause];
            [self updateUI];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

- (void)play{

    [super play];
    self.isPlaying = YES;
}

- (void)pause{

    [super pause];
    self.isPlaying = NO;
}

- (void)stop{
    [super stop];
    self.isPlaying = NO;

}

- (void)updateUI{

    if (self.isPlaying) {
        //隐藏播放按钮
        [UIView animateWithDuration:0.5 animations:^{
            self.playBtn.alpha = 0;
        } completion:^(BOOL finished) {
            
            if (self.playBtn.superview != nil) {
                [self.playBtn removeFromSuperview];
            }
        }];
        
    }else{
        //显示播放按钮
        [UIView animateWithDuration:0.5 animations:^{
            
            self.playBtn.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (self.playBtn.superview == nil) {
               [self addSubview:self.playBtn];
            }
        }];
    }
}

@end
