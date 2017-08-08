//
//  QSCornerImageController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/8/8.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSCornerImageController.h"
#import "QSProcessImageManager.h"

@interface QSCornerImageController ()

@property (nonatomic,strong)UIImageView *originImageView;
@property (nonatomic,strong)UIImageView *scaleImageView;

@end

@implementation QSCornerImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.title = @"圆角图片处理";
    
    NSString *imageName = @"icon_lena@3x.png";  //icon.jpeg
    UIImage *originImage = [UIImage imageNamed:imageName];
    
    [self.view addSubview:({
        _originImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 0, 100, 100)];
        _originImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _originImageView.layer.borderWidth = 1.0f;
        _originImageView.image = originImage;
        _originImageView;
    })];
    
    [self.view addSubview:({
        _scaleImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, CGRectGetMaxY(_originImageView.frame) + 15, 100, 100)];
        _scaleImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _scaleImageView.layer.borderWidth = 1.0f;
        _scaleImageView;
    })];
    
//    QSProcessImageConfig *config = [QSProcessImageConfig roundCofigWithOutputSize:_scaleImageView.frame.size];
    QSProcessImageConfig *config = [[QSProcessImageConfig alloc]initWithOutputSize:_scaleImageView.frame.size cornerRadius:30 corners:QSProcessImageCornerLeftTop | QSProcessImageCornerLeftBottom];
    _scaleImageView.image =  [QSProcessImageManager processImage:originImage config:config];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    NSLog(@"释放");
    
}


/*
 *UIRectCorner:圆角位置
 *     = 1 << 0,     //左上角
 *    = 1 << 1,     //右上角
 *  = 1 << 2,     //左下角
 * = 1 << 3,     //右下角
 *        //所有角
 *
 */
//rectangleCorner = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 260, 40, 40) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(4, 4)];
//[rectangleCorner stroke];

- (UIImage *)p_processImageWithOriginImage:(UIImage *)originImage{
    
    //开启绘制（参考size,cornerRadius)
    UIRectCorner corners = 123;
//    UIRectCornerTopLeft | UIRectCornerTopRight;
    NSLog(@"corners = %lud",(unsigned long)corners);
    UIImage *newImage = nil;
    if ((corners & UIRectCornerTopLeft) || (corners & UIRectCornerTopRight) || (corners & UIRectCornerBottomLeft) || (corners & UIRectCornerBottomRight) || (corners & UIRectCornerAllCorners)) {
  
        CGFloat cornerRadius = 50;
        CGRect rect = CGRectMake(0, 0, originImage.size.width, originImage.size.height);
        //    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        
        UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        UIBezierPath *bgRect = [UIBezierPath bezierPathWithRect:rect];
        [[UIColor whiteColor] setFill];
        [bgRect fill];
        
        //裁剪
        [roundRectPath addClip];
        //绘制
        [originImage drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    

    
    return newImage;
}

@end
