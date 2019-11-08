//
//  AutoLayoutVC.m
//  iosCodeUI
//
//  Created by mac on 2019/10/16.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AutoLayoutVC.h"

@interface AutoLayoutVC ()

@end

@implementation AutoLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *blueView=[UIView new];
    blueView.backgroundColor=UIColor.blueColor;
    blueView.frame=CGRectMake(20,100,100,50);
    [self.view addSubview:blueView];
    
    UIView *redView=[UIView new];
    redView.backgroundColor=UIColor.redColor;
    redView.frame=CGRectMake(20,100,100,50);
    
    [self.view addSubview:redView];
    
    UIButton *blueButton=[UIButton new];
}



@end
