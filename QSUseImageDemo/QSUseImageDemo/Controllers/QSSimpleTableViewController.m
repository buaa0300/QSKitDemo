//
//  QSSimpleTableViewController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/10.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSSimpleTableViewController.h"
#import "QSTableViewCell1.h"
#import "QSTableViewCell2.h"
#import "QSTableViewCell3.h"
#import "QSTableViewCell4.h"

@interface QSSimpleTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation QSSimpleTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"cell点按态和不透明图冲突";
    
    // Do any additional setup after loading the view, typically from a nib.

    NSString *urlString = @"http://img6.faloo.com/Picture/0x0/0/183/183388.jpg";
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"",@"",@"",urlString,nil];
    [self.view addSubview:self.tableView];
//    
    [self.tableView registerClass:[QSTableViewCell1 class] forCellReuseIdentifier:@"QSTableViewCell1"];
    [self.tableView registerClass:[QSTableViewCell2 class] forCellReuseIdentifier:@"QSTableViewCell2"];
    [self.tableView registerClass:[QSTableViewCell3 class] forCellReuseIdentifier:@"QSTableViewCell3"];
    [self.tableView registerClass:[QSTableViewCell4 class] forCellReuseIdentifier:@"QSTableViewCell4"];
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
    
    return [QSTableViewCell1 cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"QSTableViewCell%ld",(long)indexPath.section + 1];
    QSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell layoutSubviewsWithUrl:[NSURL URLWithString:[self.dataSource objectAtIndex:indexPath.section]]];
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

    UIViewController *vc = [[UIViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end


