//
//  ViewController.m
//  QSUseWebViewDemo
//
//  Created by zhongpingjiang on 17/5/12.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSWebView1Controller.h"
#import "QSWebView3Controller.h"

#import "QSWKWebView1Controller.h"
#import "QSCompareViewController.h"

#import "QSLoadFileViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"QSUseWebViewDemo";
    
    self.dataSource = [NSMutableArray arrayWithObjects:@[@"UIWebView实现内容落地页"],@[@"WKWebView基础使用(加载网页)",@"WebView加载速度对比",@"WKWebView加载本地H5、CSS和JS",@"WKWebView实现内容落地页",@"清除缓存"], nil];
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.dataSource objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *text = nil;
    if (section == 0) {
        text = @"  UIWebView时代";
    }else{
        text = @"  WKWebView时代";
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12];
    [label setText:text];

    return label;
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIViewController *vc = [self p_viewControllerWithIndexPath:indexPath];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[SDImageCache sharedImageCache]clearDisk];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIViewController *)p_viewControllerWithIndexPath:(NSIndexPath *)indexPath{

    UIViewController *vc = nil;
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                vc = [[QSWebView1Controller alloc]init];
                break;
                
            default:
                break;
        }
    }else if (indexPath.section == 1){
        
        switch (indexPath.row) {
            case 0:
                vc = [[QSWKWebView1Controller alloc]initWithUrlString:@"https://baidu.com"];
                break;
            case 1:
                vc = [[QSCompareViewController alloc]init];
                break;
            case 2:
                vc = [[QSLoadFileViewController alloc]init];
                break;
            case 3:
                vc = [[QSWebView3Controller alloc]init];
                
            default:
                break;
        }
    }
    
    return vc;
}



@end
