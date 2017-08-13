//
//  WeexImageDownloader.m
//  QSWeexDemo
//
//  Created by zhongpingjiang on 16/12/16.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "WeexImageDownloader.h"
#import <SDWebImage/SDWebImageManager.h>

@implementation WeexImageDownloader

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url
                                          imageFrame:(CGRect)imageFrame
                                            userInfo:(NSDictionary *)options
                                           completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock {
    return (id<WXImageOperationProtocol>)[[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, finished);
        }
    }];
}

@end
