//
//  ViewController.m
//  QSUseTextViewDemo
//
//  Created by zhongpingjiang on 17/4/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSTextView.h"
#import "QSWebViewViewController.h"

@interface ViewController ()<QSTextViewDelegate>

@property (nonatomic,strong)QSTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone]; //必须有，
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
//    [self.textView setText:@"kjdfkjjhlsafh http://baidu.com xvdfsd 32dffsgfdg@163.com kjhfjdshf 15210560906 http://www.qq.com skdjbkdjshfldhhdjsklghdflkghjdjflkhgjdl ksdkjhflsdkjhf "];
    self.title = @"QSUseTextViewDemo";
}

- (QSTextView *)textView{

    if (!_textView) {
        
        _textView = [[QSTextView alloc]initWithFrame:CGRectMake(15, 150, SCREEN_WIDTH - 30, 36)];
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.maxNumberOfLines = 2;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor blackColor];

        //占位文本
        _textView.placeholder = @"别憋着，说两句吧。";
        _textView.placeholderFont = [UIFont systemFontOfSize:15];
        _textView.placeholderColor = [UIColor greenColor];
        
        //高度增长方向
        _textView.growDirection = QSTextViewGrowDirectionUp;
        
        //边框
        _textView.borderLineStyle = QSTextViewBorderLineStyleDash;
        _textView.borderColor = [UIColor redColor];
        _textView.borderWidth = 2.0f;
        _textView.cornerRadius = 2.0f;
        
        //支持识别和点击url
        _textView.canDetectUrl = YES;
        
        //代理
        _textView.qsDelegate = self;
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QSTextViewDelegate
- (void)textView:(QSTextView *)textView textViewHeightChange:(CGFloat)textViewHeight{

    NSLog(@"textViewHeight = %lf",textViewHeight);
}

- (void)textView:(QSTextView *)textView textChange:(NSString *)text{

//    NSLog(@"text = %@",text);
}

- (void)textView:(QSTextView *)textView openClickUrl:(NSURL *)url{
    
    NSLog(@"url = %@",[url absoluteString]);
    
    QSWebViewViewController *webVC = [[QSWebViewViewController alloc]init];
    webVC.url = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

@end
