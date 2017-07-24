//
//  QSLocalImageController.m
//  QSUseImageDemo
//
//  Created by zhongpingjiang on 2017/7/24.
//  Copyright © 2017年 shaoqing. All rights reserved.
//

#import "QSLocalImageController.h"

@interface QSLocalImageController ()

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UIImageView *originImageView;
@property (nonatomic,strong)UIImageView *scaleImageView;
@property (nonatomic,strong)UIImageView *clipImageView;
@property (nonatomic,strong)UIImageView *roundImageView;

@end

@implementation QSLocalImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    self.navigationItem.title = @"本地图片处理";
    
    NSString *imageName = @"icon_lena@3x.png";  //icon.jpeg
    UIImage *originImage = [UIImage imageNamed:imageName];
    NSLog(@"%@缩放前大小:%@ ,scale = %lf", imageName,NSStringFromCGSize(originImage.size),originImage.scale);
    
    [self.view addSubview:({
        
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView;
    })];
    
    
    [self.scrollView addSubview:({
        _originImageView = [[UIImageView alloc]init];
        _originImageView.image = originImage;
        _originImageView;
    })];
    
    [self adjustImageView:self.originImageView originY:0];
    
    //缩放
    UIImage *scaleImage = [self testScaleImage:originImage];
    NSLog(@"%@尺寸缩放后大小:%@ ,scale = %lf", imageName,NSStringFromCGSize(scaleImage.size),scaleImage.scale);
    [self.scrollView addSubview:({
        _scaleImageView = [[UIImageView alloc]init];
        _scaleImageView.image = scaleImage;
        _scaleImageView;
    })];
    
    [self adjustImageView:self.scaleImageView originY:CGRectGetMaxY(_originImageView.frame) + 15];
    
    //裁剪
    UIImage *clipImage = [self testClipImage:originImage];
    NSLog(@"%@裁剪后大小:%@ ,scale = %lf", imageName,NSStringFromCGSize(clipImage.size),clipImage.scale);
    [self.scrollView addSubview:({
        _clipImageView = [[UIImageView alloc]init];
        _clipImageView.image = clipImage;
        _clipImageView;
    })];
    [self adjustImageView:self.clipImageView originY:CGRectGetMaxY(_scaleImageView.frame) + 15];
    
    //圆角
    UIImage *roundImage = [self testClipRoundCornerImage:originImage];
    [self.scrollView addSubview:({
        _roundImageView = [[UIImageView alloc]init];
        _roundImageView.image = roundImage;
        _roundImageView.layer.cornerRadius = roundImage.size.height/2;
        _roundImageView.backgroundColor = [UIColor whiteColor];
        _roundImageView;
    })];
    NSLog(@"%@裁剪圆角后大小:%@ ,scale = %lf", imageName,NSStringFromCGSize(roundImage.size),roundImage.scale);
    [self adjustImageView:self.roundImageView originY:CGRectGetMaxY(_clipImageView.frame) + 15];
    
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.roundImageView.frame) + 100)];
    //压缩
    [self testCompressImage];
    
}

- (void)adjustImageView:(UIImageView *)imageView originY:(CGFloat)originY{
    
    CGSize imageSize = imageView.image.size;
    imageView.frame = CGRectMake((SCREEN_WIDTH - imageSize.width)/2, originY, imageSize.width, imageSize.height);
    imageView.layer.borderColor = [UIColor blueColor].CGColor;
    imageView.layer.borderWidth = 1.0f;
    
    
}

#pragma mark - test methods
- (UIImage *)testScaleImage:(UIImage *)originImage{
    
    UIImage *scaleImage = [originImage scaleImageWithSize:CGSizeMake(100, 100)];
    //    UIImage *scaleImage = [originImage scaleImageWithScale:0.5];
    //    UIImage *scaleImage = [originImage scaleImageToTargetWidth:100];
    //    UIImage *scaleImage = [originImage scaleImageToTargetHeight:100];
    return scaleImage;
}

- (UIImage *)testClipImage:(UIImage *)originImage{
    
    UIImage *clipImage = [originImage clipImageWithRect:CGRectMake(0, 0, originImage.size.width/2, originImage.size.height)];
    return clipImage;
}

- (UIImage *)testClipRoundCornerImage:(UIImage *)originImage {
    
    UIImage *roundImage = [originImage clipImageWithCornerRadius:originImage.size.height/2 bgColor:[UIColor whiteColor]];
    return roundImage;
}

- (void)testCompressImage{
    
    UIImage *image = [UIImage imageNamed:@"image1_3.6MB_4032 × 3024.jpeg"];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"image1_3.6MB_4032 × 3024" ofType:@"jpeg"];
    NSString *lengthStr = [[NSData dataWithContentsOfFile:filePath] lengthString];
    
    NSDate *startDate = [NSDate date];
    
    NSLog(@"\n\n压缩前尺寸大小:%@ ,质量大小:%@ ,scale = %lf", NSStringFromCGSize(image.size),lengthStr,image.scale);
    UIImage *newImage = [image compressImageToTargetPx:1080];
    NSLog(@"尺寸压缩后 的 尺寸大小:%@ ,scale = %lf", NSStringFromCGSize(newImage.size),newImage.scale);
    NSData *imageData = [newImage compressImageToTargetKB:100];
    
    NSTimeInterval cost = [[NSDate date]timeIntervalSinceDate:startDate];
    NSLog(@"质量压缩后 的 质量大小:%@,花费时间 = %.3lfs",[imageData lengthString],cost);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
