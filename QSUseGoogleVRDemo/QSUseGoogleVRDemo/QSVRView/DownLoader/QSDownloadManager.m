//
//  QSDownloadManager.m
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/14.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDownloadManager.h"
#import <SystemConfiguration/SystemConfiguration.h>

#pragma mark - QSSessionModel
@implementation QSSessionModel

//编码
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeInteger:self.totalLength forKey:@"totalLength"];
}

//解码
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.totalLength = [aDecoder decodeIntegerForKey:@"totalLength"];
    }
    return self;
}

+ (NSString *)fileSizeInUnitString:(unsigned long long)contentLength{
    
    CGFloat fileSize = 0.0f;
    NSString *unitStr = @"";
    if(contentLength >= pow(1024, 3)) {
        fileSize =  contentLength * 1.0 / pow(1024, 3);
        unitStr = @"GB";
    }
    else if (contentLength >= pow(1024, 2)) {
        
        fileSize = contentLength * 1.0 / pow(1024, 2);
        unitStr = @"MB";
    }else if (contentLength >= 1024) {
        
        fileSize = contentLength * 1.0 / 1024;
        unitStr = @"KB";
    }else {
        fileSize = contentLength * 1.0;
        unitStr = @"B";
    }
    
    NSString *fileSizeInUnitStr = [NSString stringWithFormat:@"%.2f %@",
                                   fileSize,unitStr];
    return fileSizeInUnitStr;
}

@end


#pragma mark - QSDownloadManager

NSString * const QSNetworkBadNotification = @"QSNetworkBadNotification";

@interface QSDownloadManager()<NSCopying, NSURLSessionDelegate>

/** 保存所有任务,使用文件名为key,以NSURLSessionDataTask对象为value*/
@property (nonatomic, strong) NSMutableDictionary *tasks;

/** 保存所有下载相关信息字典，以taskIdentifier为key，QSSessionModel对象对value */
@property (nonatomic, strong) NSMutableDictionary *sessionModelDics;


/** 所有本地存储的所有下载信息数据数组 */
@property (nonatomic, strong) NSMutableArray *sessionModelInfos;

@end

@implementation QSDownloadManager

static QSDownloadManager *_downloadManager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _downloadManager = [super allocWithZone:zone];
    });
    
    return _downloadManager;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone{
    
    return _downloadManager;
}

+ (instancetype)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManager = [[self alloc] init];
    });
    
    return _downloadManager;
}

/**
 * 归档数据
 */
- (void)saveModelInfo:(QSSessionModel *)model{
    
    [self.sessionModelInfos addObject:model];
    [NSKeyedArchiver archiveRootObject:self.sessionModelInfos toFile:QSFileTotalLengthPath];
}

- (NSMutableArray *)sessionModelInfos{
    
    if (!_sessionModelInfos) {
        _sessionModelInfos = [NSMutableArray array];
        NSArray *sessionModels = [NSKeyedUnarchiver unarchiveObjectWithFile:QSFileTotalLengthPath];
        [_sessionModelInfos addObjectsFromArray:sessionModels];
    }
    return _sessionModelInfos;
}

/**
 *  读取数据
 */
- (NSInteger)totalLengthAt:(NSString *)url{
    
    NSArray *modelInfos = [self.sessionModelInfos copy];
    for (QSSessionModel *model in modelInfos) {
        if ([model.url isEqual:url]) {
            return model.totalLength;
        }
    }
    return 0;
}

- (NSMutableDictionary *)sessionModelDics{
    
    if (!_sessionModelDics) {
        _sessionModelDics = @{}.mutableCopy;
    }
    return _sessionModelDics;
}


#pragma mark - 下载 & 取消
/**
 *  下载
 */
- (void)download:(NSString *)url progress:(QSDownloadProgressBlock)progressBlock completedBlock:(QSDownloadCompletedBlock)completedBlock{
    
    //初始化
    QSSessionModel *sessionModel = [[QSSessionModel alloc] init];
    sessionModel.url = url;
    sessionModel.fileCachePath = QSFileFullpath(url);
    sessionModel.progressBlock = progressBlock;
    sessionModel.completedBlock = completedBlock;
    
    //url不可以下载
    if (![self canDownload:url sessionModel:sessionModel]) {
        return;
    }
    
    if ([self isFileDownCompletedAt:url] && sessionModel) {
        
        sessionModel.state = QSDownloadStateCompleted;
        if (completedBlock && sessionModel.fileCachePath) {
            completedBlock(sessionModel.fileCachePath);
        }
        NSLog(@"%@ 已下载完成",url);
        return;
    }
    
    //网络不好
    if (![self isNetworkReachable:url]) {
        return;
    }
    
    
    //初始化URLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 创建流
    NSOutputStream *stream = [NSOutputStream outputStreamToFileAtPath:sessionModel.fileCachePath append:YES];
    // 创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    // 设置请求头
    NSString *range = [NSString stringWithFormat:@"bytes=%ld-", QSDownloadLength(url)];
    NSLog(@"range = %@",range);
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    // 创建一个Data任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    NSUInteger taskIdentifier = arc4random() % ((arc4random() % 10000 + arc4random() % 10000));
    [dataTask setValue:@(taskIdentifier) forKeyPath:@"taskIdentifier"];
   
    sessionModel.state = QSDownloadStateStart;
    sessionModel.stream = stream;
    sessionModel.startTime = [NSDate date];
    
    // 缓存任务
    [self.tasks setValue:dataTask forKey:QSFileName(url)];
    //缓存model到内存
    [self.sessionModelDics setValue:sessionModel forKey:@(dataTask.taskIdentifier).stringValue];
    //开始下载
    
    //转菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *task = [self getTask:url];
    [task resume];
    
}

/**
 取消下载
 */
- (void)cancelDownLoad:(NSString *)url{
    
    if (!url || url.length == 0) {
        return;
    }
    
    NSURLSessionDataTask *task = [self getTask:url];
    if (task && task.state == NSURLSessionTaskStateRunning) {
        // 取消下载
        [task cancel];
        NSLog(@"取消下载");
    }
}

- (NSMutableDictionary *)tasks{
    
    if (!_tasks) {
        _tasks = [NSMutableDictionary dictionary];
    }
    return _tasks;
}

/**
 是否可以下载,凡url为空，重复下载(同一个url还没有下载结束),都不可以下载
 */
- (BOOL)canDownload:(NSString *)url sessionModel:(QSSessionModel *)sessionModel{
    
    if (!url || url.length == 0){
        NSLog(@"urlString不可以为空");
        return NO;
    }
    
    NSURLSessionDataTask *task = [self getTask:url];
    if (task && task.state == NSURLSessionTaskStateRunning) {
        NSLog(@"%@ 正在下载中，请勿重复下载",url);
        return NO;
    }
    
    // 创建缓存目录文件
    if (![[NSFileManager defaultManager] fileExistsAtPath:QSCachesDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:QSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return YES;
}

- (BOOL)isNetworkReachable:(NSString *)url{

    //检测网络是否可达
    SCNetworkReachabilityRef hostReachable = SCNetworkReachabilityCreateWithName(NULL, [[NSURL URLWithString:url].host UTF8String]);
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(hostReachable, &flags);
    BOOL isReachable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    if (hostReachable) {
        CFRelease(hostReachable);
    }
    //如果网络不可达
    if (!isReachable) {
        [[NSNotificationCenter defaultCenter]postNotificationName:QSNetworkBadNotification object:nil];
        NSLog(@"对不起，网络不好，请稍后再试");
        return NO;
    }
    return YES;
}


/**
 *  根据url获得对应的下载任务
 */
- (NSURLSessionDataTask *)getTask:(NSString *)url{
    
    NSURLSessionDataTask *task  = (NSURLSessionDataTask *)[self.tasks valueForKey:QSFileName(url)];
    return task;
}

/**
 *  判断该文件是否下载完成
 */
- (BOOL)isFileDownCompletedAt:(NSString *)url{
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:QSFileFullpath(url)]) {
        
        NSInteger totalLength = [self totalLengthAt:url];
        NSInteger downloadedLength = QSDownloadLength(url);
        
        if (totalLength > 0) {
            NSLog(@"总文件大小 = %ld,已经下载的文件大小 = %ld，已经下载了 = %.2lf%%",totalLength,downloadedLength,downloadedLength * 1.0 /totalLength * 100);
            if (downloadedLength == totalLength) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark NSURLSessionDataDelegate
/**
 * 接收到响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    
    QSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 打开流
    [sessionModel.stream open];
    
    // 获得服务器这次请求 返回数据的总长度
    NSInteger totalLength = [response.allHeaderFields[@"Content-Length"] integerValue] + QSDownloadLength(sessionModel.url);
    sessionModel.totalLength = totalLength;
    
    [self saveModelInfo:sessionModel];
    
    // 接收这个请求，允许接收服务器的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器返回的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    QSSessionModel *sessionModel = [self getSessionModel:dataTask.taskIdentifier];
    
    // 写入数据
    [sessionModel.stream write:data.bytes maxLength:data.length];
    
    // 下载进度
    NSUInteger receivedSize = QSDownloadLength(sessionModel.url);
    NSUInteger expectedSize = sessionModel.totalLength;
    CGFloat progress = 1.0 * receivedSize / expectedSize;
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [sessionModel.startTime timeIntervalSinceNow];
    NSUInteger speed = receivedSize / downloadTime;
    if (speed == 0) { return; }
    NSString *speedStr = [NSString stringWithFormat:@"%@/s",[QSSessionModel fileSizeInUnitString:(unsigned long long) speed]];
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    unsigned long long remainingContentLength = expectedSize - receivedSize;
    int remainingTime = (int)(remainingContentLength / speed);
    int hours = remainingTime / 3600;
    int minutes = (remainingTime - hours * 3600) / 60;
    int seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if(hours>0) {[remainingTimeStr appendFormat:@"%d 小时 ",hours];}
    if(minutes>0) {[remainingTimeStr appendFormat:@"%d 分 ",minutes];}
    if(seconds>0) {[remainingTimeStr appendFormat:@"%d 秒",seconds];}
    
    sessionModel.state = QSDownloadStateDownloading;
    sessionModel.progress = progress;
    
    //下载进度
    if (sessionModel.progressBlock) {
        sessionModel.progressBlock(progress, speedStr, remainingTimeStr);
    }
}

/**
 * 请求完毕（成功|失败）
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    QSSessionModel *sessionModel = [self getSessionModel:task.taskIdentifier];
    if (!sessionModel) return;
    
    // 关闭流
    [sessionModel.stream close];
    sessionModel.stream = nil;
    
    NSString *costTimeStr = [NSString stringWithFormat:@"%.3lf",[[NSDate date] timeIntervalSinceDate:sessionModel.startTime]];
    if ([self isFileDownCompletedAt:sessionModel.url]) {
        // 下载完成
        sessionModel.state = QSDownloadStateCompleted;
        if (sessionModel.completedBlock && sessionModel.fileCachePath) {
            NSLog(@"%@下载成功",sessionModel.url);
            sessionModel.completedBlock(sessionModel.fileCachePath);
        }
        
    } else if (error){
        
        if (error.code == NSURLErrorCancelled){
            //取消请求
            NSLog(@"取消下载成功");
            sessionModel.state = QSDownloadStateCancel;
        }else{
            // 取消请求之外的失败清除缓存
            sessionModel.state = QSDownloadStateFailed;
            [self deleteFileCache:sessionModel.url];
            NSLog(@"%@下载失败了",sessionModel.url);
        }
    }
    NSLog(@"%@下载花费时间: %@，下载的进度是:%.2lf%%",sessionModel.url,costTimeStr,sessionModel.progress * 100);

    // 清除任务 & 更新
    [self.tasks removeObjectForKey:QSFileName(sessionModel.url)];
    [self.sessionModelDics removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    
}

/**
 *  根据taskIdentifier获取对应的下载信息模型
 */
- (QSSessionModel *)getSessionModel:(NSUInteger)taskIdentifier{
    
    return (QSSessionModel *)[self.sessionModelDics valueForKey:@(taskIdentifier).stringValue];
}

#pragma mark - 缓存文件的大小 & 删除
/**
 所有缓存资源大小
 */
- (NSString *)getAllCacheFileSizeString{
    
    NSString *cacheDirectory = QSCachesDirectory;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取文件夹所有子路径数组:获取多级目录下文件路径
    NSArray *subpaths = [fileManager subpathsAtPath:cacheDirectory];
    int totalSize = 0;
    for (NSString *subPath in subpaths) {
        //拼接每一条子路径
        NSString *filePath = [cacheDirectory stringByAppendingPathComponent:subPath];
        // 判断是否是隐藏文件(.DS为苹果中的一种隐藏文件)
        if ([filePath containsString:@".DS"])
            continue;
        
        // 判断是否是文件夹
        BOOL isDirectory = NO;
        //如果文件不存在或者为文件夹,就跳过
        BOOL isExists = [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExists || isDirectory)
            continue;
        
        // 获取文件属性(利用文件的fileSize属性)
        NSDictionary *attr = [fileManager attributesOfItemAtPath:filePath error:nil];
        totalSize += [attr fileSize];
    }
    
    NSString * fileSizeStr = [QSSessionModel fileSizeInUnitString:totalSize];
    return fileSizeStr;
}

/**
 *  删除url对应的资源
 */
- (void)deleteFileCache:(NSString *)url{

    [self cancelDownLoad:url];

    NSString *filePath = QSFileFullpath(url);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        // 删除沙盒中的资源
        [fileManager removeItemAtPath:filePath error:nil];
        // 删除任务
        [self.tasks removeObjectForKey:filePath];
        [self.sessionModelDics removeObjectForKey:@([self getTask:url].taskIdentifier).stringValue];
    }
}

/**
 *  清空所有下载资源
 */
- (void)deleteAllFileCache{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:QSCachesDirectory]) {
        
        // 删除沙盒中所有资源
        [fileManager removeItemAtPath:QSCachesDirectory error:nil];
        // 删除任务
        [[self.tasks allValues] makeObjectsPerformSelector:@selector(cancel)];
        [self.tasks removeAllObjects];
        
        for (QSSessionModel *sessionModel in [self.sessionModelDics allValues]) {
            [sessionModel.stream close];
        }
        [self.sessionModelDics removeAllObjects];
    }
}

@end
