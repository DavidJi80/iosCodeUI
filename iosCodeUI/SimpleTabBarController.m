//
//  SimpleTabBarController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleTabBarController.h"
#import "ViewController.h"
#import "SimpleNavigationController.h"

@interface SimpleTabBarController ()

@end

@implementation SimpleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *homeController = [[ViewController alloc]init];
    homeController.title = @"首页";
    homeController.tabBarItem.image = [UIImage imageNamed:@"Home"];
    homeController.tabBarItem.selectedImage = [UIImage imageNamed:@"Home"];
    
    SimpleNavigationController * nav = [[SimpleNavigationController alloc]initWithRootViewController:homeController];
    [self addChildViewController:nav];
    
}

@end
