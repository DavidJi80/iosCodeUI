//
//  AVCompositionViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVCompositionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define k720pSize CGSizeMake(1080.0f, 1920.0f)

@interface AVCompositionViewController ()

@property (nonatomic,strong) AVPlayerLayer * avPlayerLayer;
@property (nonatomic,strong) AVComposition * avComposition;

@end

@implementation AVCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    
}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

#pragma mark - UI

-(void)initNavigation{
    //AVComposition
    UIBarButtonItem * compositionBBI=[[UIBarButtonItem alloc]initWithTitle:@"合并" style:(UIBarButtonItemStylePlain) target:self action:@selector(startPlayComposition)];
    UIBarButtonItem * exportBBI=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:(UIBarButtonItemStylePlain) target:self action:@selector(exportComposition)];
    //AVVideoComposition
    UIBarButtonItem * videoCompositionBBI=[[UIBarButtonItem alloc]initWithTitle:@"video组合" style:(UIBarButtonItemStylePlain) target:self action:@selector(startPlayVideoComposition)];
    UIBarButtonItem * exportVBBBI=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:(UIBarButtonItemStylePlain) target:self action:@selector(exportVideoComposition)];
    UIBarButtonItem * videoComposition2BBI=[[UIBarButtonItem alloc]initWithTitle:@"过渡" style:(UIBarButtonItemStylePlain) target:self action:@selector(startPlayVideoHave2Track)];
    UIBarButtonItem * exportVCBBI=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:(UIBarButtonItemStylePlain) target:self action:@selector(exportVC2Track)];
    self.navigationItem.rightBarButtonItems=@[
                                              exportVBBBI,
                                              videoCompositionBBI,
                                              exportVCBBI,
                                              videoComposition2BBI,
                                              exportBBI,
                                              compositionBBI
                                              ];
}

#pragma mark - AVComposition
/**
 将多个AVAsset合并成一个AVComposition的一个Track中
 */
-(AVComposition *)createAVCompositionWithAVAssets{
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频AVMutableCompositionTrack
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频AVMutableCompositionTrack
    AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime cursorTime = kCMTimeZero;
    for (Video * video in _videos){
        //获取源的视频Track
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
        AVAsset * asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
        AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
        //将源Track插入到AVComposition
        CMTime videoDuration = asset.duration;
        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        [videoTrack insertTimeRange:videoTimeRange ofTrack:assetVideoTrack atTime:cursorTime error:nil];
        [audioTrack insertTimeRange:videoTimeRange ofTrack:assetAudioTrack atTime:cursorTime error:nil];
        //移动光标插入时间，让下一段内容在另一段内容最后插入。
        cursorTime = CMTimeAdd(cursorTime, videoDuration);
    }
    return composition;
}


/**
 音频混合
 */
-(AVMutableAudioMix *)adjustVolumeForTrack:(AVCompositionTrack *)audioTrack{
    CMTime twoSec=CMTimeMake(2, 1);
    CMTime fourSec=CMTimeMake(4, 1);
    CMTime sevenSec=CMTimeMake(7, 1);
    
    AVMutableAudioMixInputParameters * parameters=[AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
    [parameters setVolume:0.5f atTime:kCMTimeZero];
    CMTimeRange range=CMTimeRangeMake(twoSec, fourSec);
    [parameters setVolumeRampFromStartVolume:0.5f toEndVolume:0.8f timeRange:range];
    [parameters setVolume:0.2f atTime:sevenSec];
    
    AVMutableAudioMix * audioMix=[AVMutableAudioMix audioMix];
    audioMix.inputParameters=@[parameters];
    return audioMix;
}

/**
 播放AVComposition视频
 */
-(void)startPlayComposition{
    self.avComposition=[self createAVCompositionWithAVAssets];
    AVPlayerItem * playerItem=[AVPlayerItem playerItemWithAsset:self.avComposition];
    AVCompositionTrack * audioTrack=[[self.avComposition tracksWithMediaType:AVMediaTypeAudio] firstObject];
    [playerItem setAudioMix:[self adjustVolumeForTrack:audioTrack]];
    AVPlayer * player=[AVPlayer playerWithPlayerItem:playerItem];
    self.avPlayerLayer=[AVPlayerLayer playerLayerWithPlayer:player];
    self.avPlayerLayer.frame=self.view.bounds;
    [self.view.layer addSublayer:self.avPlayerLayer];
    [player play];
}

/**
 导出合并的视频
 */
-(void)exportComposition{
    NSString *preset = AVAssetExportPreset960x540;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.avComposition copy] presetName:preset];
    NSURL * outputURL=[self generateNSURL];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            [self saveVideoAtUrl:outputURL];
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}

#pragma mark - 过渡
/**
 把2个视频组合成到一个AVComposition的2个Track中
 */
-(AVComposition *)createAVCompositionHave2Track6{
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableCompositionTrack *videoTrackA = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrackB = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    if (_videos.count<2) return nil;
    
    Video * video=[_videos objectAtIndex:0];
    NSURL * nsUrl=[NSURL URLWithString:video.url];
    NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
    AVAsset * asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
    AVAssetTrack *assetVideoTrackA = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    Video * video2=[_videos objectAtIndex:1];
    NSURL * nsUrl2=[NSURL URLWithString:video2.url];
    AVAsset * asset2=[AVURLAsset URLAssetWithURL:nsUrl2 options:options];
    AVAssetTrack *assetVideoTrackB = [[asset2 tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    CMTime cursorTime = kCMTimeZero;
    CMTime transitionDuration=CMTimeMake(2.0f, 1.0f);
    CMTime maxDuration=CMTimeMake(6.0f, 1.0f);
    
    [videoTrackA insertTimeRange:CMTimeRangeMake(kCMTimeZero, maxDuration) ofTrack:assetVideoTrackA atTime:cursorTime error:nil];
    cursorTime=CMTimeAdd(cursorTime, maxDuration);
    cursorTime=CMTimeSubtract(cursorTime, transitionDuration);
    
    [videoTrackB insertTimeRange:CMTimeRangeMake(kCMTimeZero, maxDuration) ofTrack:assetVideoTrackB atTime:cursorTime error:nil];
    cursorTime=CMTimeAdd(cursorTime, maxDuration);
    cursorTime=CMTimeSubtract(cursorTime, transitionDuration);
    
    [videoTrackA insertTimeRange:CMTimeRangeMake(kCMTimeZero, maxDuration) ofTrack:assetVideoTrackA atTime:cursorTime error:nil];
    
    return composition;
}

/**
 修改透明度
 */
-(AVVideoComposition *)configHave2TrackVideoComposition6:(AVAsset * )avAsset{
    AVMutableVideoComposition * videoComposition=[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:avAsset];
    
    CMTime cursorTime=kCMTimeZero;
    CMTime passTime=CMTimeMake(4.0f, 1.0f);
    CMTime tranTime=CMTimeMake(2.0f, 1.0f);
    
    NSArray * tracks=[avAsset tracksWithMediaType:AVMediaTypeVideo];

    NSMutableArray * instructions=[NSMutableArray array];
    //1 (0-4)
    AVMutableVideoCompositionInstruction * instruction1=[AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction1.timeRange=CMTimeRangeMake(cursorTime, passTime);
    AVMutableVideoCompositionLayerInstruction * layerInstruction1=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:0]];
    instruction1.layerInstructions=@[layerInstruction1];
    [instructions addObject:instruction1];
    cursorTime=CMTimeAdd(cursorTime, passTime);
    //2 (5-6)
    AVMutableVideoCompositionInstruction * instruction2=[AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction2.timeRange=CMTimeRangeMake(cursorTime, tranTime);
    AVMutableVideoCompositionLayerInstruction * layerInstruction2A=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:0]];
    [layerInstruction2A setOpacityRampFromStartOpacity:1.0f toEndOpacity:0.0f timeRange:CMTimeRangeMake(cursorTime, tranTime)];
    AVMutableVideoCompositionLayerInstruction * layerInstruction2B=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:1]];
    [layerInstruction2B setOpacityRampFromStartOpacity:0.0f toEndOpacity:1.0f timeRange:CMTimeRangeMake(cursorTime, tranTime)];
    instruction2.layerInstructions=@[layerInstruction2A,layerInstruction2B];
    [instructions addObject:instruction2];
    cursorTime=CMTimeAdd(cursorTime, tranTime);
    //3 (7-8)
    AVMutableVideoCompositionInstruction * instruction3=[AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction3.timeRange=CMTimeRangeMake(cursorTime, tranTime);
    AVMutableVideoCompositionLayerInstruction * layerInstruction3=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:1]];
    instruction3.layerInstructions=@[layerInstruction3];
    [instructions addObject:instruction3];
    cursorTime=CMTimeAdd(cursorTime, tranTime);
    //4 (9-10)
    AVMutableVideoCompositionInstruction * instruction4=[AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction4.timeRange=CMTimeRangeMake(cursorTime, tranTime);
    AVMutableVideoCompositionLayerInstruction * layerInstruction4A=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:1]];
    [layerInstruction4A setOpacityRampFromStartOpacity:1.0f toEndOpacity:0.0f timeRange:CMTimeRangeMake(cursorTime, tranTime)];
    AVMutableVideoCompositionLayerInstruction * layerInstruction4B=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:0]];
    [layerInstruction4B setOpacityRampFromStartOpacity:0.0f toEndOpacity:1.0f timeRange:CMTimeRangeMake(kCMTimeZero, tranTime)];
    instruction4.layerInstructions=@[layerInstruction4A,layerInstruction4B];
    [instructions addObject:instruction4];
    cursorTime=CMTimeAdd(cursorTime, tranTime);
    //5 (11-14)
    AVMutableVideoCompositionInstruction * instruction5=[AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction5.timeRange=CMTimeRangeMake(cursorTime, passTime);
    AVMutableVideoCompositionLayerInstruction * layerInstruction5=[AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:[tracks objectAtIndex:0]];
    instruction5.layerInstructions=@[layerInstruction5];
    [instructions addObject:instruction5];
    
    videoComposition.instructions=instructions;
    return [videoComposition copy];
}


/**
 播放AVComposition过渡视频
 */
-(void)startPlayVideoHave2Track{
    self.avComposition=[self createAVCompositionHave2Track6];
    AVPlayerItem * playerItem=[AVPlayerItem playerItemWithAsset:self.avComposition];
    playerItem.videoComposition=[self configHave2TrackVideoComposition6:self.avComposition];
    AVPlayer * player=[AVPlayer playerWithPlayerItem:playerItem];
    self.avPlayerLayer=[AVPlayerLayer playerLayerWithPlayer:player];
    self.avPlayerLayer.frame=self.view.bounds;
    [self.view.layer addSublayer:self.avPlayerLayer];
    [player play];
}

/**
 导出过渡视频
 */
-(void)exportVC2Track{
    self.avComposition=[self createAVCompositionHave2Track6];
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.avComposition copy] presetName:preset];
    exportSession.videoComposition=[self configHave2TrackVideoComposition6:self.avComposition];
    NSURL * outputURL=[self generateNSURL];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            [self saveVideoAtUrl:outputURL];
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}


#pragma mark - AVMutableComposition
/**
 AVMutableComposition 合成视频并导出
 */
-(void)composition{
    //1. 创建一个空的AVMutableComposition对象
    AVMutableComposition *composition = [AVMutableComposition composition];
    /**
     2. 添加一个空的Track(AVMutableCompositionTrack对象)
        @mediaType :  媒体类型，AVMediaTypeVideo（视频）
        @preferredTrackID : 首选Track ID,传入kCMPersistentTrackID_Invalid，则生成一个惟一的Track ID。
     */
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //定义CMTime表示插入光标点，表示插入媒体片段的位置
    CMTime cursorTime = kCMTimeZero;
    for (Video * video in _videos){
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        //AVURLAssetPreferPreciseDurationAndTimingKey值为YES确保当资源的属性使用
        NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
        AVAsset * asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
        /**
         从一个AVAsset中提取视频轨道，返回一个匹配给定媒体类型的轨道数组
         不过由于这个媒体只包含一个单独的视频轨道，取第一个对象
         */
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        /**
         创建一个CMTimeRange，从kCMTimeZero开始
         */
        CMTime videoDuration = assetTrack.timeRange.duration;
        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        /**
         3. 在视频轨道上将视频片段插入到轨道中。
             @timeRange:要插入的轨道的时间范围。
             @track:要插入的轨道源
             @startTime:在合成轨道中表示的开始时间
             @error:如果没有成功插入track，则返回描述问题的NSError对象。
         */
        [videoTrack insertTimeRange:videoTimeRange ofTrack:assetTrack atTime:cursorTime error:nil];
        //移动光标插入时间，让下一段内容在另一段内容最后插入。
        cursorTime = CMTimeAdd(cursorTime, videoDuration);   //插入1秒黑屏
        
    }
    
    NSString *preset = AVAssetExportPreset960x540;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[composition copy] presetName:preset];
    
    //url
    NSString *documentsDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSURL *documentsDirUrl=[NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
    NSURL * outputURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",[self getNowTime]] relativeToURL:documentsDirUrl];
    
    // 为会话动态生成一个唯一的输出URL，设置输出文件类型
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            //NSLog(@"视频时长：%@",exportSession.maxDuration);
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}

#pragma mark - AVVideoComposition
/**
 配置AVVideoComposition
 */
-(AVVideoComposition *)configVideoComposition:(AVAsset *)avAsset{
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    AVMutableVideoComposition *composition = [AVMutableVideoComposition videoCompositionWithAsset: avAsset
                                       applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest *request){
                                           // Clamp to avoid blurring transparent pixels at the image edges
                                           CIImage *source = [request.sourceImage imageByClampingToExtent];
                                           [filter setValue:source forKey:kCIInputImageKey];
                                           [filter setValue:@(0.9) forKey:kCIInputIntensityKey];

                                           // Crop the blurred output to the bounds of the original image
                                           CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];

                                           // Provide the filter output to the composition
                                           [request finishWithImage:output context:nil];
                                       }];
    return composition;
}


/**
 播放AVVideoComposition视频
 */
-(void)startPlayVideoComposition{
    Video * video=[self.videos objectAtIndex:0];
    NSURL * nsUrl=[NSURL URLWithString:video.url];
    AVAsset * avAsset = [AVAsset assetWithURL:nsUrl];

    AVPlayerItem * playerItem=[AVPlayerItem playerItemWithAsset:avAsset];
    //playerItem.videoComposition=[self configVideoComposition:avAsset];
    AVPlayer * player=[AVPlayer playerWithPlayerItem:playerItem];
    self.avPlayerLayer=[AVPlayerLayer playerLayerWithPlayer:player];
    self.avPlayerLayer.frame=self.view.bounds;
    [self.view.layer addSublayer:self.avPlayerLayer];
    
    //加一个动画层
    AVSynchronizedLayer* syncLayer = [AVSynchronizedLayer synchronizedLayerWithPlayerItem:playerItem];
    CALayer* textLayer = [self buildTextLayerWithText:@"这是字幕+闪烁的动画"];
    [syncLayer addSublayer:textLayer];
    [self.avPlayerLayer addSublayer:syncLayer];
    
    [player play];
}

-(CALayer*)buildTextLayerWithText:(NSString*)text {
    CATextLayer* textLayer = [[CATextLayer alloc] init];
    textLayer.string = text;
    textLayer.fontSize = 30.0f;
    //textLayer.foregroundColor = [UIColor whiteColor].CGColor;
    textLayer.frame = CGRectMake(0, 200, k720pSize.width, 50);
    //textLayer.backgroundColor=UIColor.blueColor.CGColor;
    
    CABasicAnimation* anim = [CABasicAnimation animation];
    anim.keyPath = @"foregroundColor";
    anim.byValue = (id)[UIColor redColor].CGColor;
    anim.toValue = (id)[UIColor whiteColor].CGColor;
    anim.removedOnCompletion = NO;
    anim.repeatCount = HUGE_VALF;
    anim.duration = 3.0f;
    anim.beginTime = AVCoreAnimationBeginTimeAtZero;
    anim.fillMode = kCAFillModeForwards;
    [textLayer addAnimation:anim forKey:nil];
    
    return textLayer;
}

/**
 导出AVVideoComposition视频
 */
-(void)exportVideoComposition{
    Video * video=[self.videos objectAtIndex:0];
    NSURL * nsUrl=[NSURL URLWithString:video.url];
    AVAsset * avAsset = [AVAsset assetWithURL:nsUrl];
    
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[avAsset copy] presetName:preset];
    NSURL * outputURL=[self generateNSURL];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.videoComposition=[self configVideoComposition:avAsset];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            [self saveVideoAtUrl:outputURL];
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}

#pragma mark - function
/**
 获取当前时间戳
 */
- (NSString *)getNowTime{
    // 获取时间（非本地时区，需转换）
    NSDate * today = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 转换成当地时间
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];//@"1517468580"
    return timeSp;
}

/**
 生成相册地址
 */
-(NSURL *)generateNSURL{
    //url
    NSString *documentsDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSURL *documentsDirUrl=[NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
    NSURL * outputURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",[self getNowTime]] relativeToURL:documentsDirUrl];
    return outputURL;
}

/**
 存入相册
 */
- (void)saveVideoAtUrl:(NSURL *)videoURL {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //需要删除文件的物理地址
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:videoURL.path];
        if (fileExists) {
            [fileManager removeItemAtPath:videoURL.path error:nil];
        }
    }];
}

@end
