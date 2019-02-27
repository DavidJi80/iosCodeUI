//
//  ViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "Person.h"
#import "SimpleTableViewController.h"
#import "GestureTableViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel * phoneLabel;
@property(nonatomic,strong) UITextView * phoneTextField;
@property(nonatomic,strong) UIButton * enterBtn;
@property(nonatomic,strong) UIButton * tableViewBtn;
@property(nonatomic,strong) UIButton * gestureBtn;
@property(nonatomic,strong) UIButton * collectionBtn;


@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];

}


-(void)initView{
    _phoneLabel=[[UILabel alloc]init];
    _phoneLabel.frame=CGRectMake(30, 90, 100, 20);
    _phoneLabel.text=@"Phone";
    _phoneLabel.textColor=[UIColor redColor];
    _phoneLabel.font=[UIFont systemFontOfSize:(17)];
    
    _phoneTextField=[UITextView new];
    _phoneTextField.frame=CGRectMake(80, 90, 100, 20);
    
    _enterBtn=[UIButton new];
    _enterBtn.backgroundColor=[UIColor greenColor];
    _enterBtn.frame=CGRectMake(200, 90, 145, 45);
    _enterBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _enterBtn.titleLabel.textColor=[UIColor whiteColor];
    [_enterBtn setTitle:@"Login" forState:UIControlStateNormal];
    [_enterBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_enterBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮，绑定事件
    _tableViewBtn=[UIButton new];
    _tableViewBtn.backgroundColor=[UIColor blueColor];
    _tableViewBtn.frame=CGRectMake(30, 150, 315, 45);
    [_tableViewBtn setTitle:@"Open Table View" forState:UIControlStateNormal];
    [_tableViewBtn.layer setCornerRadius:10.0];
    [_tableViewBtn addTarget:self action:@selector(openTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮
    _gestureBtn=[UIButton new];
    _gestureBtn.backgroundColor=[UIColor blackColor];
    _gestureBtn.frame=CGRectMake(30, 210, 315, 45);
    [_gestureBtn setTitle:@"Open Gesture View" forState:UIControlStateNormal];
    [_gestureBtn.layer setCornerRadius:10.0];
    [_gestureBtn addTarget:self action:@selector(openGestureView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮
    _collectionBtn=[UIButton new];
    _collectionBtn.backgroundColor=[UIColor redColor];
    _collectionBtn.frame=CGRectMake(30, 270, 315, 45);
    [_collectionBtn setTitle:@"Open Collection View" forState:UIControlStateNormal];
    [_collectionBtn.layer setCornerRadius:10.0];
    [_collectionBtn addTarget:self action:@selector(openCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.enterBtn];
    [self.view addSubview:self.tableViewBtn];
    [self.view addSubview:self.gestureBtn];
    [self.view addSubview:self.collectionBtn];
}

-(void)assignError{
    Person * person=[Person new];
    NSMutableString * s =[[NSMutableString alloc] initWithString:@"David ji"];
    person.nameError=s;
    NSLog(@"%p %p",person.nameError,s);
    s=nil;
    NSLog(@"%p",person.nameError);
    
}

-(void)login:(UIButton*)sender{
    NSLog(@"click do sth");
    dispatch_async(dispatch_get_main_queue(), ^{
        HomeViewController * homeViewController=[[HomeViewController alloc]init];
        homeViewController.phone=self.phoneTextField.text;
        [self presentViewController:homeViewController animated:YES completion:nil];
    });
    
}

/**
 打开Table View
 */
-(void)openTableView:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        SimpleTableViewController * tableViewController=[[SimpleTableViewController alloc]init];
        [self presentViewController:tableViewController animated:YES completion:nil];
    });
    
}

/**
 打开Gesture View
 */
-(void)openGestureView:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        GestureTableViewController * vc=[[GestureTableViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    });
    
}

/**
 Open Collection View
 */
-(void)openCollectionView:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        CollectionViewController * vc=[[CollectionViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    });
}


@end
