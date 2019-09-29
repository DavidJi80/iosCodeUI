//
//  AVEditorViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVEditorViewController.h"
#import "VideoCollectionView.h"
#import "PhotosFrameworksUtility.h"
#import "FrameCollectionView.h"

@interface AVEditorViewController ()

@property(nonatomic,strong) UIButton * backBtn;

@property (nonatomic,strong) UIButton * playBtn;
@property (nonatomic,strong) UILabel * currentTimeLabel;
@property(nonatomic,strong) UISlider * slider;
@property (nonatomic,strong) UILabel * durationLabel;

@property (nonatomic,strong) VideoCollectionView * videoCollectionView;
@property (nonatomic,strong) FrameCollectionView * frameCollectionView;

//视频播放
@property (nonatomic, strong) AVQueuePlayer * player;
@property (nonatomic, strong) NSArray<AVPlayerItem *> * playerItems;


@end

@implementation AVEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

-(void)initView{
    [self initPlayerItemsView];
    [self initPlayControllerView];
    [self initAVQueuePlayer];
    [self initFramesView];
    
    [self.view bringSubviewToFront:_backBtn];
    [self.view bringSubviewToFront:_videoCollectionView];
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
    [self.view addSubview:_playBtn];
    [self.view addSubview:_currentTimeLabel];
    [self.view addSubview:_slider];
    [self.view addSubview:_durationLabel];
}

/**
 帧图片
 */
-(void)initPlayerItemsView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.itemSize = CGSizeMake(57, 57);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _frameCollectionView = [[FrameCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-57, SCREEN_WIDTH, 57) collectionViewLayout:flowLayout];
    _frameCollectionView.frameDataSource=[self generateFrameDataSource:0];
    
    [self.view addSubview:_frameCollectionView];
    
    [self generateFrames:0];
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
    }];
    // 3. 创建视频显示图层
    AVPlayerLayer *avLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
    avLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-91);
    avLayer.backgroundColor=[UIColor blackColor].CGColor;
    // 4. 把视频显示图层添加到self.view上面
    [self.view.layer addSublayer:avLayer];
}

/**
 播放项目队列
 */
-(void)initFramesView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing=0;
    flowLayout.itemSize = CGSizeMake(57, 57);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _videoCollectionView = [[VideoCollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-57, SCREEN_HEIGHT-195, 57, 114) collectionViewLayout:flowLayout];
    _videoCollectionView.videoDataSource=_videos;
    _videoCollectionView.avPlayerDelegate=self;
    
    [self.view addSubview:_videoCollectionView];
}

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
    self.frameCollectionView.frameDataSource=[self generateFrameDataSource:(int)index];
    [_frameCollectionView reloadData];
    [self generateFrames:(int)index];
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
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
}

/**
 初始化帧数据源
 */
-(NSMutableArray<Frame *> *)generateFrameDataSource:(int)index{
    NSURL * nsUrl=[NSURL URLWithString:_videos[index].url];
    AVAsset * avAsset=[AVAsset assetWithURL:nsUrl];
    AVAssetImageGenerator * generator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    CMTime time = CMTimeMakeWithSeconds(0, 1);
    NSError * error = nil;
    CMTime actualTime;
    CGImageRef image =[generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    //UIImageWriteToSavedPhotosAlbum(videoImage, nil, nil, nil);
    //视频总秒数
    CMTime cmTime = avAsset.duration;
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    int secend = timeInterVal;
    secend = secend % 60;
    NSMutableArray<Frame *> * frameDataSource=[NSMutableArray array];
    for (int i = 1; i <= secend; i++) {
        Frame * frame=[Frame new];
        frame.image=videoImage;
        [frameDataSource addObject:frame];
    }
    return frameDataSource;
}

/**
 异步取帧
 */
-(void)generateFrames:(int)index{
    NSURL * nsUrl=[NSURL URLWithString:_videos[index].url];
    AVAsset * avAsset=[AVAsset assetWithURL:nsUrl];
    //视频总秒数
    CMTime cmTime = avAsset.duration;
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    int secend = timeInterVal;
    secend = secend % 60;
    //一秒取一帧
    NSMutableArray * specifiedTimes=[NSMutableArray array];
    for (int i = 1; i <= secend; i++) {
        CMTime timeFrame = CMTimeMake(i, 1);
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [specifiedTimes addObject:timeValue];
    }
    //定义图片生成器
    AVAssetImageGenerator * generator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    //开始异步取帧
    __weak __typeof(self) weakSelf=self;
    [generator generateCGImagesAsynchronouslyForTimes:specifiedTimes completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        NSLog(@"requestedTime-----: (%lld,%d)", requestedTime.value,requestedTime.timescale);
        NSLog(@"actualTime-----: (%lld,%d)", actualTime.value,actualTime.timescale);
        
        NSMutableArray<Frame *> * dataSource=weakSelf.frameCollectionView.frameDataSource.copy;
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage * frameImg = [UIImage imageWithCGImage:image];
                dataSource[requestedTime.value-1].image=frameImg;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf.frameCollectionView reloadData];
                });
                
            }
                break;
        }
        
    }];
}



@end
