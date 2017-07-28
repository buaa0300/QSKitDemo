//
//  QSDemoListViewController.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSDemoListViewController.h"
#import "QSDemoBigStyleCell.h"
#import "QSDemoSmallStyleCell.h"

#import "QSDemoDetailViewController.h"

static CGFloat titleID = 1;

@interface QSDemoListViewController ()

@end

@implementation QSDemoListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"列表页";
    
    self.needPullRefresh = YES;
    self.needPullToLoadMore = YES;
}

- (void)refreshDataWithStyle:(QSRefreshTableViewDataStyle)refreshStyle{

    if (refreshStyle != QSRefreshTableViewDataStyleLoadMore) {
        //清除数据
        [self.dataSource removeAllObjects];
        titleID = 1;
    }

    [self mockAndParseData];
    
    //加载数据超过40，认为数据拉取结束
    if ([self.dataSource count] >= 40) {
        [self endRefreshingWithMoreData:NO];
    }else{
        [self endRefreshingWithMoreData:YES];
    }
    
    [self.tableView reloadData];
    [self hideLoadingView];
}


- (void)mockAndParseData{

    for (NSInteger i = 0; i < 5; i++) {
        
        NSString *bigImageName = @"xihu.jpeg";
        NSString *iconImageName = @"icon.jpeg";
        NSString *title =  [NSString stringWithFormat:@"标题 %d",(int)titleID];
        NSString *subTitle = @"子标题";
        
        QSDemoBigStyleCellModel *bigCellModel = [[QSDemoBigStyleCellModel alloc]initWithbgImageName:bigImageName iconImageName:nil title:title subTitle:subTitle];
        bigCellModel.componentViewId = [NSString stringWithFormat:@"%d",(int)i + 1];
        bigCellModel.userInfo = title;
        @weakify(self);
        [bigCellModel setTapCellBlock:^(id userInfo){
            @strongify(self);
            NSLog(@"跳转%@详情页",(NSString *)userInfo);
            QSDemoDetailViewController *detailVC = [[QSDemoDetailViewController alloc]initWithTitle:(NSString *)userInfo];
            [self.navigationController pushViewController:detailVC animated:YES];
        
        }];
        [self.dataSource addObject:bigCellModel];
        
        QSDemoSmallStyleCellModel *smallCellModel = [[QSDemoSmallStyleCellModel alloc]initWithIconName:iconImageName title:title subTitle:subTitle isNotice:NO];
        smallCellModel.userInfo = title;
        smallCellModel.componentViewId = [NSString stringWithFormat:@"%d",(int)i + 1];
        [smallCellModel setNoticeActBlock:^(id userInfo){
        
            NSLog(@"%@ 被关注/取消关注",(NSString *)userInfo);
        }];
        
        [self.dataSource addObject:smallCellModel];
        
        titleID += 1;
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
