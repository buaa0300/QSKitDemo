//
//  QSTextView.h
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSTextViewDefine.h"

/**
 * 1、支持: placeholder
 * 2、支持：文字高度改变textview的高度
 * 3、支持虚线边框
 * 4、自动识别url，并可以点击打开url
 *
 *************/

@interface QSTextViewUrlModel : NSObject

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,assign)NSRange urlRange;

- (instancetype)initWithUrlString:(NSString *)urlString
                         urlRange:(NSRange)urlRange;

@end


@class QSTextView;

@protocol QSTextViewDelegate <NSObject>

@optional

- (void)textView:(QSTextView *)textView textViewHeightChange:(CGFloat)textViewHeight;

- (void)textView:(QSTextView *)textView textChange:(NSString *)text;

- (void)textView:(QSTextView *)textView openClickUrl:(NSURL *)url;

@end


@interface QSTextView : UITextView

/**
 自定义的代理
 */
@property (nonatomic,weak)id<QSTextViewDelegate> qsDelegate;

#pragma mark - 占位placeholder相关的属性
/**
 *  占位文字
 */
@property (nonatomic, strong) NSString *placeholder;

/**
 *  占位文字颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 占位文字字体
 */
@property (nonatomic, strong) UIFont *placeholderFont;

#pragma mark - 高度相关的属性

/**
 增长方向
 */
@property (nonatomic,assign)QSTextViewGrowDirection growDirection;

/**
 *  textView最大行数
 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

/**
 *  textView的高度
 */
@property (nonatomic, assign,readonly) NSInteger textViewHeight;

#pragma mark - 设置边框相关的属性

@property (nonatomic,assign)QSTextViewBorderLineStyle borderLineStyle;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIColor *borderColor;

@property (nonatomic, assign) CGFloat borderWidth;

#pragma mark - 是否识别url
@property (nonatomic, assign) BOOL canDetectUrl;


@end
