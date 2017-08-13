//
//  ViewController.m
//  QSWeexDemo
//
//  Created by zhongpingjiang on 16/12/16.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSWeexViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.title = @"QSWeexDemo";
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"Weex的测试页面",@"文章详情页",nil];
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
            
            QSWeexViewController *vc = [[QSWeexViewController alloc]init];
            vc.url = [self urlWithJSFileName:@"hello-weex"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            
            QSWeexViewController *vc = [[QSWeexViewController alloc]init];
            vc.url = [self urlWithJSFileName:@"paper-detail"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSURL *)urlWithJSFileName:(NSString *)jsFileName{
    
    BOOL isLocalFile = YES;
    NSString *urlString = @"";
    if (isLocalFile) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:jsFileName ofType:@"js"];
        urlString = [NSString stringWithFormat:@"file://%@",filePath];
    }else{
        urlString = [NSString stringWithFormat:@"http://127.0.0.1:8081/weex_tmp/h5_render/%@.js?wsport=8082",jsFileName];
    }
    NSLog(@"urlString = %@",urlString);
    return [NSURL URLWithString:urlString];
}


//- (NSURL *)urlWithJSFileName:(NSString *)jsFileName{
//
//    NSString *urlString = @"";
//#if DEBUG
//    urlString = [NSString stringWithFormat:@"http://127.0.0.1:8081/weex_tmp/h5_render/%@.js?wsport=8082",jsFileName];
//#elif
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:jsFileName ofType:@"js"];
//    urlString = [NSString stringWithFormat:@"file://%@",filePath];
//#endif
//    NSLog(@"urlString = %@",urlString);
//    return [NSURL URLWithString:urlString];
//}

@end
