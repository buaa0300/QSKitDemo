//
//  UIImageView+SDWebImageExtension.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "UIImageView+SDWebImageExtension.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SDWebImageExtension)

- (void)qs_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder config:(QSProcessImageConfig *)config{

    NSLog(@"start download....");
    if (placeholder && self.image != placeholder) {
        self.image = placeholder;
    }
    
    NSString *urlString = [url absoluteString];
    if (!urlString || [urlString length]  <= 0) {
        return;
    }
    
    NSString *cacheUrlString = [NSString stringWithFormat:@"%@-%@",urlString,[config description]];

    
    NSLog(@"cacheUrlString = %@",cacheUrlString);
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    SDImageCache *cache = manager.imageCache;
    
    NSString *cacheKey = [manager cacheKeyForURL:[[NSURL alloc] initWithString:cacheUrlString]];
    [cache queryCacheOperationForKey:cacheKey done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
    
        if (image) {
            self.image = image;
            NSLog(@"end download....");
        }else{
            
           
            [manager.imageDownloader downloadImageWithURL:url options:SDWebImageRetryFailed | SDWebImageHighPriority | SDWebImageAvoidAutoSetImage  progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                if (image) {
                    
                    [QSProcessImageManager imageWithOriginImage:image config:config completed:^(UIImage *outputImage) {
                        
                        if (outputImage) {
                            self.image = outputImage;
                            [cache storeImage:outputImage forKey:cacheKey completion:nil];
                        }
                    }];
                }else{
                    NSLog(@"下载失败");
                    
                }
                NSLog(@"end download....");
            }];
        }
    }];



}

@end
