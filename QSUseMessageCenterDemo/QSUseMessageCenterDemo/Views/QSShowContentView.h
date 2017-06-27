//
//  QSShowContentView.h
//  QSUseMessageCenterDemo
//
//  Created by zhongpingjiang on 17/4/25.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>

#define QSSetContentValueID @"SET"
#define QSReSetContentValueID @"RESET"

@interface QSContentModel : NSObject

@property (nonatomic,copy)NSString *content;
@property (nonatomic,assign)NSInteger index;

- (instancetype)initWithIndex:(NSInteger)index content:(NSString *)content;

@end

@interface QSShowContentView : UIView

@end
