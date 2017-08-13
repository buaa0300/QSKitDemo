//
//  ViewController.m
//  QSUseLabelDemo
//
//  Created by zhongpingjiang on 17/4/11.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSShowTextCell.h"

#define QSTextInitContentLines 3
#define QSTextContentNoLimitLines 0

static NSString * const kShowTextCellReuseIdentifier = @"QSShowTextCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger lines;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.lines = 2;
    self.navigationItem.title = @"QSUseLabelDemo";
    
    NSArray *contentArr = [[NSMutableArray alloc]initWithObjects:
                       @"在iOS中，有时候显示文本，需要设置文本的行间距、指定显示行数、文本内容超出显示行数，省略结尾部分的内容以……方式省略。这些都可以使用UILabel来是实现，前提是你扩展了UILabel这方面的特性。",
                       @"这个Demo是使用UITableView组织文本的显示。每一个cell可以显示title和content，cell中先指定content文本显示3行，行间距是5.0f。",
                       @"如果content文本用3行不能全部显示，文本下面出现“显示文本”按钮，点击“显示全文”按钮，可以展开全部文本，此时按钮变成“收起全文”；点击按钮可以收起全文，依旧显示3行，按钮恢复成“显示全文”。",
                       @"如果content文本用3行可以全部显示，不会出现按钮。",
                       @"content显示的文本可以设置行数值，行间距值，收起全文和展开全文都是利用**UILabel的扩展特性**来实现的。content显示的文本可以设置行数值，行间距值，收起全文和展开全文都是利用**UILabel的扩展特性**来实现的。",nil];
    
    for (NSInteger i = 0; i < [contentArr count]; i++) {
        
        QSShowTextCellModel *cellModel = [[QSShowTextCellModel alloc]initWithContent:contentArr[i]  contentLines:QSTextInitContentLines isOpen:NO];
        [self.dataSource addObject:cellModel];
    }
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
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
    
    return [QSShowTextCell cellHeightWithModel:[self p_modelAtIndexPath:indexPath]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01f;
    }
    return 10.00f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QSShowTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kShowTextCellReuseIdentifier];
    if (!cell) {
        
        cell = [[QSShowTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShowTextCellReuseIdentifier];
        
        __weak typeof(self) weakSelf = self;
        [cell setOpenContentBlock:^(QSShowTextCellModel *cellModel){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (cellModel.isOpen) {
                cellModel.contentLines = QSTextContentNoLimitLines;  //0,不限制行数
            }else{
                cellModel.contentLines = QSTextInitContentLines;     //3,3行
            }
            NSInteger newxtRow = (indexPath.row + 1) >= [self.dataSource count] - 1 ?  [self.dataSource count] - 1 :(indexPath.row + 1);
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newxtRow  inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    [cell layoutSubviewsWithModel:[self p_modelAtIndexPath:indexPath]];
    
    return cell;
    
}

- (QSShowTextCellModel *)p_modelAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.dataSource objectAtIndex:indexPath.row];
}

- (void)p_removeTextAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"row = %ld,section = %ld",indexPath.row,indexPath.section);
    [self.dataSource removeObjectAtIndex:indexPath.row];
}




@end
