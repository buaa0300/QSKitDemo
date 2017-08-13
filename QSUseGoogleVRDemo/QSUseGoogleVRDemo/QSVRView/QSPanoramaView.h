//
//  QSPanoramaView.h
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "GVRPanoramaView.h"

/**
 全景图片播放 + VR
 */
@interface QSPanoramaView : GVRPanoramaView

/**
    加载线上图片
 */
- (void)loadImageUrl:(NSURL *)imageUrl;


- (void)loadImageUrl:(NSURL *)imageUrl ofType:(GVRPanoramaImageType)imageType;

@end
