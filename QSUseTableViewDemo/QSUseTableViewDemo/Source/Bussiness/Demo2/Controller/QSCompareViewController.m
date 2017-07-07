//
//  QSCompareController.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 2017/6/5.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSCompareViewController.h"
#import "QSHorizontalCell.h"
#import "Demo2Config.h"

@interface QSCompareViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)UITableView *horizonalTableView;

@end

@implementation QSCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"对比页";
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor = [UIColor whiteColor];

    //横滑
    self.horizonalTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, QSHorizontalCellHeight) style:UITableViewStylePlain];
    [self.horizonalTableView setDelegate:self];
    [self.horizonalTableView setDataSource:self];
    [self.view addSubview:self.horizonalTableView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, QSHorizontalCellHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - QSHorizontalCellHeight) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    /**
     *  添加 设备旋转 通知
     *
     *  当监听到 UIDeviceOrientationDidChangeNotification 通知时，调用handleDeviceOrientationDidChange:方法
     *  @param handleDeviceOrientationDidChange: handleDeviceOrientationDidChange: description
     *
     *  @return return value description
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _horizonalTableView){
    
        return 1;
    }

    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return QSHorizontalCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QSTableViewCell"];
    //safe,make sure not return nil
    if (!cell) {
        cell = [[QSHorizontalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QSTableViewCell"];
    }
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
//    [cell layoutWithModel:nil];
    

    cell.contentView.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (tableView == _tableView) {
        return 20.0f;
    }
    return 0.01f;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView == _horizonalTableView) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%d",(int)section + 1];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //禁止向下回弹
    if (scrollView == _horizonalTableView) {
        if (scrollView.contentOffset.y <=QSHorizontalCellHeight) {
            scrollView.contentOffset = CGPointZero;
        }
    }
    
    if (scrollView == _tableView) {
        if (scrollView.contentOffset.y <= 0) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    //1.获取 当前设备 实例
    UIDevice *device = [UIDevice currentDevice] ;
    
    
    
    
    /**
     *  2.取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:
            NSLog(@"屏幕朝上平躺");
            break;
            
        case UIDeviceOrientationFaceDown:
            NSLog(@"屏幕朝下平躺");
            break;
            
            //系統無法判斷目前Device的方向，有可能是斜置
        case UIDeviceOrientationUnknown:
            NSLog(@"未知方向");
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            NSLog(@"屏幕向左横置");
//            break;
            
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"屏幕向右橫置");
            NSLog(@"SCREEN_WIDTH = %lf",CGRectGetWidth([[UIScreen mainScreen] bounds]));
            NSLog(@"SCREEN_Height = %lf",CGRectGetHeight([[UIScreen mainScreen] bounds]));
            self.horizonalTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, QSHorizontalCellHeight);
            self.tableView.frame = CGRectMake(0, QSHorizontalCellHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - QSHorizontalCellHeight + 20);
            self.tableView.backgroundColor = [UIColor lightGrayColor];

            break;
            
        case UIDeviceOrientationPortrait:
            NSLog(@"屏幕直立");
            
            
            
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"屏幕直立，上下顛倒");
            NSLog(@"SCREEN_WIDTH = %lf",CGRectGetWidth([[UIScreen mainScreen] bounds]));
            NSLog(@"SCREEN_Height = %lf",CGRectGetHeight([[UIScreen mainScreen] bounds]));
            self.horizonalTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, QSHorizontalCellHeight);
            self.tableView.frame = CGRectMake(0, QSHorizontalCellHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - QSHorizontalCellHeight);
            self.tableView.backgroundColor = [UIColor lightGrayColor];
            break;
            
        default:
            NSLog(@"无法辨识");
            break;
    }
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
