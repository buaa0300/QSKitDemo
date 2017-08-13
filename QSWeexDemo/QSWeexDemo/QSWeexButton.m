//
//  QSWeexButton.m
//  QSWeexDemo
//
//  Created by zhongpingjiang on 16/12/19.
//  Copyright © 2016年 shaoqing. All rights reserved.
//

#import "QSWeexButton.h"
#import "WXConvert.h"

@interface QSWeexButton()

@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIButton *innerButton;

@end


@implementation QSWeexButton

- (instancetype)initWithRef:(NSString *)ref type:(NSString *)type styles:(NSDictionary *)styles attributes:(NSDictionary *)attributes events:(NSArray *)events weexInstance:(WXSDKInstance *)weexInstance{

    self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance];
    if (self) {
        _title = [WXConvert NSString:attributes[@"title"]];
    }
    return self;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    self.innerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.innerButton.frame = self.view.bounds;
    [self.view addSubview:self.innerButton];
    [self.innerButton setTitle:self.title forState:UIControlStateNormal];
//    [self.innerButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

@end
