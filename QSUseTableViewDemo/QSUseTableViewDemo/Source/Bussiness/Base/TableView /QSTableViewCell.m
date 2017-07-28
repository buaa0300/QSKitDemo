//
//  QSTableViewCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 17/4/1.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSTableViewCell.h"



static NSString *const kCellModelSuffix = @"Model";

@implementation QSTableViewCellModel

- (instancetype)init{
    
    self = [super init];
    if (self) {
        NSString *modelClassName = NSStringFromClass([self class]);
        NSInteger count = [kCellModelSuffix length];
        if ([modelClassName hasSuffix:kCellModelSuffix] && [modelClassName length] > count) {
            self.cellClassName = [modelClassName substringToIndex:[modelClassName length] - count];
        }else{
            self.cellClassName = @"QSTableViewCell";
        }
    }
    return self;
}

- (Class)cellClass{

    Class class = Nil;
    if (CHECK_VALID_STRING(self.cellClassName)) {
        class = NSClassFromString(self.cellClassName);
    }
    return class;
}

@end

#pragma mark - QSBaseCell

@interface QSTableViewCell()



@end


@implementation QSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapCellAction)];
        tap.numberOfTapsRequired = 1;
        self.contentView.userInteractionEnabled = YES;
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutWithModel:(id)model{
    
//    NSLog(@"更新页面数据");
    
    
    
}

+ (CGFloat)cellHeightWithModel:(id)model{
    
    if (CHECK_VALID_MODEL(model, [QSTableViewCellModel class])) {
        
        QSTableViewCellModel *cellModel = (QSTableViewCellModel *)model;
        return cellModel.cellHeight > 0 ? cellModel.cellHeight : 44.0f;
    }
    return 0.01f;
}

- (void)onTapCellAction{

    NSLog(@"处理cell点击");
}



@end
