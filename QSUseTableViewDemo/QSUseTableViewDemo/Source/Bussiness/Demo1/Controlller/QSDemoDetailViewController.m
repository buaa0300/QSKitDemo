//
//  QSDemoDetailViewController.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDemoDetailViewController.h"
#import "QSDemoBigStyleCell.h"
#import "QSDemoContentCell.h"

@interface QSDemoDetailViewController (){

    NSString *_vcTitle;

}

@end

@implementation QSDemoDetailViewController

- (instancetype)initWithTitle:(NSString *)vcTitle{

    self = [super init];
    if (self) {
        _vcTitle = vcTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"%@-详情页",_vcTitle];
    //默认不开启下拉刷新和上拉加载
}

- (void)refreshDataWithStyle:(QSRefreshTableViewDataStyle)refreshStyle{

    [self mockAndParseData];
    [self.tableView reloadData];
}

- (void)mockAndParseData{
    
    NSString *bigImageName = @"xihu.jpeg";
    NSString *iconImageName = @"icon.jpeg";
    NSString *subTitle = @"子标题";
    
    QSDemoBigStyleCellModel *bigCellModel = [[QSDemoBigStyleCellModel alloc]initWithbgImageName:bigImageName iconImageName:iconImageName title:_vcTitle subTitle:subTitle];
    [self.dataSource addObject:bigCellModel];
    
    QSDemoContentCellModel *contentCellModel1 = [[QSDemoContentCellModel alloc]initWithTitle:@"特征1" content:@"在iOS的开发中，遇到大量的UI工作，这些UI工作简言之就是在画“页面”，“页面”的复杂度有高有低，复杂度高的比如绘制直播画面，复杂度低的比如绘制一个关于页面，一个logo和几行文本就搞定了。"];
    [contentCellModel1 calcCellHeight];
    [self.dataSource addObject:contentCellModel1];

    QSDemoContentCellModel *contentCellModel2 = [[QSDemoContentCellModel alloc]initWithTitle:@"特征2" content:@"但是呢，我们在实际工作中遇到的UI工作大部分是中等复杂度的页面，比如某某列表页、某某详情页。在列表页对于每个列表项有若干...."];
    [contentCellModel2 calcCellHeight];
    [self.dataSource addObject:contentCellModel2];
    
    QSDemoContentCellModel *contentCellModel3 = [[QSDemoContentCellModel alloc]initWithTitle:@"特征3" content:@""];
    [contentCellModel3 calcCellHeight];
    [self.dataSource addObject:contentCellModel3];
    
    QSDemoContentCellModel *contentCellModel4 = [[QSDemoContentCellModel alloc]initWithTitle:@"特征4" content:@"这里主要是为了帮助绘制大部分如列表页和详情页这类的中等复杂度页面"];
     [contentCellModel4 calcCellHeight];
    [self.dataSource addObject:contentCellModel4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
