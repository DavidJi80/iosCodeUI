//
//  SimpleTabBarController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleTabBarController.h"
#import "ViewController.h"
#import "MyHomeViewController.h"

@interface SimpleTabBarController ()

@end

@implementation SimpleTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 通过appearance统一设置UITabbarItem的文字属性
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
    // 设置文字大小
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 设置文字的前景色
    
    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    UITabBarItem * item = [UITabBarItem appearance];
    // 设置appearance
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
//    // 设置文字属性
//    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12.0];
//    // 设置文字的前景色
//    attrs[NSForegroundColorAttributeName] = [UIColor redColor];
    
    ViewController *homeController = [[ViewController alloc]init];
    homeController.title = @"首页";
    homeController.tabBarItem.image = [UIImage imageNamed:@"Home"];
    homeController.tabBarItem.selectedImage = [UIImage imageNamed:@"Home"];
    //homeController.view.backgroundColor=[UIColor yellowColor];
//    [homeController.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:homeController];
    [self addChildViewController:nav];
    
    MyHomeViewController * myHomeVC=[MyHomeViewController new];
    myHomeVC.title=@"我的";
    myHomeVC.tabBarItem.image = [UIImage imageNamed:@"Home"];
    myHomeVC.tabBarItem.selectedImage = [UIImage imageNamed:@"Home"];
    
    UINavigationController * myNav=[[UINavigationController alloc]initWithRootViewController:myHomeVC];
    [self addChildViewController:myNav];
    
}

@end
