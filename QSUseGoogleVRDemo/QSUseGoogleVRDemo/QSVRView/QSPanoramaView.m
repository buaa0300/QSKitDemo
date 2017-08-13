//
//  QSPanoramaView.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSPanoramaView.h"
#import "QSDownloadManager.h"
#import "MBProgressHUD+Load.h"

@interface QSPanoramaView()<GVRWidgetViewDelegate>

@property (nonatomic,strong)NSURL *imageUrl;
@property (nonatomic,strong)UIImageView *placeholderView;

@end

@implementation QSPanoramaView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}

- (void)setupConfig{

    self.enableInfoButton = NO;
    self.enableFullscreenButton = NO;
    self.enableCardboardButton = YES;
    self.hidesTransitionView = YES;
    self.enableTouchTracking = YES;
    self.delegate = self;
}

- (UIImageView *)placeholderView{
    
    if (!_placeholderView) {
        _placeholderView = [[UIImageView alloc]initWithFrame:self.bounds];
        _placeholderView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (void)loadImageUrl:(NSURL *)imageUrl{

    [self loadImageUrl:imageUrl ofType:kGVRPanoramaImageTypeMono];
}

- (void)loadImageUrl:(NSURL *)imageUrl ofType:(GVRPanoramaImageType)imageType{
    
    if ([self.imageUrl isEqual:imageUrl]) {
        return;
    }
    
    [self cancelCurrentDownLoad];
    self.imageUrl = imageUrl;
    self.placeholderView.alpha = 1.0f; //遮盖
    [MBProgressHUD showHUDWithContent:@"图片加载中..." toView:self];
    
    [[QSDownloadManager sharedInstance]download:[imageUrl absoluteString]
                                       progress:^(CGFloat progress, NSString *speed, NSString *remainingTime) {

                                           NSLog(@"当前下载进度:%.2lf%%,当前的下载速度是：%@，还需要时间:%@,",progress * 100,speed,remainingTime);
        
                                       } completedBlock:^(NSString *fileCacheFile) {
                                           
                                           NSData *imageData = [NSData dataWithContentsOfFile:fileCacheFile];
                                           UIImage *image = [UIImage imageWithData:imageData];
                                           [self loadImage:image ofType:imageType];
                                       }];
}

- (void)cancelCurrentDownLoad{
    
    [[QSDownloadManager sharedInstance] cancelDownLoad:[self.imageUrl absoluteString]];
    
}

#pragma mark - GVRWidgetViewDelegate
- (void)widgetView:(GVRWidgetView *)widgetView didLoadContent:(id)content {
    
    NSLog(@"图片加载完成...");
    [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.placeholderView.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [_placeholderView removeFromSuperview];
        _placeholderView = nil;
        [MBProgressHUD hideHUDInView:self];
    }];
}

@end
