//
//  QSWebView3Controller.m
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 2017/8/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSWebView3Controller.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

static NSString  * const onLoadedMethodJSName = @"onLoaded";
static NSString  * const browImageMethodJSName = @"browImage";
static NSString  * const imageDownLoadCompletedJSName = @"imageDownLoadCompleted";

@interface QSWebView3Controller ()<XLPhotoBrowserDatasource>

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) NSMutableArray *imageFilePaths;

@end

@implementation QSWebView3Controller

//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//
//    
//    [self registerNativeHandler];
//    
////    WKWebViewConfiguration *config =[[WKWebViewConfiguration alloc]init];
////    
////    /** WebView的偏好设置 */
////    
////    config.preferences.minimumFontSize = 10;
////    
////    config.preferences.javaScriptEnabled = YES;
////    
////    /** 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开 */
////    
////    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
////    
////    /**  添加JS到到HTML中  */
////    
////    NSString *js = @"window.alert('欢迎体验WkWebView!!');";
////    
////    WKUserScript *script = [[WKUserScript alloc]initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
////    
////    WKWebViewConfiguration *config =[[WKWebViewConfiguration alloc]init];
//    
//
//
//    
//    NSString *htmlFilePath = [[NSBundle mainBundle]pathForResource:@"content2" ofType:@"html"];
//    NSString *htmlContentString = [NSString stringWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
//
//    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"content1" ofType:@"js"];
//    //读取JS文件内容
////    NSString *jsContentString = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
//////      content1.html中引入js和css文件直接使用wkWebView的loadHTMLString不能加载出来
////    htmlContentString = [htmlContentString stringByReplacingOccurrencesOfString:@"{{script_content}}" withString:jsContentString];
//    // loadRequest 也有问题
////    [self.wkWebView loadHTMLString:htmlContentString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
//    
//     [self.wkWebView loadFileURL:[NSURL fileURLWithPath:htmlFilePath] allowingReadAccessToURL:[NSURL fileURLWithPath:htmlFilePath]];
//    
////    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlFilePath]]];
//    
//}

//将文件copy到tmp目录
//- (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
//    NSError *error = nil;
//    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
//        return nil;
//    }
//    // Create "/temp/www" directory
//    NSFileManager *fileManager= [NSFileManager defaultManager];
//    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
//    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
//    
//    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
//    // Now copy given file to the temp directory
//    [fileManager removeItemAtURL:dstURL error:&error];
//    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
//    // Files in "/temp/www" load flawlesly :)
//    return dstURL;
//}

//调用逻辑
//NSString *path = [[NSBundle mainBundle] pathForResource:@"indexoff" ofType:@"html"];
//if(path){
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
//        // iOS9. One year later things are OK.
//        NSURL *fileURL = [NSURL fileURLWithPath:path];
//        [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
//    } else {
//        // iOS8. Things can be workaround-ed
//        //   Brave people can do just this
//        //   fileURL = try! pathForBuggyWKWebView8(fileURL)
//        //   webView.loadRequest(NSURLRequest(URL: fileURL))
//        
//        NSURL *fileURL = [self.fileHelper fileURLForBuggyWKWebView8:[NSURL fileURLWithPath:path]];
//        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//        [self.webView loadRequest:request];
//    }
//}






/**
 注册Native方法，响应JS调用
 */
- (void)registerNativeHandler{
    
    [WKWebViewJavascriptBridge enableLogging];
    
    //页面加载
    @weakify(self);
    [self.bridge registerHandler:onLoadedMethodJSName handler:^(NSArray *imageInfos, WVJBResponseCallback responseCallback) {
        //js传过来的数据
        //        NSLog(@"imageInfos =  %@", imageInfos);
        @strongify(self);
        [self downloadImagesWithInfos:imageInfos];
    }];
    
    //点击图片
    [self.bridge registerHandler:browImageMethodJSName handler:^(NSArray *dataArray, WVJBResponseCallback responseCallback) {
        @strongify(self);
        NSLog(@"dataArray =  %@", dataArray);
        NSInteger index = [dataArray[0] integerValue];
        XLPhotoBrowser *imageBrowser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:[self.imageFilePaths count] datasource:self];
        imageBrowser.browserStyle = XLPhotoBrowserStyleSimple;
    }];
}

- (WKWebViewJavascriptBridge *)bridge{
    
    if (!_bridge) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        [_bridge setWebViewDelegate:self];
    }
    return _bridge;
}

- (NSMutableArray *)imageFilePaths{
    
    if (!_imageFilePaths) {
        _imageFilePaths = [NSMutableArray array];
    }
    return _imageFilePaths;
}


/**
 在本地下载多张图片，图片下载成功通知js处理
 */
- (void)downloadImagesWithInfos:(NSArray *)imageInfos{
    
    [imageInfos enumerateObjectsUsingBlock:^(NSArray *info, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *imageCachePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:info[1]];
        [self.imageFilePaths addObject:imageCachePath];
    }];
    
    for (int i = 0; i < [imageInfos count]; i++) {
        
        NSArray *imageInfo = [imageInfos objectAtIndex:i];
        NSUInteger imageIndex = [imageInfo[0] integerValue];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageInfo[1]] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!image) {
                return;
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *imageCachePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:[imageURL absoluteString]];
                //通知js的imagesDownloadComplete方法处理
                [self.bridge callHandler:imageDownLoadCompletedJSName data:@[[NSNumber numberWithInteger:imageIndex],imageCachePath] responseCallback:nil];
            });
        }];
    }
}

- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    return [UIImage imageWithContentsOfFile:self.imageFilePaths[index]];
}


@end
