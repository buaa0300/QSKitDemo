//
//  QSTableViewController.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewController.h"
#import "QSTableViewCell.h"
#import "MJRefresh.h"

@interface QSTableViewController ()

@property (nonatomic,strong)QSFPSLabel *fpsLabel;

@end

@implementation QSTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
        
    if (!self.isLazyLoadData) {
        [self refreshDataWithStyle:QSRefreshTableViewDataStyleNormal];
    }
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
//        delayPerformBlock(2,^{
            [self refreshDataWithStyle:QSRefreshTableViewDataStylePull];
//        });
    }];
    self.tableView.mj_header = header;
}

- (void)setupRefreshFooter{
    
    //上拉加载更多
    @weakify(self);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        NSLog(@"will上拉加载更多数据....");
//        delayPerformBlock(2,^{
            [self refreshDataWithStyle:QSRefreshTableViewDataStyleLoadMore];
//        });
    }];
    
    [footer setTitle:@"已显示全部"forState:MJRefreshStateNoMoreData];
    
    footer.refreshingTitleHidden = YES;
    self.tableView.mj_footer = footer;
    [footer.stateLabel setTextColor:[UIColor lightGrayColor]];
}


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
    Class cellClass = [self p_cellClassWithName:cellModel.cellClassName];
    if (cellClass && [cellClass isSubclassOfClass:[QSTableViewCell class]]){
        
        return [cellClass cellHeightWithModel:cellModel];
    }
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSTableViewCell *cell = nil;
    QSTableViewCellModel *cellModel = [self.dataSource objectAtIndex:indexPath.section];
    
    NSString *cellClassName = cellModel.cellClassName;
    cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
    Class cellClass = [self p_cellClassWithName:cellClassName];
    
    if (!cell && cellClass && [cellClass isSubclassOfClass:[QSTableViewCell class]]) {
        
        cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassName];
        if (cell && cellModel && CHECK_VALID_DELEGATE(self.controllerDelegate, @selector(tableView:cellInstance:cellModel:))) {
            [self.controllerDelegate tableView:tableView cellInstance:cell cellModel:cellModel];
        }
    }
    
    //safe,make sure not return nil
    if (!cell) {
        cell = [[QSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QSTableViewCell"];
    }
    
    [cell layoutWithModel:cellModel];
    return cell;
}

- (Class)p_cellClassWithName:(NSString *)cellClassName{
    
    Class class = nil;
    if (CHECK_VALID_STRING(cellClassName)) {
        class = NSClassFromString(cellClassName);
    }
    return class;
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
