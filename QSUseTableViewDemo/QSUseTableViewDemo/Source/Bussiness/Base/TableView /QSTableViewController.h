//
//  QSTableViewController.h
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSTableViewDefine.h"
#import "QSFPSLabel.h"

@class QSTableViewCell;
@class QSTableViewCellModel;

@protocol QSTableViewControllerDelegate <NSObject>

@optional;

- (void)tableView:(UITableView *)tableView cellInstance:(QSTableViewCell *)cellInstance cellModel:(QSTableViewCellModel *)cellModel;

@end

/**
 支持配置上拉加载和下拉刷新
 */
@interface QSTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


/**
 UITableView实例，cell容器
 */
@property (nonatomic,strong)UITableView *tableView;

/**
 tableView对应的数据源
 */
@property (nonatomic,strong)NSMutableArray *dataSource;

/**
 代理协议
 */
@property (nonatomic,weak)id<QSTableViewControllerDelegate> controllerDelegate;


/**
 延迟加载数据
 */
@property (nonatomic,assign)BOOL isLazyLoadData;

/**
 配置下拉刷新
 */
@property (nonatomic,assign)BOOL needPullRefresh;


/**
 配置上拉加载
 */
@property (nonatomic,assign)BOOL needPullToLoadMore;


/**
 结束刷新动画
 */
- (void)endRefreshingWithMoreData:(BOOL)hasMoreData;


#pragma mark - 子类实现
/**
 刷新数据
 */
- (void)refreshDataWithStyle:(QSRefreshTableViewDataStyle)refreshStyle;

@end
