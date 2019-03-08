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
@property(nonatomic,strong) LineProcessView * loadProcessView;
//时间标签
@property(nonatomic,strong) UILabel * currentTimeLabel;
@property(nonatomic,strong) UILabel * totalTimeLabel;
//
@property(nonatomic,strong) UISlider * slider;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAVPlay];
    [self initView];
}

-(void)initView{
    _currentTimeLabel=[[UILabel alloc]init];
    _currentTimeLabel.frame=CGRectMake(SCREEN_WIDTH/2-35, SCREEN_HEIGHT-80, 70, 20);
    _currentTimeLabel.text=@"00:00:00";
    _currentTimeLabel.textColor=[UIColor whiteColor];
    _currentTimeLabel.font=[UIFont systemFontOfSize:(15)];
    
    _totalTimeLabel=[[UILabel alloc]init];
    _totalTimeLabel.frame=CGRectMake(SCREEN_WIDTH-70, SCREEN_HEIGHT-80, 70, 20);
    _totalTimeLabel.text=@"00:00:00";
    _totalTimeLabel.textColor=[UIColor whiteColor];
    _totalTimeLabel.font=[UIFont systemFontOfSize:(15)];
    
    _slider=[UISlider new];
    _slider.frame=CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 20);
    _slider.maximumValue=100.0;
    _slider.minimumValue=0.0;
    _slider.value=0;
    //添加事件
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    [self.view addSubview:self.currentTimeLabel];
    [self.view addSubview:self.totalTimeLabel];
    // 添加进度条
    [self.view addSubview:self.lineProcessView];
    [self.view addSubview:self.loadProcessView];
    [self.view addSubview:self.slider];
}

-(void)initAVPlay{
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
    
    /**
     插入周期时间观察器
     */
    __weak __typeof(self) weakSelf=self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 24) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSTimeInterval currentTime=CMTimeGetSeconds(time);
        NSTimeInterval totalTime=CMTimeGetSeconds(weakSelf.playerItem.duration);
        [weakSelf.lineProcessView setProcessValue:currentTime/totalTime];
        [weakSelf.currentTimeLabel setText:[weakSelf formatTimeWithTimeInterVal:currentTime]];
        [weakSelf.slider setValue:(currentTime*100)/totalTime];
    }];
    
    
}

/**
 转换时间格式的方法
 */
- (NSString *)formatTimeWithTimeInterVal:(NSTimeInterval)timeInterVal{
    int minute = 0, hour = 0, secend = timeInterVal,microsecond=0;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
    microsecond=(timeInterVal-secend)*1000;
//    return [NSString stringWithFormat:@"%02d:%02d:%02d:%3d", hour, minute, secend,microsecond];
    return [NSString stringWithFormat:@"%02d:%3d", secend,microsecond];
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

/**
 初始化进度条
 */
-(LineProcessView *)loadProcessView{
    if (!_loadProcessView) {
        _loadProcessView = [[LineProcessView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 2)];
        _loadProcessView.fillColor=[UIColor yellowColor];
        _loadProcessView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, SCREEN_HEIGHT-58);
    }
    return _loadProcessView;
}

/**
 观察者监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]){
        AVPlayerStatus status=[[change objectForKey:@"new"]intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
                CMTime duration=self.playerItem.duration;
                [self.totalTimeLabel setText:[self formatTimeWithTimeInterVal:CMTimeGetSeconds(duration)]];
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
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = self.playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：当前缓冲总时长
        //_currentLoadTimeLabel.text = [self formatTimeWithTimeInterVal:currentLoadTotalTime];
        //更新显示：视频的总时长
        //_totalNeedLoadTimeLabel.text = [self formatTimeWithTimeInterVal:CMTimeGetSeconds(self.player.currentItem.duration)];
        //更新显示：缓冲进度条的值
        [_loadProcessView setProcessValue:loadDurationSeconds/CMTimeGetSeconds(self.playerItem.duration)];
    }
    
}

/**
 UISlider事件相应方法
 */
-(void)sliderValueChanged:(UISlider *)slider{
    if(self.player.status == AVPlayerStatusReadyToPlay){
        float sliderVal=slider.value;
        Float64 duration= CMTimeGetSeconds(self.playerItem.duration);
        Float64 seetTime=((sliderVal/100) * duration);
        CMTime seekCMTime = CMTimeMake(seetTime, 1);
        [self.player seekToTime:seekCMTime completionHandler:^(BOOL finished) {
        }];
        //NSLog(@"%f",sliderVal);
    }
}




@end
