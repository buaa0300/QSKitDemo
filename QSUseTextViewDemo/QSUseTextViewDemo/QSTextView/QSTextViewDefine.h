//
//  QSTextViewDefine.h
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#ifndef QSTextViewDefine_h
#define QSTextViewDefine_h

#define CHECK_VALID_DELEGATE(d, s)                  (d && [d respondsToSelector:s])

/**
 QSTextView的增长方向
 */
typedef NS_ENUM(NSInteger,QSTextViewGrowDirection){
   
    QSTextViewGrowDirectionDown = 0, //向下,默认
    QSTextViewGrowDirectionUp = 1,   //向上
   
};


typedef NS_ENUM(NSInteger,QSTextViewBorderLineStyle) {
    
    QSTextViewBorderLineStyleNone = 0,   //无边框线
    QSTextViewBorderLineStyleSolid = 1, //实线
    QSTextViewBorderLineStyleDash = 2,   //虚线
    //... 可以继续扩展
};

#endif /* QSTextViewDefine_h */
