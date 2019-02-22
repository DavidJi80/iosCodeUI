//
//  LongPressGestureVC.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "LongPressGestureVC.h"

@interface LongPressGestureVC ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong) UIButton * longPressBtn;

@end

@implementation LongPressGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Long Press";
    
    _longPressBtn=[UIButton new];
    _longPressBtn.backgroundColor=[UIColor blueColor];
    _longPressBtn.frame=CGRectMake(100, 100, 150, 150);
    [_longPressBtn setTitle:@"Long Press" forState:UIControlStateNormal];
    [_longPressBtn.layer setCornerRadius:10.0];
    
    [self.view addSubview:self.longPressBtn];
    
    UILongPressGestureRecognizer * longPressGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    
    longPressGR.minimumPressDuration=3;
    
    longPressGR.allowableMovement=30;
    [self.longPressBtn addGestureRecognizer:longPressGR];
}


-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    NSLog(@"%ld",longPressGest.state);
    if (longPressGest.state==UIGestureRecognizerStateBegan){
        NSLog(@"Long Press Began!");
    }else{
        NSLog(@"Long Press End!");
    }
}


@end
