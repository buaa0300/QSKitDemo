//
//  QSHorizontalCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 2017/6/5.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSHorizontalCell.h"
#import "QSInfoCell.h"
#import "Demo2Config.h"

@interface QSHorizontalCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation QSHorizontalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.dataSource = [NSMutableArray arrayWithObjects:@"哈1",@"哈2",@"哈3",@"哈4",@"哈5",@"哈6",@"哈7",@"哈8",@"哈9",nil];
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doWithOffsetX:) name:@"dddd" object:nil];
    }
    return self;
}

- (void)setupSubViews{

    [self.contentView addSubview:self.tableView];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat offset = (SCREEN_WIDTH - QSHorizontalCellHeight)/2;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(offset,-offset, QSHorizontalCellHeight, SCREEN_WIDTH) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
//        _tableView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI/2);
        _tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return QSInfoCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"sssss";
    QSInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[QSInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.transform = CGAffineTransformMakeRotation(M_PI/2);
        
    }
    [cell layoutSubviewsWithContent:[self.dataSource objectAtIndex:indexPath.row]];
    if (indexPath.row %2 == 0) {
        cell.backgroundColor = [UIColor brownColor];
    }else{
        cell.backgroundColor = [UIColor yellowColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击%d",(int)[indexPath row]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0){
    
        return 100;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if(section == 0){
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 100)];
        view.backgroundColor = [UIColor grayColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:view.bounds];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 1;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"属性";
        titleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);

        [view addSubview:titleLabel];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

- (void)setContentOffsetY:(CGFloat)offsetY{

    self.tableView.contentOffset = CGPointMake(0, offsetY);
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGPoint offset = scrollView.contentOffset;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dddd" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:offset.y], @"offsetX",nil]];
}

- (void)doWithOffsetX:(NSNotification *)notification{

    NSNumber *num = [notification.userInfo objectForKey:@"offsetX"];
    CGFloat off = [num floatValue];
    [self setContentOffsetY:off];
}



@end
