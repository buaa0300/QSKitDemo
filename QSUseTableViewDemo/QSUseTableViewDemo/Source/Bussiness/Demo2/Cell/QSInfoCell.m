//
//  QSInfoCell.m
//  QSUseTableViewDemo
//
//  Created by zhongpingjiang on 2017/6/6.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSInfoCell.h"
#import "Demo2Config.h"

@interface QSInfoCell()

@property (nonatomic,strong)UILabel *titleLabel;

@end

@implementation QSInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self setupSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;

}

- (void)setupSubViews{

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor redColor];
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviewsWithContent:(NSString *)content{

    [self.titleLabel setText:content];
    
    CGSize textSize = [content textSizeWithFont:self.titleLabel.font];

    self.titleLabel.frame = CGRectMake((QSInfoCellHeight - textSize.width)/2, (QSHorizontalCellHeight - textSize.height)/2, textSize.width, textSize.height);
}


@end
