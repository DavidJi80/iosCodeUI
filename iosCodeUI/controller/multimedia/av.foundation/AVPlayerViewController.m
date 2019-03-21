//
//  AVPlayerViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "PhotosFrameworksUtility.h"
#import "VideoCollectionView.h"
#import "LineProcessView.h"


@interface AVPlayerViewController (){
    
}

@property(nonatomic,assign) CMTime allTotalTime;

@property(nonatomic,strong) UIButton * backBtn;

@property (nonatomic,strong) UILabel * calCurrentTimeLabel;
@property (nonatomic,strong) UILabel * allTotalTimeLabel;
@property(nonatomic,strong) LineProcessView * lineProcessView;

@property (nonatomic,strong) UIButton * playBtn;
@property (nonatomic,strong) UILabel * currentTimeLabel;
@property(nonatomic,strong) UISlider * slider;
@property (nonatomic,strong) UILabel * durationLabel;

@property (nonatomic,strong) VideoCollectionView * videoCollectionView;

//视频播放
@property (nonatomic, strong) AVQueuePlayer * player;
@property (nonatomic, strong) NSArray<AVPlayerItem *> * playerItems;

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    [self initPlayerItemsView];
    [self initPlayControllerView];
    [self initAVQueuePlayer];
    
    [self.view bringSubviewToFront:_backBtn];
    [self.view bringSubviewToFront:_calCurrentTimeLabel];
    [self.view bringSubviewToFront:_allTotalTimeLabel];
}

/**
 基本界面
 */
-(void)initPlayControllerView{
    float videoBtnHeight=SCREEN_HEIGHT-88;
    
    _backBtn=[[UIButton alloc]init];
    _backBtn.frame=CGRectMake(10, 20, 30, 30);
    [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    _calCurrentTimeLabel=[UILabel new];
    _calCurrentTimeLabel.frame=CGRectMake(3, videoBtnHeight-20, 100, 14);
    _calCurrentTimeLabel.text=@"00:00";
    _calCurrentTimeLabel.textAlignment=NSTextAlignmentLeft;
    _calCurrentTimeLabel.textColor=[UIColor whiteColor];
    _calCurrentTimeLabel.font=[UIFont systemFontOfSize:(14)];
    
    _allTotalTimeLabel=[UILabel new];
    _allTotalTimeLabel.frame=CGRectMake(SCREEN_WIDTH-103, videoBtnHeight-20, 100, 14);
    _allTotalTimeLabel.text=@"00:00";
    _allTotalTimeLabel.textAlignment=NSTextAlignmentRight;
    _allTotalTimeLabel.textColor=[UIColor whiteColor];
    _allTotalTimeLabel.font=[UIFont systemFontOfSize:(14)];
    
    _playBtn=[UIButton new];
    _playBtn.frame=CGRectMake(2, videoBtnHeight, 30, 30);
    //_playBtn.enabled=NO;
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
    [self.view addSubview:_calCurrentTimeLabel];
    [self.view addSubview:_allTotalTimeLabel];
    [self.view addSubview:self.lineProcessView];
    [self.view addSubview:_playBtn];
    [self.view addSubview:_currentTimeLabel];
    [self.view addSubview:_slider];
    [self.view addSubview:_durationLabel];
}

/**
 初始化进度条
 */
-(LineProcessView *)lineProcessView{
    if (!_lineProcessView) {
        _lineProcessView = [[LineProcessView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        _lineProcessView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, SCREEN_HEIGHT-90);
    }
    return _lineProcessView;
}

/**
 播放项目队列
 */
-(void)initPlayerItemsView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing=1;
    flowLayout.itemSize = CGSizeMake(57, 57);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _videoCollectionView = [[VideoCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-57, SCREEN_WIDTH, 57) collectionViewLayout:flowLayout];
    _videoCollectionView.videoDataSource=_videos;
    _videoCollectionView.avPlayerDelegate=self;
    
    [self.view addSubview:_videoCollectionView];
}

/**
 播放器
 */
-(void)initAVQueuePlayer{
    NSMutableArray<AVPlayerItem * >* avPlayerItems=@[].mutableCopy;
    for (Video * video in _videos){
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        AVPlayerItem * avPlayerItem=[AVPlayerItem playerItemWithURL:nsUrl];
        [avPlayerItems addObject:avPlayerItem];
    }
    _playerItems=avPlayerItems;
    _player=[AVQueuePlayer queuePlayerWithItems:_playerItems];
    // 插入周期时间观察器
    __weak __typeof(self) weakSelf=self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 24) queue:dispatch_get_main_queue() usingBlock:^(CMTime time){
        NSTimeInterval currentTime=CMTimeGetSeconds(time);
        CMTime durationTime=weakSelf.player.currentItem.duration;
        NSTimeInterval totalTime=CMTimeGetSeconds(durationTime);
        weakSelf.currentTimeLabel.text=[PhotosFrameworksUtility formatCMTime:time];
        weakSelf.durationLabel.text=[PhotosFrameworksUtility formatCMTime:durationTime];
        [weakSelf.slider setValue:(currentTime*100)/totalTime];
        //
        int index=(int)[weakSelf.playerItems indexOfObject:weakSelf.player.currentItem];
        CMTime calTime=[weakSelf calALLCurrentTime:index];
        calTime=CMTimeAdd(calTime, time);
        weakSelf.calCurrentTimeLabel.text=[PhotosFrameworksUtility formatCMTime:calTime];
        weakSelf.allTotalTimeLabel.text=[PhotosFrameworksUtility formatCMTime:weakSelf.allTotalTime];
        [weakSelf.lineProcessView setProcessValue:CMTimeGetSeconds(calTime)/CMTimeGetSeconds(weakSelf.allTotalTime)];
    }];
    // 3. 创建视频显示图层
    AVPlayerLayer *avLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    avLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-91);
    avLayer.backgroundColor=[UIColor blackColor].CGColor;
    // 4. 把视频显示图层添加到self.view上面
    [self.view.layer addSublayer:avLayer];
    
    [self calAllTotalTime];
}

/**
 计算总时长
 */
-(void)calAllTotalTime{
    _allTotalTime=CMTimeMake(0, 1);
    for(Video * video in _videos){
        _allTotalTime=CMTimeAdd(_allTotalTime, video.duration);
    }
}

-(CMTime)calALLCurrentTime:(int)index{
    CMTime calTime=CMTimeMake(0, 1);
    for(int i=0;i<index;i++){
        calTime=CMTimeAdd(calTime, _videos[i].duration);
    }
    return calTime;
}

/*
-(void)initAVPlayer{
    NSURL * url=[NSURL URLWithString:[_videos objectAtIndex:0].url];
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
 */

/**
 进度条跳转
 */
-(void)sliderValueChanged:(UISlider *)slider{
    if(self.player.status == AVPlayerStatusReadyToPlay){
        [self.player pause];
        _playBtn.selected=NO;
        float sliderVal=slider.value;
        Float64 duration= CMTimeGetSeconds(self.player.currentItem.duration);
        Float64 seetTime=((sliderVal/100) * duration);
        CMTime seekCMTime = CMTimeMake(seetTime, 1);
        [self.player seekToTime:seekCMTime completionHandler:^(BOOL finished) {
        }];
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
 代理方法响应CollectionView的点击事件
 */
- (void) replacePlayerItem:(NSInteger)index{
    [_player pause];
    [self.player removeAllItems];
    for (int i=(int)index;i<_playerItems.count;i++){
        [self.player insertItem:[_playerItems objectAtIndex:i] afterItem:self.player.currentItem];
    }
    [_player seekToTime:CMTimeMake(0, 1)];
    _playBtn.selected=YES;
    [_player play];
}

/**
 返回按钮事件
 */
-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 播放按钮事件
 */
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
    //[self.player.currentItem removeObserver:self forKeyPath:@"status" context:&CGLayerGetContext];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    //self.playerItem = nil;
    self.player = nil;
}

@end
