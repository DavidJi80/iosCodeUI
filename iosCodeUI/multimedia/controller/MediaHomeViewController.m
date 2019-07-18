//
//  MediaHomeViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "MediaHomeViewController.h"
#import "VideoViewController.h"
#import "PhotosViewController.h"
#import "AVCaptureViewController.h"
#import "CoreImageViewController.h"
#import "AVCaptureCoreImageVC.h"

@interface MediaHomeViewController ()

//UIImagePickerController
@property(nonatomic,strong) UIButton * imgPickerBtn;
//photos frameworks
@property(nonatomic,strong) UIButton * photosBtn;
//AVFoundation Capture
@property(nonatomic,strong) UIButton * captureBtn;
//Core Image Foundation
@property(nonatomic,strong) UIButton * coreImageBtn;
@property(nonatomic,strong) UIButton * coreImageCaptureBtn;

@end

@implementation MediaHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgPickerBtn=[UIButton new];
    _imgPickerBtn.backgroundColor=[UIColor blueColor];
    _imgPickerBtn.frame=CGRectMake(30, 90, SCREEN_WIDTH-60, 45);
    [_imgPickerBtn setTitle:@"UIImagePickerController" forState:UIControlStateNormal];
    [_imgPickerBtn.layer setCornerRadius:10.0];
    [_imgPickerBtn addTarget:self action:@selector(openVideoView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.imgPickerBtn];
    
    _photosBtn=[UIButton new];
    _photosBtn.backgroundColor=[UIColor redColor];
    _photosBtn.frame=CGRectMake(30, 150, SCREEN_WIDTH-60, 45);
    [_photosBtn setTitle:@"Photos Frameworks" forState:UIControlStateNormal];
    [_photosBtn.layer setCornerRadius:10.0];
    [_photosBtn addTarget:self action:@selector(openPhotosFrame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photosBtn];
    
    _captureBtn=[UIButton new];
    _captureBtn.backgroundColor=[UIColor greenColor];
    _captureBtn.frame=CGRectMake(30, 210, SCREEN_WIDTH-60, 45);
    [_captureBtn setTitle:@"AVFoundation Capture" forState:UIControlStateNormal];
    [_captureBtn.layer setCornerRadius:10.0];
    [_captureBtn addTarget:self action:@selector(openCapture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.captureBtn];
    
    _coreImageBtn=[UIButton new];
    _coreImageBtn.backgroundColor=[UIColor grayColor];
    _coreImageBtn.frame=CGRectMake(30, 270, SCREEN_WIDTH-60, 45);
    [_coreImageBtn setTitle:@"Core Image Foundation" forState:UIControlStateNormal];
    [_coreImageBtn.layer setCornerRadius:10.0];
    [_coreImageBtn addTarget:self action:@selector(openCoreImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coreImageBtn];
    
    _coreImageCaptureBtn=[UIButton new];
    _coreImageCaptureBtn.backgroundColor=[UIColor darkGrayColor];
    _coreImageCaptureBtn.frame=CGRectMake(30, 330, SCREEN_WIDTH-60, 45);
    [_coreImageCaptureBtn setTitle:@"Capture & Core Image" forState:UIControlStateNormal];
    [_coreImageCaptureBtn.layer setCornerRadius:10.0];
    [_coreImageCaptureBtn addTarget:self action:@selector(openCoreImageCapture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.coreImageCaptureBtn];
    
}

-(void)openVideoView:(UIButton*)sender{
    VideoViewController * vc=[[VideoViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openPhotosFrame:(UIButton*)sender{
    PhotosViewController * vc=[[PhotosViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openCapture:(UIButton*)sender{
    AVCaptureViewController * vc=[[AVCaptureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openCoreImage:(UIButton*)sender{
    CoreImageViewController * vc=[[CoreImageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)openCoreImageCapture:(UIButton*)sender{
    AVCaptureCoreImageVC * vc=[[AVCaptureCoreImageVC alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}

@end
