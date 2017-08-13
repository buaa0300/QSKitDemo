//
//  QSUserModel.h
//  QSUseModelDemo
//
//  Created by zhongpingjiang on 2017/5/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSBaseModel.h"

@interface QSBookModel : QSBaseModel

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger pages;

@end

@interface QSFriendModel : QSBaseModel

@property (nonatomic,copy)NSString *name;
@property (nonatomic,assign)NSInteger age;

@end

@interface QSUserModel : QSBaseModel

@property (nonatomic,copy)NSString *userId;
@property (nonatomic,assign)NSInteger age;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,strong)NSDate *userCreated;
@property (nonatomic,strong)QSBookModel *book;
//@property (nonatomic,copy)NSArray *like;
//@property (nonatomic,copy)NSArray *friends;


@end
