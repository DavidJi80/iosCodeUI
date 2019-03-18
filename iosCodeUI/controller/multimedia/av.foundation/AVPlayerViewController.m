//
//  AVPlayerViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "PhotosFrameworksUtility.h"

@interface AVPlayerViewController ()

@property(nonatomic,strong) UIButton * backBtn;

@property (nonatomic,strong) UIButton * playBtn;
@property (nonatomic,strong) UILabel * currentTimeLabel;
@property(nonatomic,strong) UISlider * slider;
@property (nonatomic,strong) UILabel * durationLabel;

//视频播放
@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * playerItem;

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initAVPlayer];
}

-(void)initView{
    _backBtn=[[UIButton alloc]init];
    _backBtn.frame=CGRectMake(10, 20, 30, 30);
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    float videoBtnHeight=SCREEN_HEIGHT-40;
    
    _playBtn=[UIButton new];
    _playBtn.frame=CGRectMake(2, videoBtnHeight, 30, 30);
    _playBtn.enabled=NO;
    [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    _currentTimeLabel=[UILabel new];
    _currentTimeLabel.frame=CGRectMake(33, videoBtnHeight+5, 34, 20);
    _currentTimeLabel.text=@"00:00";
    _currentTimeLabel.font=[UIFont systemFontOfSize:(12)];
    
    _slider=[UISlider new];
    _slider.frame=CGRectMake(67, videoBtnHeight+5, SCREEN_WIDTH-101, 20);
    _slider.maximumValue=100.0;
    _slider.minimumValue=0.0;
    _slider.value=0;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    _durationLabel=[UILabel new];
    _durationLabel.frame=CGRectMake(SCREEN_WIDTH-35, videoBtnHeight+5, 34, 20);
    _durationLabel.text=@"00:00";
    _durationLabel.font=[UIFont systemFontOfSize:(12)];
    
    
    [self.view addSubview:_backBtn];
    [self.view addSubview:_playBtn];
    [self.view addSubview:_currentTimeLabel];
    [self.view addSubview:_slider];
    [self.view addSubview:_durationLabel];
    
    
}

-(void)initAVPlayer{
    NSURL * url=[NSURL URLWithString:_fileUrl];
    //1. 创建AVAsset
    AVAsset * asset = [AVAsset assetWithURL:url];
    _durationLabel.text=[PhotosFrameworksUtility formatCMTime:asset.duration];
    
    //2. 创建AVPlayerItem
    NSArray *keyArray = @[@"tracks",@"duration",@"commonMetadata"];
    _playerItem=[AVPlayerItem playerItemWithAsset:asset automaticallyLoadedAssetKeys:keyArray];
    //2.1 注册观察者，监听播放器属性
    NSKeyValueObservingOptions options =NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew;
    //2.1.1. 观察Status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:options context:&CGLayerGetContext];
    //2.1.2. 观察loadedTimeRanges
    //[self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:options context:&CGLayerGetContext];

    //3. AVPlayer 创建播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    //3.1. 插入周期时间观察器
    __weak __typeof(self) weakSelf=self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 24) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSTimeInterval currentTime=CMTimeGetSeconds(time);
        NSTimeInterval totalTime=CMTimeGetSeconds(weakSelf.playerItem.duration);
        weakSelf.currentTimeLabel.text=[PhotosFrameworksUtility formatCMTime:time];
        [weakSelf.slider setValue:(currentTime*100)/totalTime];
    }];
    // 3. 创建视频显示图层
    AVPlayerLayer *avLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    avLayer.backgroundColor=[UIColor blackColor].CGColor;
    // 4. 把视频显示图层添加到self.view上面
    [self.view.layer addSublayer:avLayer];
    
    [self.view bringSubviewToFront:_backBtn];
}

-(void)sliderValueChanged:(UISlider *)slider{
    if(self.player.status == AVPlayerStatusReadyToPlay){
        [self.player pause];
        _playBtn.selected=NO;
        float sliderVal=slider.value;
        Float64 duration= CMTimeGetSeconds(self.playerItem.duration);
        Float64 seetTime=((sliderVal/100) * duration);
        CMTime seekCMTime = CMTimeMake(seetTime, 1);
        [self.player seekToTime:seekCMTime completionHandler:^(BOOL finished) {
        }];
    }
}

-(void)playVideo:(UIButton*)sender{
    if ((self.player.status == AVPlayerStatusReadyToPlay)&&(!_playBtn.selected)){
        _playBtn.selected=YES;
        [self.player play];
    }else{
        _playBtn.selected=NO;
        [self.player pause];
    }
}


/**
 观察者监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context != &CGLayerGetContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"status"]){
        AVPlayerItemStatus status = AVPlayerItemStatusUnknown;
        NSNumber *statusNumber = change[NSKeyValueChangeNewKey];
        if ([statusNumber isKindOfClass:[NSNumber class]]) {
            status = statusNumber.integerValue;
        }
        switch (status) {
            case AVPlayerStatusReadyToPlay:
                [self prepareToPlay];
                break;
            case AVPlayerStatusFailed:
                NSLog(@"don't konow ");
                break;
            case AVPlayerStatusUnknown:
                NSLog(@"error");
                break;
            default:
                break;
        }
    }
    
}

-(void)prepareToPlay{
    _playBtn.enabled=YES;
}

/**
 重载viewWillAppear方法，隐藏TabBar
 */
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden=NO;
    
    [self.player pause];
    [self.player setRate:0];
    //[self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRange" context:&CGLayerGetContext];
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:&CGLayerGetContext];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.playerItem = nil;
    self.player = nil;
}

-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
