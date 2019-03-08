//
//  VideoPlayerViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/5.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LineProcessview.h"

@interface VideoPlayerViewController ()

//视频播放
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
//进度条
@property(nonatomic,strong) LineProcessView * lineProcessView;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     因为是 http 的链接，所以要去 info.plist里面设置
     App Transport Security Settings
     Allow Arbitrary Loads  = YES
     */
    
    // AVPlayerItem 创建播放元素
    NSURL *url = [NSURL URLWithString:@"http://v.daqiu360.com/8253a0517d9a4be6b7c1b99f5bd3a103/87f5ccaaf62a434eb1c232d345fa7029-4eb1a625b6df899b5699af1d17ef27c2-ld.mp4"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // AVPlayer 创建播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 创建视频显示图层
    AVPlayerLayer *avLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    avLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // 把视频显示图层添加到self.view上面
    [self.view.layer addSublayer:avLayer];
    
    // 注册观察者，监听播放器属性
    // 观察Status属性，可以在加载成功之后得到视频的长度
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    __weak __typeof(self) weakSelf=self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSTimeInterval currentTime=CMTimeGetSeconds(time);
        NSTimeInterval totalTime=CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.lineProcessView setProcessValue:currentTime/totalTime];
    }];
    
    [self.view addSubview:self.lineProcessView];
    
    
    
    
}

/**
 初始化进度条
 */
-(LineProcessView *)lineProcessView{
    if (!_lineProcessView) {
        _lineProcessView = [[LineProcessView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 2)];
        _lineProcessView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, SCREEN_HEIGHT-60);
    }
    return _lineProcessView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]){
        AVPlayerStatus status=[[change objectForKey:@"new"]intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
                CMTime duration=self.playerItem.duration;
                //
                NSLog(@"-----%f",CMTimeGetSeconds(duration));
                // 开始播放
                [self.player play];
                break;
            }
            case AVPlayerStatusFailed:{
                NSLog(@"don't konow ");
                break;
            }
            case AVPlayerStatusUnknown:{
                NSLog(@"error");
                break;
            }
            default:
                break;
        }
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSLog(@"sss");
    }
    
}



@end
