//
//  VideoViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/10.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoPlayerViewController.h"
#import <Photos/Photos.h>

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    
    
    
}

-(void)initNavigation{
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:(UIBarButtonItemStylePlain) target:self action:@selector(next)];
    
}

-(void)next{
    VideoPlayerViewController * vc=[[VideoPlayerViewController alloc]init];
    //再跳界面之前设置跳转后隐藏tabBar
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
