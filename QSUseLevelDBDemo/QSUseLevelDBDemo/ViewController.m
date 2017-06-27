//
//  ViewController.m
//  QSUseLevelDBDemo
//
//  Created by shaoqing on 2017/6/6.
//  Copyright © 2017年 Jiang. All rights reserved.
//

#import "ViewController.h"
#import "QSLevelDB.h"

#pragma mark - QSBookModel & QSUserModel
@interface QSBookModel : QSBaseModel

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)CGFloat price;

@end


@interface QSUserModel : QSBaseModel

@property (nonatomic,strong)QSBookModel *book;
@property (nonatomic,copy)NSString *userName;

@end

@implementation QSBookModel

@end

@implementation QSUserModel

@end


#pragma mark - ViewController
@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    QSBookModel *book = [QSBookModel new];
    book.name = @"一本书";
    book.price = 18.5f;
    
    QSUserModel *user = [[QSUserModel alloc]init];
    user.book = book;
    user.userName = @"王五";
    
    NSString *dbName = @"userdb";
    NSString *modelKey = @"user";
    
    //1、初始化
    QSLevelDB *db = [[QSLevelDB alloc]initWithDBName:dbName updatePolicy:QSLevelDBUpdatePolicyLow];
    
    //2、存数据
    [db setObject:user forKey:modelKey];
    
    //3、读数据
    NSLog(@"user model: %@", [db objectForKey:modelKey]);

    //4、删除数据库
    [QSLevelDB deleteDatabaseFromDiskWithName:dbName complete:^{
        NSLog(@"%@数据库删除了",dbName);
    }];
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
