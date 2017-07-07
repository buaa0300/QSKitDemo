//
//  QSTableViewDefine.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#ifndef QSTableViewDefine_h
#define QSTableViewDefine_h

//NSString * QSString(NSString * value, NSString * defaultString);

//定义数据加载样式
typedef NS_ENUM(NSInteger,QSRefreshTableViewDataStyle){
    
    QSRefreshTableViewDataStyleNormal = 0, //普通样式
    QSRefreshTableViewDataStylePull = 1,   //下拉刷新
    QSRefreshTableViewDataStyleLoadMore = 2, //上拉加载
};








#endif /* QSTableViewDefine_h */
