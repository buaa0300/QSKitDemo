//
//  QSShowContentView.m
//  QSUseMessageCenterDemo
//
//  Created by zhongpingjiang on 17/4/25.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSShowContentView.h"

@implementation QSContentModel

- (instancetype)initWithIndex:(NSInteger)index content:(NSString *)content{

    self = [super init];
    if (self) {
        self.index = index;
        self.content = content;
    }
    return self;
}


- (NSString *)description{
    
    return [NSString stringWithFormat:@"%d-%@",(int)self.index,self.content];
}

@end



@interface QSShowContentView()

@property (nonatomic,strong)NSMutableArray *labels;

@end

@implementation QSShowContentView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self setupLabels];
        //注册
        [self registerMessageReceiverWithKey:@"QSShowContentView"];
    }
    return self;
}

- (void)setupLabels{

    self.labels = [NSMutableArray array];
    
    CGFloat width = (self.frame.size.width - 30 - 8)/2;
    CGFloat height = self.frame.size.height/2;
    for (int i= 0; i < 4; i++) {
        
        UILabel *label = [self p_label];
        label.tag = i + 1;
        label.text = [NSString stringWithFormat:@"index %d",(int)i];
        label.frame = CGRectMake((width + 8) * (i%2) + 15, height * (i/2), width, height);
        [self.labels addObject:label];
        [self addSubview:label];
    }
}

- (UILabel *)p_label{

    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.borderWidth = 1;
    return label;
}

#pragma mark - 接收消息
- (void)qsReceiveMessage:(id)message messageId:(NSString *)msgId{

    if ([msgId isEqualToString:QSSetContentValueID]) {
        
        QSContentModel *messageModel = (QSContentModel *)message;
        if (messageModel.index >= [self.labels count]) {
            return;
        }
        
        UILabel *label = [self.labels objectAtIndex:messageModel.index];
        label.text = messageModel.content;
        
    }else if ([msgId isEqualToString:QSReSetContentValueID]){
    
    
        for (int i = 0; i < [self.labels count]; i++) {
            UILabel *label = [self.labels objectAtIndex:i];
            label.text = [NSString stringWithFormat:@"index %d",(int)i];
        }
    }
}

@end
