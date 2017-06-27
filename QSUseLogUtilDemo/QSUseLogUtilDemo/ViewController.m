//
//  ViewController.m
//  QSUseLogUtilDemo
//
//  Created by zhongpingjiang on 17/5/2.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSLogView.h"

@interface ViewController ()

@property (strong,nonatomic)UILabel *label;
@property (strong,nonatomic)UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"QSUseLogUtilDemo";
    [self.view addSubview:({
    
        _label = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREEN_WIDTH - 40)/2, SCREEN_WIDTH - 30, 40)];
        _label.textColor = [UIColor blueColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:18.0];
        _label.text = @"这就是一个空页面";
        _label;
    })];
    
    
    [self.view addSubview:({
        
        _btn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2,CGRectGetMaxY(_label.frame) + 15 , 250, 40)];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btn setTitle:@"太碍眼了！请求关闭LogView" forState:UIControlStateNormal];
        [_btn setTitle:@"太需要了！请求打开LogView" forState:UIControlStateSelected];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(closeLogView:) forControlEvents:UIControlEventTouchUpInside];
        _btn.backgroundColor = [UIColor yellowColor];
        _btn;
    })];
    
    QSLOG(@"嘻嘻嘻");
    QSLOG(@"嘻嘻嘻%@嘻嘻嘻", @"哈哈哈");
}

- (void)closeLogView:(UIButton *)btn{

    btn.selected = !btn.selected;
    if (btn.selected) {
#if DEBUG
        [QSLogView close];
#endif
    }else{
        
#if DEBUG
        [QSLogView show];
#endif
    }
    NSString *statusStr = (btn.selected == 1)? @"选中":@"未选中";
    QSLOG(@"按钮的状态:[%d]:%@",(int)btn.selected,statusStr);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
