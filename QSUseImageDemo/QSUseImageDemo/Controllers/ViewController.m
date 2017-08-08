//
//  ViewController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 17/4/11.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSLocalImageController.h"
#import "QSWebImageController.h"
#import "QSCornerImageController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"QSUseImageDemo";
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"本地图片处理",@"网络图片处理",@"圆角图片的处理",nil];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            QSLocalImageController *vc1 = [[QSLocalImageController alloc]init];
            [self.navigationController pushViewController:vc1 animated:YES];
        }
            break;
        case 1:{
            QSWebImageController *vc2 = [[QSWebImageController alloc]init];
            [self.navigationController pushViewController:vc2 animated:YES];
        }
            break;
        case 2:{
            QSCornerImageController *vc3 = [[QSCornerImageController alloc]init];
            [self.navigationController pushViewController:vc3 animated:YES];
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
