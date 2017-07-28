//
//  QSShow1Controller.m
//  QSRotationScreenDemo
//
//  Created by zhongpingjiang on 2017/6/14.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSShow1Controller.h"

@interface QSShow1Controller ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation QSShow1Controller

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"展示（支持横屏）";

    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    //开启和监听设备旋转 通知
//    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    //界面旋转方向改变 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleStatusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewWillLayoutSubviews{

    

}

- (void)dealloc{

    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *content = [NSString stringWithFormat:@"项目%d",(int)indexPath.row];
    
    cell.textLabel.text = content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

//是否支持旋转
- (BOOL)shouldAutorotate{
    
    return NO;
}

//支持的屏幕旋转种类
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
//    return UIInterfaceOrientationMaskLandscape;
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}


#pragma mark - 处理屏幕旋转
- (void)handleStatusBarOrientationChange: (NSNotification *)notification{
  
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = NO;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            isLandscape = NO;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isLandscape = YES;
            break;
        
        default:
            break;
    }
    if (isLandscape) {
        self.tableView.frame = CGRectMake(0, 0, SCREEN_MAX, SCREEN_MIN - 44);
    }else{
        self.tableView.frame = CGRectMake(0, 0, SCREEN_MIN, SCREEN_MAX - 64);
    }
    
    [self.tableView reloadData];
}






//- (void)handleDeviceOrientationChange:(NSNotification *)notification{
//
//    NSLog(@"device = %@",notification.userInfo);
//    //1.获取 当前设备 实例
//    UIDevice *device = [UIDevice currentDevice] ;
//    switch (device.orientation) {
//        case UIDeviceOrientationFaceUp:
//            NSLog(@"屏幕朝上平躺");
//            break;
//            
//        case UIDeviceOrientationFaceDown:
//            NSLog(@"屏幕朝下平躺");
//            break;
//            
//            //系統無法判斷目前Device的方向，有可能是斜置
//        case UIDeviceOrientationUnknown:
//            NSLog(@"未知方向");
//            break;
//            
//        case UIDeviceOrientationLandscapeLeft:
//            NSLog(@"屏幕向左横置");
//            break;
//            
//        case UIDeviceOrientationLandscapeRight:
//            NSLog(@"屏幕向右橫置");
//            break;
//            
//        case UIDeviceOrientationPortrait:
//            NSLog(@"屏幕直立");
//            break;
//            
//        case UIDeviceOrientationPortraitUpsideDown:
//            NSLog(@"屏幕直立，上下顛倒");
//            break;
//            
//        default:
//            NSLog(@"无法辨识");
//            break;
//    }
//
//}


@end
