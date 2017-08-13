//
//  ViewController.m
//  QSUseModelDemo
//
//  Created by zhongpingjiang on 2017/5/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "ViewController.h"
#import "QSUserModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *jsonStr = @"{\"uid\":123456,\"age\":[],\"name\":\"Harry\",\"created\":\"1965-07-31T00:00:00+0000\",\"book\":{\"name\":\"钢铁怎样炼成1\",\"pages\":345},\"like\":[\"篮球\",\"足球\",\"排球\"],\"myfriends\":[{\"name\":\"小明\",\"age\":-10},{\"name\":\"小李\",\"age\":18}]}";
    
    // Do any additional setup after loading the view, typically from a nib.
    QSUserModel *userModel = [QSUserModel yy_modelWithJSON:jsonStr];
//    NSLog(@"%@",userModel);
//    
//    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:userModel];
//    
//    [[NSUserDefaults standardUserDefaults]setObject:modelData forKey:@"userModel"];
//    
//     NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:@"userModel"];
//     QSUserModel *userModel2 =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    
//     NSLog(@"userModel = %@",userModel2);
//    
//    
//    QSUserModel *model = [userModel2 copy];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
