//
//  QSJSObjectModel.m
//  QSUseJSCoreDemo
//
//  Created by zhongpingjiang on 17/5/9.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSJSObjectModel.h"
#import "SDWebImageManager.h"

@implementation QSJSObjectModel

- (void)validateInput:(NSString *)inputString callback:(NSString *)callback{

    NSLog(@"inputString = %@",inputString);
    NSString *res = @"";
    if (!inputString  || [inputString isEqualToString:@""] || [inputString isEqualToString:@"undefined"]) {
        res = @"输入不能为空";
    }else{
        res = @"输入正确";
    }
    
    NSLog(@"%@",res);
    NSString *callbackJS = [NSString stringWithFormat:@"%@('%@')", callback,res];
    [self.webView stringByEvaluatingJavaScriptFromString:callbackJS];
}

- (void)loadImage:(NSString *)imageUrlString callBack:(NSString *)callBack{

    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageUrlString] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
        if (!image) {
            return;
        }
        
        NSString *imageCachePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:[imageURL absoluteString]];
        NSString *callbackJS = [NSString stringWithFormat:@"%@('%@')", callBack,imageCachePath];
        [self.webView stringByEvaluatingJavaScriptFromString:callbackJS];
    }];
}

@end
