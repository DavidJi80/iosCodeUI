//
//  ViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel * phoneLabel;

@property(nonatomic,strong) UITextView * phoneTextField;

@property(nonatomic,strong) UIButton * enterBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneLabel=[[UILabel alloc]init];
    _phoneLabel.frame=CGRectMake(30, 130, 100, 20);
    _phoneLabel.text=@"Phone";
    _phoneLabel.textColor=[UIColor redColor];
    _phoneLabel.font=[UIFont systemFontOfSize:(17)];
    
    _phoneTextField=[UITextView new];
    _phoneTextField.frame=CGRectMake(80, 130, 270, 20);
    
    _enterBtn=[UIButton new];
    _enterBtn.backgroundColor=[UIColor greenColor];
    _enterBtn.frame=CGRectMake(30, 255, 315, 45);
    _enterBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _enterBtn.titleLabel.textColor=[UIColor whiteColor];
    [_enterBtn setTitle:@"Login" forState:UIControlStateNormal];
    [_enterBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_enterBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.enterBtn];
}

-(void)login:(UIButton*)sender{
    NSLog(@"click do sth");
    dispatch_async(dispatch_get_main_queue(), ^{
        HomeViewController * homeViewController=[[HomeViewController alloc]init];
        homeViewController.phone=self.phoneTextField.text;
        [self presentViewController:homeViewController animated:YES completion:nil];
    });
    
}


@end
