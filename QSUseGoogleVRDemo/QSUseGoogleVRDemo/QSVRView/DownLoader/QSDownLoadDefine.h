//
//  QSDownLoadDefine.h
//  QSUseGoogleVRDemo
//
//  Created by zhongpingjiang on 17/4/19.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#ifndef QSDownLoadDefine_h
#define QSDownLoadDefine_h

// 缓存主目录
#define QSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]stringByAppendingPathComponent:@"QSUseGoogleVRDemo/CacheResource"]

// 保存文件名
#define QSFileName(url)  [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define QSFileFullpath(url) [QSCachesDirectory stringByAppendingPathComponent:QSFileName(url)]

// 文件的已下载长度
#define QSDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:QSFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件长度和url信息的路径
#define QSFileTotalLengthPath [QSCachesDirectory stringByAppendingPathComponent:@"FileTotalLength"]

typedef NS_ENUM(NSInteger, QSDownloadState){
    
    QSDownloadStateStart = 0,     /** 下载开始 */
    QSDownloadStateDownloading,   /** 下载进行时 */
    QSDownloadStateCancel,        /** 下载取消 */
    QSDownloadStateCompleted,     /** 下载完成 */
    QSDownloadStateFailed         /** 下载失败 */
};

typedef void(^QSDownloadProgressBlock)(CGFloat progress, NSString *speed, NSString *remainingTime);

typedef void(^QSDownloadCompletedBlock)(NSString *fileCacheFile);

#endif /* QSDownLoadDefine_h */
