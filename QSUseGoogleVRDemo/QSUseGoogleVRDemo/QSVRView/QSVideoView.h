//
//  QSVideoView.h
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "GVRVideoView.h"

/**
 全景视频播放 + VR
 */
@interface QSVideoView : GVRVideoView

/**
 加载线上视频
 */
- (void)loadFromOnlineUrl:(NSURL*)videoUrl;

- (void)loadFromOnlineUrl:(NSURL *)videoUrl ofType:(GVRVideoType)videoType;

@end
