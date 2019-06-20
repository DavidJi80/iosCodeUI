//
//  CoreImageViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/6/20.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CoreImageViewController.h"

@interface CoreImageViewController ()

@property(nonatomic,strong) CIContext * context;
@property(nonatomic,strong) CIImage* originalCIImage;
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UIImageView * outputImageView;
@property(nonatomic,strong) UIButton * filterBtn;
@property(nonatomic,strong) UIButton * bloomFilterBtn;

@end

@implementation CoreImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    self.context = [CIContext context];
    
    _imageView=[UIImageView new];
    _imageView.frame=CGRectMake(10, 80, SCREEN_WIDTH/2-20, (SCREEN_HEIGHT-100)/2);
    _imageView.backgroundColor=UIColor.redColor;
    _imageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    _outputImageView=[UIImageView new];
    _outputImageView.frame=CGRectMake(SCREEN_WIDTH/2+10, 80, SCREEN_WIDTH/2-20, (SCREEN_HEIGHT-100)/2);
    _outputImageView.backgroundColor=UIColor.redColor;
    _outputImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.outputImageView];
    
    _filterBtn=[UIButton new];
    _filterBtn.backgroundColor=[UIColor blueColor];
    _filterBtn.frame=CGRectMake(30, (SCREEN_HEIGHT-100)/2+100, SCREEN_WIDTH-60, 45);
    [_filterBtn setTitle:@"CISepiaTone Filter" forState:UIControlStateNormal];
    [_filterBtn.layer setCornerRadius:10.0];
    [_filterBtn addTarget:self action:@selector(filterImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.filterBtn];
    
    _bloomFilterBtn=[UIButton new];
    _bloomFilterBtn.backgroundColor=[UIColor greenColor];
    _bloomFilterBtn.frame=CGRectMake(30, (SCREEN_HEIGHT-100)/2+160, SCREEN_WIDTH-60, 45);
    [_bloomFilterBtn setTitle:@"CIBloom Filter" forState:UIControlStateNormal];
    [_bloomFilterBtn.layer setCornerRadius:10.0];
    [_bloomFilterBtn addTarget:self action:@selector(bloomFilter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bloomFilterBtn];
    
    NSURL* imageURL = [[NSBundle mainBundle] URLForResource:@"coreimage" withExtension:@"jpeg"];
    self.originalCIImage = [CIImage imageWithContentsOfURL:imageURL];
    self.imageView.image = [UIImage imageWithCIImage:self.originalCIImage];
}

- (CIImage*) sepiaFilterImage: (CIImage*)inputImage withIntensity:(CGFloat)intensity{
    CIFilter* sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:inputImage forKey:kCIInputImageKey];
    [sepiaFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    return sepiaFilter.outputImage;
}

-(void)filterImage:(UIButton*)sender{
    CIImage* sepiaCIImage = [self sepiaFilterImage:self.originalCIImage withIntensity:0.9];
    self.outputImageView.image = [UIImage imageWithCIImage:sepiaCIImage];
}

- (CIImage*) bloomFilterImage: (CIImage*)inputImage withIntensity:(CGFloat)intensity radius:(CGFloat)radius{
    CIFilter* bloomFilter = [CIFilter filterWithName:@"CIBloom"];
    [bloomFilter setValue:inputImage forKey:kCIInputImageKey];
    [bloomFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    [bloomFilter setValue:@(radius) forKey:kCIInputRadiusKey];
    return bloomFilter.outputImage;
}


-(void)bloomFilter:(UIButton*)sender{
    CIImage* bloomCIImage = [self bloomFilterImage:self.originalCIImage withIntensity:1 radius:10];
    self.outputImageView.image = [UIImage imageWithCIImage:bloomCIImage];
}




@end
