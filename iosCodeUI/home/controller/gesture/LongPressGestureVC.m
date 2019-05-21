//
//  LongPressGestureVC.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "LongPressGestureVC.h"

@interface LongPressGestureVC ()

@property(nonatomic,strong) UIButton * longPressBtn;

@end

@implementation LongPressGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title=@"Long Press";
    
    [self initNavigationItem];
    
    
    _longPressBtn=[UIButton new];
    _longPressBtn.backgroundColor=[UIColor blueColor];
    _longPressBtn.frame=CGRectMake(100, 100, 150, 150);
    [_longPressBtn setTitle:@"Long Press" forState:UIControlStateNormal];
    [_longPressBtn.layer setCornerRadius:10.0];
    
    [self.view addSubview:self.longPressBtn];
    
    UILongPressGestureRecognizer * longPressGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    
//    longPressGR.minimumPressDuration=3;
    
    longPressGR.allowableMovement=30;
    [self.longPressBtn addGestureRecognizer:longPressGR];
}

-(void)initNavigationItem{
    self.navigationItem.title=@"Table View";
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"首页" style:(UIBarButtonItemStylePlain) target:self action:@selector(goHome)];
}

-(void)goHome{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    NSLog(@"%ld",longPressGest.state);
    if (longPressGest.state==UIGestureRecognizerStateBegan){
        NSLog(@"Long Press Began!");
    }else if(longPressGest.state==UIGestureRecognizerStateEnded){
        NSLog(@"Long Press End!");
    }
}


@end
