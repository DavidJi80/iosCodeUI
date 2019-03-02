//
//  GcdDemoViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/1.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "GcdDemoViewController.h"

@interface GcdDemoViewController ()

@property(nonatomic,strong) UIButton * syncSerialBtn;
@property(nonatomic,strong) UIButton * asyncSerialBtn;
@property(nonatomic,strong) UIButton * syncConcurrentBtn;
@property(nonatomic,strong) UIButton * asyncConcurrentBtn;
@property(nonatomic,strong) UIButton * syncMainBtn;
@property(nonatomic,strong) UIButton * asyncMainBtn;

@end

@implementation GcdDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _syncSerialBtn=[UIButton new];
    _syncSerialBtn.backgroundColor=[UIColor greenColor];
    _syncSerialBtn.frame=CGRectMake(30, 90, 150, 45);
    _syncSerialBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _syncSerialBtn.titleLabel.textColor=[UIColor whiteColor];
    [_syncSerialBtn setTitle:@"同步串行" forState:UIControlStateNormal];
    [_syncSerialBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_syncSerialBtn addTarget:self action:@selector(syncSerialQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    _asyncSerialBtn=[UIButton new];
    _asyncSerialBtn.backgroundColor=[UIColor greenColor];
    _asyncSerialBtn.frame=CGRectMake(200, 90, 150, 45);
    _asyncSerialBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _asyncSerialBtn.titleLabel.textColor=[UIColor whiteColor];
    [_asyncSerialBtn setTitle:@"异步串行" forState:UIControlStateNormal];
    [_asyncSerialBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_asyncSerialBtn addTarget:self action:@selector(asyncSerialQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    _syncConcurrentBtn=[UIButton new];
    _syncConcurrentBtn.backgroundColor=[UIColor redColor];
    _syncConcurrentBtn.frame=CGRectMake(30, 150, 150, 45);
    _syncConcurrentBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _syncConcurrentBtn.titleLabel.textColor=[UIColor whiteColor];
    [_syncConcurrentBtn setTitle:@"同步并行" forState:UIControlStateNormal];
    [_syncConcurrentBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_syncConcurrentBtn addTarget:self action:@selector(syncConcurrentQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    _asyncConcurrentBtn=[UIButton new];
    _asyncConcurrentBtn.backgroundColor=[UIColor redColor];
    _asyncConcurrentBtn.frame=CGRectMake(200, 150, 150, 45);
    _asyncConcurrentBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _asyncConcurrentBtn.titleLabel.textColor=[UIColor whiteColor];
    [_asyncConcurrentBtn setTitle:@"异步并行" forState:UIControlStateNormal];
    [_asyncConcurrentBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_asyncConcurrentBtn addTarget:self action:@selector(asyncConcurrentQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    _syncMainBtn=[UIButton new];
    _syncMainBtn.backgroundColor=[UIColor blackColor];
    _syncMainBtn.frame=CGRectMake(30, 210, 150, 45);
    _syncMainBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _syncMainBtn.titleLabel.textColor=[UIColor whiteColor];
    [_syncMainBtn setTitle:@"同步主队列" forState:UIControlStateNormal];
    [_syncMainBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_syncMainBtn addTarget:self action:@selector(syncMainQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    _asyncMainBtn=[UIButton new];
    _asyncMainBtn.backgroundColor=[UIColor blackColor];
    _asyncMainBtn.frame=CGRectMake(200, 210, 150, 45);
    _asyncMainBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _asyncMainBtn.titleLabel.textColor=[UIColor whiteColor];
    [_asyncMainBtn setTitle:@"异步主队列" forState:UIControlStateNormal];
    [_asyncMainBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_asyncMainBtn addTarget:self action:@selector(asyncMainQueue:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.syncSerialBtn];
    [self.view addSubview:self.asyncSerialBtn];
    [self.view addSubview:self.syncConcurrentBtn];
    [self.view addSubview:self.asyncConcurrentBtn];
    [self.view addSubview:self.syncMainBtn];
    [self.view addSubview:self.asyncMainBtn];
}

/**
 同步执行串行队列
 不会开启新线程，在当前线程中执行任务，不会开启新线程，执行完一个任务再执行下一个任务
 */
-(void)syncSerialQueue:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_queue_create("com.xihehang.ltx",DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

/**
 异步执行串行队列
 开启一个新线程，任务在新线程中执行，任务串行执行，一个任务完成后，再执行下一个任务
 */
-(void)asyncSerialQueue:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_queue_create("com.xihehang.ltx",DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

/**
 同步执行并发队列
 在当前线程中执行任务，不会开启新线程，执行完一个任务再执行下一个任务
 */
-(void)syncConcurrentQueue:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_queue_create("com.xihehang.ltx",DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

/**
 异步执行并发队列
 可以开启多个线程，任务交替执行
 */
-(void)asyncConcurrentQueue:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_queue_create("com.xihehang.ltx",DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

/**
 同步执行主队列
 互相等待会卡死
 */
-(void)syncMain:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

/**
 使用 NSThread 的 detachNewThreadSelector 方法会创建线程，并自动启动线程执行selector 任务
 */
-(void)syncMainQueue:(UIButton*)sender{
    [NSThread detachNewThreadSelector:@selector(syncMain:) toTarget:self withObject:nil];
}

/**
 异步执行主队列
 在主线程中执行，执行完一个再执行下一个
 */
-(void)asyncMainQueue:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    dispatch_queue_t queue=dispatch_get_main_queue();
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue,^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    NSLog(@"Synchronize concurrent is end.");
}

@end
