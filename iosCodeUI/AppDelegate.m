//
//  AppDelegate.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SimpleTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[self tabbedApp];
    [self navigationApp];
    return YES;
}

-(void)tabbedApp{
    // 创建UIWindows对象
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    // 设置UIWindows的背景色
    self.window.backgroundColor=[UIColor whiteColor];
    // 创建ViewController
    //ViewController *vc=[[ViewController alloc]init];
    // 设置root view
    self.window.rootViewController =[SimpleTabBarController new];
    // 设置window为主window且可见
    [self.window makeKeyAndVisible];
}

-(void)navigationApp{
    // 创建UIWindows对象
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    // 设置UIWindows的背景色
    self.window.backgroundColor=[UIColor whiteColor];
    // 创建ViewController
    ViewController *vc=[[ViewController alloc]init];
    // 创建导航控制器
    UINavigationController * navc=[[UINavigationController alloc]initWithRootViewController:vc];
    // 设置root view
    self.window.rootViewController =navc;
    // 设置window为主window且可见
    [self.window makeKeyAndVisible];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
