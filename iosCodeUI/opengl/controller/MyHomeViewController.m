//
//  MyHomeViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/9.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "MyHomeViewController.h"
#import "DrawTriangleGLKVC.h"
#import "OfficialDemoGLKVC.h"
#import "TextureViewController.h"
#import "Texture2GLKVC.h"
#import "TextureMultiGLKVC.h"
#import "TextureSamplingGLKVC.h"

@interface MyHomeViewController ()

@property(nonatomic,strong) UIButton * glKitBtn;
@property(nonatomic,strong) UIButton * glKitTextureBtn;
@property(nonatomic,strong) UIButton * glKitTexture2Btn;
@property(nonatomic,strong) UIButton * glKitOfficialBtn;
@property(nonatomic,strong) UIButton * glKitHHBtn;
@property(nonatomic,strong) UIButton * glKitSamplingBtn;

@end

@implementation MyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _glKitOfficialBtn=[UIButton new];
    _glKitOfficialBtn.backgroundColor=[UIColor brownColor];
    _glKitOfficialBtn.frame=CGRectMake(30, 90, SCREEN_WIDTH-60, 45);
    [_glKitOfficialBtn setTitle:@"GLKit Official Demo" forState:UIControlStateNormal];
    [_glKitOfficialBtn.layer setCornerRadius:10.0];
    [_glKitOfficialBtn addTarget:self action:@selector(officialDemo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitOfficialBtn];
    
    _glKitBtn=[UIButton new];
    _glKitBtn.backgroundColor=[UIColor blueColor];
    _glKitBtn.frame=CGRectMake(30, 150, SCREEN_WIDTH-60, 45);
    [_glKitBtn setTitle:@"GLKit Draw Triangle" forState:UIControlStateNormal];
    [_glKitBtn.layer setCornerRadius:10.0];
    [_glKitBtn addTarget:self action:@selector(drawTriangle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitBtn];
    
    _glKitTextureBtn=[UIButton new];
    _glKitTextureBtn.backgroundColor=[UIColor greenColor];
    _glKitTextureBtn.frame=CGRectMake(30, 210, 145, 45);
    [_glKitTextureBtn setTitle:@"GLKit Texture" forState:UIControlStateNormal];
    [_glKitTextureBtn.layer setCornerRadius:10.0];
    [_glKitTextureBtn addTarget:self action:@selector(drawTexture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitTextureBtn];
    
    _glKitTexture2Btn=[UIButton new];
    _glKitTexture2Btn.backgroundColor=[UIColor greenColor];
    _glKitTexture2Btn.frame=CGRectMake(200, 210, 145, 45);
    [_glKitTexture2Btn setTitle:@"GLKit Texture2" forState:UIControlStateNormal];
    [_glKitTexture2Btn.layer setCornerRadius:10.0];
    [_glKitTexture2Btn addTarget:self action:@selector(drawTexture2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitTexture2Btn];
    
    _glKitHHBtn=[UIButton new];
    _glKitHHBtn.backgroundColor=[UIColor redColor];
    _glKitHHBtn.frame=CGRectMake(30, 270, 145, 45);
    [_glKitHHBtn setTitle:@"GLKit 混合" forState:UIControlStateNormal];
    [_glKitHHBtn.layer setCornerRadius:10.0];
    [_glKitHHBtn addTarget:self action:@selector(drawTextureHH:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitHHBtn];
    
    _glKitSamplingBtn=[UIButton new];
    _glKitSamplingBtn.backgroundColor=[UIColor redColor];
    _glKitSamplingBtn.frame=CGRectMake(200, 270, 145, 45);
    [_glKitSamplingBtn setTitle:@"GLKit Sampling" forState:UIControlStateNormal];
    [_glKitSamplingBtn.layer setCornerRadius:10.0];
    [_glKitSamplingBtn addTarget:self action:@selector(drawTextureSampling:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.glKitSamplingBtn];
}

-(void)drawTriangle:(UIButton*)sender{
    DrawTriangleGLKVC * vc=[[DrawTriangleGLKVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)officialDemo:(UIButton*)sender{
    OfficialDemoGLKVC * vc=[[OfficialDemoGLKVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)drawTexture:(UIButton*)sender{
    TextureViewController * vc=[[TextureViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)drawTexture2:(UIButton*)sender{
    Texture2GLKVC * vc=[[Texture2GLKVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)drawTextureHH:(UIButton*)sender{
    TextureMultiGLKVC * vc=[[TextureMultiGLKVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)drawTextureSampling:(UIButton*)sender{
    TextureSamplingGLKVC * vc=[[TextureSamplingGLKVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
