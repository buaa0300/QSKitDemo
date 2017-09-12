//
//  ViewController.m
//  QSSwizzleKitDemo
//
//  Created by zhongpingjiang on 2017/9/7.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+QSSwizzleKit.h"
#import "RSSwizzle.h"
#import "NSObject+Swizzle.h"

//目标1：显示边框，显示字体，显示颜色色值
//目标2：

@interface ViewController ()

@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self config];
    
    [self.view addSubview:({
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 100, 40)];
        _label.text = @"哈哈哈";
        _label.font = [UIFont systemFontOfSize:15];
        _label.textColor = [UIColor redColor];
        _label.backgroundColor = [UIColor whiteColor];
        _label;
    })];
    
    [self.view addSubview:({
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(50, 200, 200, 30);
        [_btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"设置按钮" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _btn;
    })];
    _btn.qs_acceptEventInterval = 5;
    [self.class testClassMethod1];
    [self.class testClassMethod2];
    
    [self description];
}

- (void)replaceInstanceMethod{

    //进行实例方法的替换
    
    /**
     参数1：要被替换的函数选择器
     参数2：要被替换的函数所在的类
     参数3: block中返回替换后的方法,block参数中需要返回一个方法函数，这个函数为要替换成的函数，要和原函数类型相同。在类中的函数默认都会有一个名为self的id参数
     参数4：此次替换用到的key
     */
    [RSSwizzle swizzleInstanceMethod:@selector(touchesBegan:withEvent:) inClass:[ViewController class] newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
        return ^(__unsafe_unretained id self,NSSet* touches,UIEvent* event){
            NSLog(@"touchesBegan:withEvent:被Swizzle了");
        };
    } mode:RSSwizzleModeAlways key:NULL];
    
    
    /*
     参数1：要被替换的函数所在的类
     参数2: 要被替换的函数选择器
     参数3：返回值类型，
     参数4：参数列表
     参数5：要替换的代码块，
     参数6：执行模式，
     参数7：key值标识,RSSwizzleModeOncePerClass模式下使用，其他情况置为NULL
     */
    RSSwizzleInstanceMethod([ViewController class], @selector(touchesEnded:withEvent:), RSSWReturnType(void), RSSWArguments(NSSet<UITouch *> *touches,UIEvent *event),RSSWReplacement({
        
        NSLog(@"touchesEnded:withEvent被Swizzle了");
        RSSWCallOriginal(touches,event);
    }), RSSwizzleModeAlways, NULL);
}

- (void)replaceClassMethod{

    //进行类方法的替换
    
    /*
     参数1：要替换的函数选择器
     参数2：要替换此函数的类
     参数3：block中返回替换后的方法,block参数中需要返回一个方法函数，这个函数为要替换成的函数，要和原函数类型相同。在类中的函数默认都会有一个名为self的id参数
     */
    [RSSwizzle swizzleClassMethod:@selector(testClassMethod1) inClass:[ViewController class] newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
        
        return ^(__unsafe_unretained id self){
            NSLog(@"Class testClassMethod1 Swizzle");
        };
    }];
    
    /*
     参数1：要替换方法的类
     参数2：要替换的方法选择器
     参数3：方法的返回值类型
     参数4：方法的参数列表
     参数5：要替换的方法代码块
     */
    RSSwizzleClassMethod(NSClassFromString(@"ViewController"), NSSelectorFromString(@"testClassMethod2"), RSSWReturnType(void), RSSWArguments(), RSSWReplacement({
        //先执行原始方法
        RSSWCallOriginal();
        NSLog(@"Class testClassMethod2 Swizzle");
    }));
}


+ (void)testClassMethod1{

    NSLog(@"testClassMethod1 被 swizzle了");
}

+ (void)testClassMethod2{
    
    NSLog(@"testClassMethod2 被 swizzle了");
}
- (void)onClick:(id)sender{
    
    NSLog(@"点击了: %@",[NSDate date]);
}




- (void)config{
    
    void (^displayTextLayer)(UIView *, NSString *, NSString *) = ^void(UIView *owner, NSString *text, NSString *displayText) {
        CATextLayer *textLayer = nil;
        for (CALayer *layer in owner.layer.sublayers) {
            if([layer isKindOfClass:[CATextLayer class]])
            {
                textLayer = (CATextLayer *)layer;
                break;
            }
        }
        
        if (owner.hidden || !displayText || !text ) {
            [textLayer removeFromSuperlayer];
            owner.layer.borderWidth = 0;
            owner.layer.borderColor = [UIColor clearColor].CGColor;
            owner.clipsToBounds = YES;
            return;
        }
        
        if (!textLayer) {
            textLayer = [CATextLayer layer];
            textLayer.foregroundColor = [UIColor redColor].CGColor;
            textLayer.fontSize = 10;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [owner.layer addSublayer:textLayer];
        }
        textLayer.string = displayText;
        owner.layer.borderWidth = 0.5;
        owner.layer.borderColor = [UIColor redColor].CGColor;
        owner.clipsToBounds = NO;
        CGSize size = [textLayer preferredFrameSize];;
        textLayer.frame = CGRectMake(owner.frame.size.width, -size.height / 2, size.width, size.height);
    };
    
    RSSwizzleInstanceMethod([UILabel class],
                            @selector(layoutSubviews),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement({
        UILabel *label = self;
        
        displayTextLayer(label, label.text,[NSString stringWithFormat:@"%.1f",label.font.pointSize]
                         );
        RSSWCallOriginal();
    }), RSSwizzleModeAlways, NULL);
    
    
    RSSwizzleInstanceMethod([UIButton class],
                            @selector(layoutSubviews),
                            RSSWReturnType(void),
                            RSSWArguments(),
                            RSSWReplacement({
        UIButton *btn = self;
        displayTextLayer(btn, [btn titleForState:UIControlStateNormal],@""
                         );
        RSSWCallOriginal();
    }), RSSwizzleModeAlways, NULL);
    

    RSSwizzleInstanceMethod([UIButton class],
                            @selector(setHighlighted:),
                            RSSWReturnType(void),
                            RSSWArguments(BOOL highlighted),
                            RSSWReplacement({
        UIButton *btn = self;

        if (highlighted == YES) {
            btn.backgroundColor = [UIColor grayColor];
        }else{
            btn.backgroundColor = [UIColor whiteColor];
        }
        
        
//        if (btn && btn.highlighted) {
//            UIImage *image = [btn imageForState:btn.state];
//            // icon 图片
//            if (UIControlStateNormal == btn.state) {
//                if (image && image == [btn imageForState:UIControlStateHighlighted]) {
////                    [btn resetHighlightImageForState:btn.state];
//                }
//            } else if (UIControlStateSelected == btn.state) {
//                UIImage *nomal = [btn imageForState:UIControlStateNormal];
//                if (image &&
//                    nomal == [btn imageForState:UIControlStateHighlighted |
//                              UIControlStateSelected]) {
////                        [btn resetHighlightImageForState:btn.state];
//                    }
//            }
//            
//            //背景图片
//            UIImage *bgimage = [btn backgroundImageForState:btn.state];
//            if (UIControlStateNormal == btn.state) {
//                if (bgimage &&
//                    bgimage == [btn backgroundImageForState:UIControlStateHighlighted]) {
////                    [btn resetHighlightImageForState:btn.state];
//                }
//            } else if (UIControlStateSelected == btn.state) {
//                UIImage *nomal = [btn backgroundImageForState:UIControlStateNormal];
//                if (bgimage &&
//                    nomal == [btn backgroundImageForState:UIControlStateHighlighted |
//                              UIControlStateSelected]) {
////                        [btn resetHighlightImageForState:btn.state];
//                    }
//            }
//        }

        
        RSSWCallOriginal(highlighted);
    }), RSSwizzleModeAlways, NULL);
    
    
    
//    RSSwizzleInstanceMethod([QNAttributedLabel class],
//                            @selector(layoutSubviews),
//                            RSSWReturnType(void),
//                            RSSWArguments(),
//                            RSSWReplacement({
//        QNAttributedLabel *label = self;
//        displayTextLayer(label, [label.attributedString string], [QNDebugRuntimeSettings sharedInstance].layoutBuilderDebug ? $(@"%.1f", [label.attributedString qn_font].pointSize) : nil);
//        RSSWCallOriginal();
//    }), RSSwizzleModeAlways, NULL);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"点击开始");
//    [ViewController log];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"点击结束");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
