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
#import "PreFetchViewController.h"
#import "GcdDemoViewController.h"
#import "VideoPlayerViewController.h"
#import "ProcessViewController.h"
#import "AlertViewController.h"

@interface ViewController ()

@property(nonatomic,strong) UILabel * phoneLabel;
@property(nonatomic,strong) UITextView * phoneTextField;
@property(nonatomic,strong) UIButton * enterBtn;
@property(nonatomic,strong) UIButton * tableViewBtn;
@property(nonatomic,strong) UIButton * tableViewNavBtn;
@property(nonatomic,strong) UIButton * gestureBtn;
@property(nonatomic,strong) UIButton * gestureNavBtn;
@property(nonatomic,strong) UIButton * collectionBtn;
@property(nonatomic,strong) UIButton * preFetchCollectionBtn;
@property(nonatomic,strong) UIButton * gcdBtn;
@property(nonatomic,strong) UIButton * alertBtn;
@property(nonatomic,strong) UIButton * videoNavBtn;
@property(nonatomic,strong) UIButton * processBtn;


@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItem];
    [self initView];
}

-(void)initNavigationItem{
    
    //设置UINavigationBar的外观
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    
    /**
     设置UINavigationBar的内容
     */
    //设置标题视图
    self.navigationItem.titleView=[UIButton buttonWithType:UIButtonTypeInfoDark];
    //设置标题文字
    self.navigationItem.title=@"根控制器";
    
    //设置UIToolbar的隐藏状态
    //self.navigationController.toolbarHidden=NO;
    //设置UIToolbar的外观
    //self.navigationController.toolbar.barStyle=UIBarStyleBlackOpaque;
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
    _tableViewBtn.frame=CGRectMake(30, 150, 145, 45);
    [_tableViewBtn setTitle:@"Table View" forState:UIControlStateNormal];
    [_tableViewBtn.layer setCornerRadius:10.0];
    [_tableViewBtn addTarget:self action:@selector(openTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableViewNavBtn=[UIButton new];
    _tableViewNavBtn.backgroundColor=[UIColor blueColor];
    _tableViewNavBtn.frame=CGRectMake(200, 150, 145, 45);
    [_tableViewNavBtn setTitle:@"Table View Nav" forState:UIControlStateNormal];
    [_tableViewNavBtn.layer setCornerRadius:10.0];
    [_tableViewNavBtn addTarget:self action:@selector(navTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加按钮
    _gestureBtn=[UIButton new];
    _gestureBtn.backgroundColor=[UIColor blackColor];
    _gestureBtn.frame=CGRectMake(30, 210, 145, 45);
    [_gestureBtn setTitle:@"Gesture View" forState:UIControlStateNormal];
    [_gestureBtn.layer setCornerRadius:10.0];
    [_gestureBtn addTarget:self action:@selector(openGestureView:) forControlEvents:UIControlEventTouchUpInside];
    
    _gestureNavBtn=[UIButton new];
    _gestureNavBtn.backgroundColor=[UIColor blackColor];
    _gestureNavBtn.frame=CGRectMake(200, 210, 145, 45);
    [_gestureNavBtn setTitle:@"Gesture View Nav" forState:UIControlStateNormal];
    [_gestureNavBtn.layer setCornerRadius:10.0];
    [_gestureNavBtn addTarget:self action:@selector(openGestureNavView:) forControlEvents:UIControlEventTouchUpInside];
    
    _collectionBtn=[UIButton new];
    _collectionBtn.backgroundColor=[UIColor redColor];
    _collectionBtn.frame=CGRectMake(30, 270, 145, 45);
    [_collectionBtn setTitle:@"Collection View" forState:UIControlStateNormal];
    [_collectionBtn.layer setCornerRadius:10.0];
    [_collectionBtn addTarget:self action:@selector(openCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    _preFetchCollectionBtn=[UIButton new];
    _preFetchCollectionBtn.backgroundColor=[UIColor redColor];
    _preFetchCollectionBtn.frame=CGRectMake(200, 270, 145, 45);
    [_preFetchCollectionBtn setTitle:@"PreFetch CV" forState:UIControlStateNormal];
    [_preFetchCollectionBtn.layer setCornerRadius:10.0];
    [_preFetchCollectionBtn addTarget:self action:@selector(openPrefetchCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    _gcdBtn=[UIButton new];
    _gcdBtn.backgroundColor=[UIColor darkGrayColor];
    _gcdBtn.frame=CGRectMake(30, 330, 315, 45);
    [_gcdBtn setTitle:@"Open GCD Demo View" forState:UIControlStateNormal];
    [_gcdBtn.layer setCornerRadius:10.0];
    [_gcdBtn addTarget:self action:@selector(openGCDDemoView:) forControlEvents:UIControlEventTouchUpInside];
    
    _alertBtn=[UIButton new];
    _alertBtn.backgroundColor=[UIColor blackColor];
    _alertBtn.frame=CGRectMake(30, 390, 145, 45);
    [_alertBtn setTitle:@"Alert Controller" forState:UIControlStateNormal];
    [_alertBtn.layer setCornerRadius:10.0];
    [_alertBtn addTarget:self action:@selector(openAlertDemoView:) forControlEvents:UIControlEventTouchUpInside];
    
    _videoNavBtn=[UIButton new];
    _videoNavBtn.backgroundColor=[UIColor lightGrayColor];
    _videoNavBtn.frame=CGRectMake(200, 390, 145, 45);
    [_videoNavBtn setTitle:@"Video Player Nav" forState:UIControlStateNormal];
    [_videoNavBtn.layer setCornerRadius:10.0];
    [_videoNavBtn addTarget:self action:@selector(openVideoPlayDemoNavView:) forControlEvents:UIControlEventTouchUpInside];
    
    _processBtn=[UIButton new];
    _processBtn.backgroundColor=[UIColor magentaColor];
    _processBtn.frame=CGRectMake(30, 450, 145, 45);
    [_processBtn setTitle:@"Process Demo" forState:UIControlStateNormal];
    [_processBtn.layer setCornerRadius:10.0];
    [_processBtn addTarget:self action:@selector(openProcessDemoView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.enterBtn];
    [self.view addSubview:self.tableViewBtn];
    [self.view addSubview:self.tableViewNavBtn];
    [self.view addSubview:self.gestureBtn];
    [self.view addSubview:self.gestureNavBtn];
    [self.view addSubview:self.collectionBtn];
    [self.view addSubview:self.preFetchCollectionBtn];
    [self.view addSubview:self.gcdBtn];
    [self.view addSubview:self.alertBtn];
    [self.view addSubview:self.videoNavBtn];
    [self.view addSubview:self.processBtn];
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
    SimpleTableViewController * tableViewController=[[SimpleTableViewController alloc]init];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

-(void)navTableView:(UIButton*)sender{
    SimpleTableViewController * tableViewController=[[SimpleTableViewController alloc]init];
    [self.navigationController pushViewController:tableViewController animated:YES];
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

-(void)openGestureNavView:(UIButton*)sender{
    GestureTableViewController * vc=[[GestureTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 Open Collection View
 */
-(void)openCollectionView:(UIButton*)sender{
    CollectionViewController * vc=[[CollectionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 Open Prefetch Collection View
 */
-(void)openPrefetchCollectionView:(UIButton*)sender{
    PreFetchViewController * vc=[[PreFetchViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 Open GCD Demo View
 */
-(void)openGCDDemoView:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        GcdDemoViewController * vc=[[GcdDemoViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    });
}



-(void)openAlertDemoView:(UIButton*)sender{
    AlertViewController * vc=[[AlertViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 Open Video Play Demo View
 */
-(void)openVideoPlayDemoNavView:(UIButton*)sender{
    VideoPlayerViewController * vc=[[VideoPlayerViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 Open Process Demo View
 */
-(void)openProcessDemoView:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        ProcessViewController * vc=[[ProcessViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    });
}


@end
