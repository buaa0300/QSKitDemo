//
//  QSUserModel.m
//  QSUseModelDemo
//
//  Created by zhongpingjiang on 2017/5/26.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSUserModel.h"

@implementation QSBookModel


@end

@implementation QSFriendModel



@end

@implementation QSUserModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper{

    //model属性名 : key
    return @{@"userId":@"uid",
             @"userName":@"name",
             @"age":@"age",
             @"userCreated":@"created",
             @"friends":@"myfriends",
             };
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass{

    return @{@"friends":QSFriendModel.class};

}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"test1", @"test2"];
//}
//// 如果实现了该方法，则处理过程中不会处理该列表外的属性。
//+ (NSArray *)modelPropertyWhitelist {
//    return @[@"name"];
//}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    
    NSNumber *timestamp = dic[@"timestamp"];
    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
    _userCreated = [NSDate dateWithTimeIntervalSince1970:timestamp.floatValue];
    
    return YES;
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
//    if (!_userCreated)
//        return NO;
//    dic[@"timestamp"] = @(n.timeIntervalSince1970);
//    
//    return YES;
//}

@end
