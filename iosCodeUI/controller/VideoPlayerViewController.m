//
//  VideoPlayerViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/5.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerViewController ()



@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     因为是 http 的链接，所以要去 info.plist里面设置
     App Transport Security Settings
     Allow Arbitrary Loads  = YES
     */
    
    //1. AVPlayerItem 创建播放元素
    NSURL *url = [NSURL URLWithString:@"http://v.daqiu360.com/8253a0517d9a4be6b7c1b99f5bd3a103/87f5ccaaf62a434eb1c232d345fa7029-4eb1a625b6df899b5699af1d17ef27c2-ld.mp4"];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    //2. AVPlayer 创建播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    //3. 创建视频显示图层
    AVPlayerLayer *avLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity=AVLayerVideoGravityResizeAspect;
    avLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //4. 把视频显示图层添加到self.view上面
    [self.view.layer addSublayer:avLayer];
    //5. 开始播放
    [self.player play];
}



@end
