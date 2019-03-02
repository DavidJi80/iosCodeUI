//
//  GcdDemoViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/1.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "GcdDemoViewController.h"

@interface GcdDemoViewController (){
    dispatch_semaphore_t semaphoreLock;
}

@property(nonatomic,strong) UIButton * syncSerialBtn;
@property(nonatomic,strong) UIButton * asyncSerialBtn;
@property(nonatomic,strong) UIButton * syncConcurrentBtn;
@property(nonatomic,strong) UIButton * asyncConcurrentBtn;
@property(nonatomic,strong) UIButton * syncMainBtn;
@property(nonatomic,strong) UIButton * asyncMainBtn;

@property(nonatomic,assign) int count;
@property(nonatomic,strong) UILabel * showLabel;
@property(nonatomic,strong) UIButton * communicationBtn;
@property(nonatomic,strong) UIButton * barrierBtn;
@property(nonatomic,strong) UIButton * afterBtn;
@property(nonatomic,strong) UIButton * onceBtn;
@property(nonatomic,strong) UIButton * applyBtn;
@property(nonatomic,strong) UIButton * groupNotifyBtn;
@property(nonatomic,strong) UIButton * groupWaitBtn;
@property(nonatomic,strong) UIButton * groupEnterBtn;
@property(nonatomic,strong) UIButton * semaphoreSynBtn;
@property(nonatomic,strong) UIButton * threadNotSafeBtn;
@property(nonatomic,strong) UIButton * threadSafeBtn;

@end

@implementation GcdDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.count=0;
    
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
    
    _showLabel=[[UILabel alloc]init];
    _showLabel.frame=CGRectMake(30, 270, 315, 20);
    _showLabel.text=@"0";
    _showLabel.textColor=[UIColor redColor];
    _showLabel.font=[UIFont systemFontOfSize:(17)];
    
    _communicationBtn=[UIButton new];
    _communicationBtn.backgroundColor=[UIColor grayColor];
    _communicationBtn.frame=CGRectMake(30, 300, 150, 45);
    _communicationBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _communicationBtn.titleLabel.textColor=[UIColor whiteColor];
    [_communicationBtn setTitle:@"线程通讯" forState:UIControlStateNormal];
    [_communicationBtn.layer setCornerRadius:10.0];
    // 添加事件
    [_communicationBtn addTarget:self action:@selector(gcdCommunication:) forControlEvents:UIControlEventTouchUpInside];
    
    _barrierBtn=[UIButton new];
    _barrierBtn.backgroundColor=[UIColor blueColor];
    _barrierBtn.frame=CGRectMake(200, 300, 150, 45);
    _barrierBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _barrierBtn.titleLabel.textColor=[UIColor whiteColor];
    [_barrierBtn setTitle:@"栅栏" forState:UIControlStateNormal];
    [_barrierBtn.layer setCornerRadius:10.0];
    [_barrierBtn addTarget:self action:@selector(gcdBarrier:) forControlEvents:UIControlEventTouchUpInside];
    
    _afterBtn=[UIButton new];
    _afterBtn.backgroundColor=[UIColor brownColor];
    _afterBtn.frame=CGRectMake(30, 360, 150, 45);
    _afterBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _afterBtn.titleLabel.textColor=[UIColor whiteColor];
    [_afterBtn setTitle:@"延时执行" forState:UIControlStateNormal];
    [_afterBtn.layer setCornerRadius:10.0];
    [_afterBtn addTarget:self action:@selector(gcdAfter:) forControlEvents:UIControlEventTouchUpInside];
    
    _onceBtn=[UIButton new];
    _onceBtn.backgroundColor=[UIColor cyanColor];
    _onceBtn.frame=CGRectMake(200, 360, 150, 45);
    _onceBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _onceBtn.titleLabel.textColor=[UIColor whiteColor];
    [_onceBtn setTitle:@"执行一次" forState:UIControlStateNormal];
    [_onceBtn.layer setCornerRadius:10.0];
    [_onceBtn addTarget:self action:@selector(gcdOnce:) forControlEvents:UIControlEventTouchUpInside];
    
    _applyBtn=[UIButton new];
    _applyBtn.backgroundColor=[UIColor orangeColor];
    _applyBtn.frame=CGRectMake(30, 420, 150, 45);
    _applyBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _applyBtn.titleLabel.textColor=[UIColor whiteColor];
    [_applyBtn setTitle:@"快速迭代" forState:UIControlStateNormal];
    [_applyBtn.layer setCornerRadius:10.0];
    [_applyBtn addTarget:self action:@selector(gcdApply:) forControlEvents:UIControlEventTouchUpInside];
    
    _groupNotifyBtn=[UIButton new];
    _groupNotifyBtn.backgroundColor=[UIColor purpleColor];
    _groupNotifyBtn.frame=CGRectMake(30, 420, 150, 45);
    _groupNotifyBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _groupNotifyBtn.titleLabel.textColor=[UIColor whiteColor];
    [_groupNotifyBtn setTitle:@"Group Notify" forState:UIControlStateNormal];
    [_groupNotifyBtn.layer setCornerRadius:10.0];
    [_groupNotifyBtn addTarget:self action:@selector(gcdGroupNotify:) forControlEvents:UIControlEventTouchUpInside];
    
    _groupWaitBtn=[UIButton new];
    _groupWaitBtn.backgroundColor=[UIColor purpleColor];
    _groupWaitBtn.frame=CGRectMake(200, 420, 150, 45);
    _groupWaitBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _groupWaitBtn.titleLabel.textColor=[UIColor whiteColor];
    [_groupWaitBtn setTitle:@"Group Wait" forState:UIControlStateNormal];
    [_groupWaitBtn.layer setCornerRadius:10.0];
    [_groupWaitBtn addTarget:self action:@selector(gcdGroupWait:) forControlEvents:UIControlEventTouchUpInside];
    
    _groupEnterBtn=[UIButton new];
    _groupEnterBtn.backgroundColor=[UIColor purpleColor];
    _groupEnterBtn.frame=CGRectMake(30, 480, 150, 45);
    _groupEnterBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _groupEnterBtn.titleLabel.textColor=[UIColor whiteColor];
    [_groupEnterBtn setTitle:@"Group Enter" forState:UIControlStateNormal];
    [_groupEnterBtn.layer setCornerRadius:10.0];
    [_groupEnterBtn addTarget:self action:@selector(gcdGroupEnterLeave:) forControlEvents:UIControlEventTouchUpInside];
    
    _semaphoreSynBtn=[UIButton new];
    _semaphoreSynBtn.backgroundColor=[UIColor magentaColor];
    _semaphoreSynBtn.frame=CGRectMake(200, 480, 150, 45);
    _semaphoreSynBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _semaphoreSynBtn.titleLabel.textColor=[UIColor whiteColor];
    [_semaphoreSynBtn setTitle:@"Semaphore Sync" forState:UIControlStateNormal];
    [_semaphoreSynBtn.layer setCornerRadius:10.0];
    [_semaphoreSynBtn addTarget:self action:@selector(gcdSemaphoreSyn:) forControlEvents:UIControlEventTouchUpInside];
    
    _threadNotSafeBtn=[UIButton new];
    _threadNotSafeBtn.backgroundColor=[UIColor lightGrayColor];
    _threadNotSafeBtn.frame=CGRectMake(30, 540, 150, 45);
    _threadNotSafeBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _threadNotSafeBtn.titleLabel.textColor=[UIColor whiteColor];
    [_threadNotSafeBtn setTitle:@"非线程安全" forState:UIControlStateNormal];
    [_threadNotSafeBtn.layer setCornerRadius:10.0];
    [_threadNotSafeBtn addTarget:self action:@selector(gcdThreadNotSafe:) forControlEvents:UIControlEventTouchUpInside];
    
    _threadSafeBtn=[UIButton new];
    _threadSafeBtn.backgroundColor=[UIColor lightGrayColor];
    _threadSafeBtn.frame=CGRectMake(200, 540, 150, 45);
    _threadSafeBtn.titleLabel.font=[UIFont systemFontOfSize:20];
    _threadSafeBtn.titleLabel.textColor=[UIColor whiteColor];
    [_threadSafeBtn setTitle:@"线程安全" forState:UIControlStateNormal];
    [_threadSafeBtn.layer setCornerRadius:10.0];
    [_threadSafeBtn addTarget:self action:@selector(gcdThreadSafe:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.syncSerialBtn];
    [self.view addSubview:self.asyncSerialBtn];
    [self.view addSubview:self.syncConcurrentBtn];
    [self.view addSubview:self.asyncConcurrentBtn];
    [self.view addSubview:self.syncMainBtn];
    [self.view addSubview:self.asyncMainBtn];
    [self.view addSubview:self.showLabel];
    [self.view addSubview:self.communicationBtn];
    [self.view addSubview:self.barrierBtn];
    [self.view addSubview:self.afterBtn];
    [self.view addSubview:self.onceBtn];
    [self.view addSubview:self.applyBtn];
    [self.view addSubview:self.groupNotifyBtn];
    [self.view addSubview:self.groupWaitBtn];
    [self.view addSubview:self.groupEnterBtn];
    [self.view addSubview:self.semaphoreSynBtn];
    [self.view addSubview:self.threadNotSafeBtn];
    [self.view addSubview:self.threadSafeBtn];
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


/**
 GCD线程通讯
 */
-(void)gcdCommunication:(UIButton*)sender{
    //全局并发队列
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列
    dispatch_queue_t mainQueueu=dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        //异步追加任务
        for(int i=0;i<3;i++){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Asynchronize Thread:%@",[NSThread currentThread]);
            self.count++;
        }
        
        //回到主线程
        dispatch_async(mainQueueu, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Main Thread:%@",[NSThread currentThread]);
            self.showLabel.text=[NSString stringWithFormat:@"%d",self.count];
        });
    });
}

/**
 栅栏
 */
-(void)gcdBarrier:(UIButton*)sender{
    dispatch_queue_t queue=dispatch_queue_create("com.xihehang.ltx",DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //异步追加任务1
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Asynchronize Thread 1:%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        //异步追加任务2
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Asynchronize Thread 2:%@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        //追加 barrier
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Barrier Thread:%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //异步追加任务3
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Asynchronize Thread 3:%@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        //异步追加任务4
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"Asynchronize Thread 4:%@",[NSThread currentThread]);
        }
    });
}

/**
 延时执行
 */
-(void)gcdAfter:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Synchronize concurrent is begining...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after 2 %@",[NSThread currentThread]);
    });
}

/**
 执行一次
 */
-(void)gcdOnce:(UIButton*)sender{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        NSLog(@"Once %@",[NSThread currentThread]);
    });
}

/**
 快速迭代
 */
-(void)gcdApply:(UIButton*)sender{
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"apply begin");
    dispatch_apply(7, queue, ^(size_t index){
        NSLog(@"%zd--%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply end");
}


/**
 Group Notify
 */
-(void)gcdGroupNotify:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Group is begining");
    
    dispatch_group_t group =dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 1 %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 2 %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"main thread %@",[NSThread currentThread]);
        }
        
        NSLog(@"group end");
    });
}

/**
 Group Wait
 */
-(void)gcdGroupWait:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Group is begining");
    
    dispatch_group_t group =dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 1 %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 2 %@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group end");
}


/**
 Group Enter Leave
 */
-(void)gcdGroupEnterLeave:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Group is begining");
    
    dispatch_group_t group =dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 1 %@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];
            NSLog(@"group 2 %@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group end");
}


/**
 Semaphore Synchronize
 */
-(void)gcdSemaphoreSyn:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Semaphore is begining");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"Asynchronize thread %@",[NSThread currentThread]);
        
        number=100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore end,number=%d",number);
}


/**
 Thread Not Safe
 */
-(void)gcdThreadNotSafe:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Sale tickets is begining");
    
    self.count=50;
    
    dispatch_queue_t queue1=dispatch_queue_create("com.xihehang.ltx", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2=dispatch_queue_create("com.xinhehang.ltx", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf=self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
    
}

-(void)saleTicketNotSafe{
    while (1) {
        if (self.count>0){
            self.count--;
            NSLog(@"%@",[NSString stringWithFormat:@"left tickets count:%d station:%@",self.count,[NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else{
            NSLog(@"have none");
            break;
        }
    }
}

/**
 Thread Safe
 */
-(void)gcdThreadSafe:(UIButton*)sender{
    NSLog(@"The current thread is %@",[NSThread currentThread]);
    NSLog(@"Sale tickets is begining");
    
    //创建一个Semaphore，并初始化信号量为1
    semaphoreLock = dispatch_semaphore_create(1);
    
    self.count=50;
    
    dispatch_queue_t queue1=dispatch_queue_create("com.xihehang.ltx", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2=dispatch_queue_create("com.xinhehang.ltx", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf=self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
    
}

-(void)saleTicketSafe{
    while (1) {
        
        //相当于加锁。使总信号量减去1，当执行一个异步任务时，信号量就为0，阻塞了所有线程
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (self.count>0){
            self.count--;
            NSLog(@"%@",[NSString stringWithFormat:@"left tickets count:%d station:%@",self.count,[NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else{
            NSLog(@"have none");
            
            //相当于解锁。发送一个信号，让信号量加1
            dispatch_semaphore_signal(semaphoreLock);
            
            break;
        }
        //相当于解锁。发送一个信号，让信号量加1
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end
