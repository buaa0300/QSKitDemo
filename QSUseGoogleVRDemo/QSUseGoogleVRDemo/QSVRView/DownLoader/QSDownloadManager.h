//
//  QSDownloadManager.h
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/14.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSDownLoadDefine.h"

#pragma mark - QSSessionModel
@interface QSSessionModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *url;  //下载url地址
@property (nonatomic, strong) NSOutputStream *stream;  //输出流
@property (nonatomic, copy) NSString *fileCachePath;  //文件缓存路径
@property (nonatomic, assign) NSInteger totalLength; //数据的总长度（字节数）
@property (nonatomic, assign) CGFloat progress;  //下载进度
@property (nonatomic, strong) NSDate *startTime;  //开始时间
@property (nonatomic, assign)QSDownloadState state;  //下载的状态

@property (nonatomic, copy) QSDownloadProgressBlock progressBlock; //下载进度
@property (nonatomic, copy) QSDownloadCompletedBlock completedBlock; //下载完成处理

/**
 返回文件的大小描述,如1MB，200KB
 */
+ (NSString *)fileSizeInUnitString:(unsigned long long)contentLength;


@end


extern NSString * const QSNetworkBadNotification;

#pragma mark - QSDownloadManager
@interface QSDownloadManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  下载
 */
- (void)download:(NSString *)url progress:(QSDownloadProgressBlock)progressBlock completedBlock:(QSDownloadCompletedBlock)completedBlock;

/**
 *  取消下载
 */
- (void)cancelDownLoad:(NSString *)url;


#pragma mark - 缓存文件的大小 & 删除
/**
 所有缓存资源大小
 */
- (NSString *)getAllCacheFileSizeString;

/**
 *  删除url对应的资源 && 如果url对应的资源还在下载，立即取消下载并清除对应未下载完整的资源
 *
 */
- (void)deleteFileCache:(NSString *)url;

/**
 *  清空所有下载资源
 */
- (void)deleteAllFileCache;


@end
