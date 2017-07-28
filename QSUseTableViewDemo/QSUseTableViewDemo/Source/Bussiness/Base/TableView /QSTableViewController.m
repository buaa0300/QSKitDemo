//
//  QSTableViewController.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewController.h"
#import "QSTableViewCell.h"
#import "QSTableViewCellFactory.h"
#import "MJRefresh.h"

void delayPerformBlock(NSInteger delaySeconds,void (^block)(void));

@interface QSTableViewController ()

@property (nonatomic,strong)QSFPSLabel *fpsLabel;
@property (nonatomic,strong)QSTableViewCellFactory *cellFactory;

@end

@implementation QSTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self showLoadingView];
    delayPerformBlock(2, ^{
       [self refreshDataWithStyle:QSRefreshTableViewDataStyleNormal];
    });
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (QSTableViewCellFactory *)cellFactory{
    
    if (!_cellFactory) {
        _cellFactory = [[QSTableViewCellFactory alloc]initWithTableView:self.tableView];
    }
    return _cellFactory;
}

- (void)setNeedPullRefresh:(BOOL)needPullRefresh{
    
    _needPullRefresh = needPullRefresh;
    if (_needPullRefresh) {
        [self setupRefreshHeader];
    }else{
        self.tableView.mj_header = nil;
    }
}

- (void)setNeedPullToLoadMore:(BOOL)needPullToLoadMore{
    
    _needPullToLoadMore = needPullToLoadMore;
    if (_needPullToLoadMore) {
        [self setupRefreshFooter];
    }else{
        self.tableView.mj_footer = nil;
    }
}

- (void)setupRefreshHeader{
    
    //下拉刷新
    @weakify(self);
    MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"will下拉刷新数据....");
        [self refreshDataWithStyle:QSRefreshTableViewDataStylePull];
    }];
    self.tableView.mj_header = header;
}

- (void)setupRefreshFooter{
    
    //上拉加载更多
    @weakify(self);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"will上拉加载更多数据....");
        [self refreshDataWithStyle:QSRefreshTableViewDataStyleLoadMore];
    }];
    
    [footer setTitle:@"已显示全部"forState:MJRefreshStateNoMoreData];
    
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [footer.stateLabel setTextColor:[UIColor lightGrayColor]];
}

- (void)refreshDataWithStyle:(QSRefreshTableViewDataStyle)refreshStyle{

    NSLog(@"refreshData");
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSTableViewCellModel *cellModel = [self.dataSource objectAtIndex:indexPath.section];
    return [self.cellFactory cellHeightForData:cellModel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSTableViewCellModel *cellModel = [self.dataSource objectAtIndex:indexPath.section];
    QSTableViewCell *cell = [self.cellFactory cellInstanceForData:cellModel];
    [cell layoutWithModel:cellModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return CGFLOAT_MIN;
}


/**
 结束刷新动画
 */
- (void)endRefreshingWithMoreData:(BOOL)hasMoreData{
    
    //刷新动画结束，收起来
    if (self.needPullRefresh) {
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.needPullToLoadMore) {
        
        if (hasMoreData) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

- (void)dealloc{
    
    NSLog(@"%@安全释放....",NSStringFromClass([self class]));
}


@end

/**
 延迟 若干s 执行,模拟网络延迟
 
 */
void delayPerformBlock(NSInteger delaySeconds,void (^block)(void)) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}
