//
//  QSTextView.m
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTextView.h"

@implementation QSTextViewUrlModel

- (instancetype)initWithUrlString:(NSString *)urlString
                         urlRange:(NSRange)urlRange{
    
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.urlRange = urlRange;
    }
    return self;
}

@end


@interface QSTextView(){
    
    UIColor *_originTextColor;
    CGFloat _originHeight;

}

/**
 边框图层
 */
@property(nonatomic,strong) CAShapeLayer *borderLayer;

/**
 *  占位文字View
 */
@property (nonatomic, strong) UITextView *placeholderView;

/**
 *  textView的高度
 */
@property (nonatomic, assign) NSInteger textViewHeight;

/**
 *  view最大高度
 */
@property (nonatomic, assign) NSInteger maxTextViewHeight;


@property (nonatomic,strong)NSMutableArray *urlModels;

@end

@implementation QSTextView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _originHeight = frame.size.height;
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 重写setText:
- (void)setText:(NSString *)text{
    
    if (!text) {
        text = @"";
    }
    
    [self.textStorage setAttributedString:[[NSAttributedString alloc]initWithString:text]];
    NSRange range = NSMakeRange(0, text.length);
    [self.textStorage addAttribute:NSFontAttributeName value:self.font range:range];
    [self textDidChange];
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
}

- (void)setTextColor:(UIColor *)textColor{

    [super setTextColor:textColor];
    if (!_originTextColor) {
        _originTextColor = textColor ? textColor : [UIColor blackColor];
    }
}

#pragma mark - 占位placeholder相关的属性
- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = placeholder;
    self.placeholderView.text = placeholder;
    [self adjustPlaceholderFrame];
}

- (void)adjustPlaceholderFrame{

    CGFloat height = ceil(self.placeholderFont.lineHeight + self.textContainerInset.top + self.textContainerInset.bottom);
    self.placeholderView.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.frame.size.width, height);
}

- (UITextView *)placeholderView{
    
    if (!_placeholderView) {
        _placeholderView = [[UITextView alloc] init];
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.font = self.font;
        _placeholderView.textColor = [UIColor lightGrayColor];
        _placeholderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    _placeholderColor = placeholderColor ? placeholderColor : [UIColor lightGrayColor];
    self.placeholderView.textColor = placeholderColor;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    
    self.placeholderView.font = placeholderFont ? placeholderFont : self.font;
}

- (UIFont *)placeholderFont{
    
    return self.placeholderView.font ? self.placeholderView.font : self.font;
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines{
    
    _maxNumberOfLines = maxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextViewHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)textDidChange{
    
    // 占位文字是否显示
    self.placeholderView.hidden = self.text.length > 0;
    if (self.placeholderView.hidden != YES) {
        [self adjustPlaceholderFrame];
    }
    
    //可以识别url
    if (self.canDetectUrl) {
        [self detectorUrlPattern];
    }

    
    //获取输入文本
    if (CHECK_VALID_DELEGATE(self.qsDelegate, @selector(textView:textChange:))) {
        [self.qsDelegate textView:self textChange:self.text];
    }
    
    //计算当前view的高度
    NSInteger calcHeight = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (_textViewHeight != calcHeight && calcHeight > _originHeight) { // 高度不一样，就改变了高度
        
        //更新高度
        _textViewHeight = calcHeight;
        
        if (calcHeight > _maxTextViewHeight && _maxTextViewHeight > 0) {
            
            self.scrollEnabled = YES;  //计算高度大于最大高度，才可以滚动
            
        }else{
            self.scrollEnabled = NO;   //不需要滚动
            //更新frame
            [self p_adjustFrameWithHeight:calcHeight];
        }

        if (CHECK_VALID_DELEGATE(self.qsDelegate, @selector(textView:textViewHeightChange:))) {
            
            [self.qsDelegate textView:self textViewHeightChange:calcHeight];
        }
    }
}

- (void)p_adjustFrameWithHeight:(CGFloat)height{

    CGRect originFrame = self.frame;
    originFrame.size = CGSizeMake(originFrame.size.width, height);

    if (self.growDirection == QSTextViewGrowDirectionUp) {
        //修改y
        originFrame.origin = CGPointMake(originFrame.origin.x, CGRectGetMaxY(self.frame) - height);
    }
    
    self.frame = originFrame;
    [self.superview layoutIfNeeded];
}

- (void)layoutSubviews{
    
    self.borderLayer.hidden = (self.borderLineStyle == QSTextViewBorderLineStyleNone ? YES : NO);
    
    if (!self.borderLayer.hidden) {
        
        self.borderLayer.strokeColor = _borderColor.CGColor ? _borderColor.CGColor : [UIColor blackColor].CGColor;
        self.borderLayer.lineWidth = _borderWidth > 0 ? _borderWidth : 1;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
        self.borderLayer.path = path.CGPath;
    }
    
    if (self.borderLineStyle == QSTextViewBorderLineStyleDash) {
        
        self.borderLayer.lineDashPattern = @[@5, @5];
        
    }else if(self.borderLineStyle == QSTextViewBorderLineStyleSolid){
        
        self.borderLayer.lineDashPattern = nil;
    }else{
        //定制其他边框线
    }
    
    [super layoutSubviews];
}

- (CAShapeLayer *)borderLayer{
    
    if (!_borderLayer) {
        
        _borderLayer = [CAShapeLayer layer];
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_borderLayer];
    }
    return _borderLayer;
}


#pragma mark - 设置边框相关的属性
- (void)setBorderLineStyle:(QSTextViewBorderLineStyle)borderLineStyle{
    
    _borderLineStyle = borderLineStyle;
    [self layoutIfNeeded];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
//    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor ? borderColor : [UIColor blackColor];
    [self layoutIfNeeded];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    
    _borderWidth = borderWidth > 0 ? borderWidth : 1;
    [self layoutIfNeeded];
}


#pragma mark - 识别URL和点击URL
/**
 识别URL
 */
- (void) detectorUrlPattern {
    
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *resultArray = [dataDetector matchesInString:self.textStorage.string options:NSMatchingReportProgress range:NSMakeRange(0, self.textStorage.string.length)];
    
    //清除
    [self.urlModels removeAllObjects];
    self.textColor = _originTextColor;
    
    //
    for (NSTextCheckingResult *result in resultArray) {
        
        NSString *urlString = [self.textStorage.string substringWithRange:result.range];
        if ([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"]) {
            
            QSTextViewUrlModel *urlModel = [[QSTextViewUrlModel alloc]initWithUrlString:urlString urlRange:result.range];
            [self.urlModels addObject:urlModel];
            
            NSMutableAttributedString *urlAttributedString = [[NSMutableAttributedString alloc]initWithString:urlString];
            [urlAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, urlString.length)];
            [urlAttributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, urlString.length)];
            [self.textStorage replaceCharactersInRange:result.range withAttributedString:urlAttributedString];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self.urlModels enumerateObjectsUsingBlock:^(QSTextViewUrlModel *urlModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        self.selectedRange = urlModel.urlRange;
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        for (UITextSelectionRect *textSelectionRect in selectionRects) {
            if (CGRectContainsPoint(textSelectionRect.rect, point)) {
                NSLog(@"click address%@",urlModel.urlString);
                if (CHECK_VALID_DELEGATE(self.qsDelegate, @selector(textView:openClickUrl:))) {
                    [self.qsDelegate textView:self openClickUrl:[NSURL URLWithString:urlModel.urlString]];
                }
                *stop = YES;
                break;
            }
        }
    }];
}

- (NSMutableArray *)urlModels{

    if (!_urlModels) {
        _urlModels = [NSMutableArray array];
    }
    return _urlModels;
}

@end
