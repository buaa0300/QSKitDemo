//
//  ViewController.m
//  QSUseNetworkDemo
//
//  Created by shaoqing on 17/4/5.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QCBaseRequest+Create.h"

@interface ViewController ()

@property (nonatomic,strong)UIButton *startBtn;
@property (nonatomic,strong)UIButton *endBtn;
@property (nonatomic,strong)QCBaseRequest *request; //普通请求
@property (nonatomic,strong)QCBaseRequest *pagingRequest;  //分页请求


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.startBtn];
    [self.view addSubview:self.endBtn];
    NSString *urlString = @"http://test.app.com/index.php?";
    self.request = [QCBaseRequest normalRequestWithUrl:urlString parameters:nil requestMethodType:QCRequestMethodTypeGET];
    self.pagingRequest = [QCBaseRequest pagingRequestWithMethodType:QCRequestMethodTypeGET parameters:nil];
}

- (UIButton *)startBtn{

    if (!_startBtn) {
        _startBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 100, 150, 40)];
        [_startBtn setTitle:@"发送请求" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_startBtn addTarget:self action:@selector(onStartAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (UIButton *)endBtn{
 
    if (!_endBtn) {
        _endBtn = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 150, 40)];
        [_endBtn setTitle:@"结束请求" forState:UIControlStateNormal];
        [_endBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_endBtn addTarget:self action:@selector(onEndAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _endBtn;
}

- (void)onStartAction{

//    NSString *urlString = @"http://test.app.com/index.php?";
//    [self pageRequestWithUrlString:urlString];
    [self normalRequest];
}

- (void)normalRequest{

    [self.request startWithCompleteBlock:^(BOOL isSuccess, id  _Nullable responseObj, NSString * _Nonnull errorDesc) {
        
        NSLog(@"isSuccess = %d && errorDesc = %@",isSuccess,errorDesc);
        //TODO 数据解析....
        
    }];
}

- (void)pageRequestWithUrlString:(NSString *)urlString{

    [self.pagingRequest startPagingRequestUrl:urlString completeBlock:^(BOOL isSuccess, BOOL hasMoreData, BOOL isReset, id  _Nullable dataArray, NSString * _Nonnull errorDesc) {
        
        NSLog(@"isSuccess = %d && hasMoreData = %d && isReset = %d",isSuccess,hasMoreData,isReset);
        NSLog(@"&& errorDesc = %@",errorDesc);
    }];
}

- (void)onEndAction{

    [self.request cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
