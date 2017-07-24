//
//  QSProcessImageManager.h
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^QSProcessImageCompletionBlock)(UIImage *outputImage);

#pragma mark - QSProcessImageConfig
@interface QSProcessImageConfig : NSObject

/**
 图片输出大小
 */
@property (nonatomic,assign)CGSize outputSize;
@property (nonatomic,assign)CGFloat cornerRadius;
@property (nonatomic,strong)UIColor *bgColor;



@end

#pragma mark - QSProcessImageManager
@interface QSProcessImageManager : NSObject

+ (void)imageWithOriginImage:(UIImage *)originImage config:(QSProcessImageConfig *)config completed:(QSProcessImageCompletionBlock)completedBlock;

@end
