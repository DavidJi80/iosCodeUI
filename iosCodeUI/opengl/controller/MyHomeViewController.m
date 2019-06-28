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

@interface MyHomeViewController ()

@property(nonatomic,strong) UIButton * glKitBtn;
@property(nonatomic,strong) UIButton * glKitTextureBtn;
@property(nonatomic,strong) UIButton * glKitTexture2Btn;
@property(nonatomic,strong) UIButton * glKitOfficialBtn;

@end

@implementation MyHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _glKitOfficialBtn=[UIButton new];
    _glKitOfficialBtn.backgroundColor=[UIColor yellowColor];
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

@end
