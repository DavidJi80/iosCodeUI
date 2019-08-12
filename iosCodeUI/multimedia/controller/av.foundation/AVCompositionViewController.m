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

@interface AVCompositionViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@end

@implementation AVCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self composition];
}

-(void)composition{
    //创建一个空的AVMutableComposition对象
    AVMutableComposition *composition = [AVMutableComposition composition];
    /**
     添加一个空的Track
        @mediaType :  媒体类型，AVMediaTypeVideo（视频）
        @preferredTrackID : 首选Track ID,传入kCMPersistentTrackID_Invalid，则生成一个惟一的Track ID。
     */
    AVMutableCompositionTrack *videoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    //AVMutableCompositionTrack *audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //定义CMTime表示插入光标点，表示插入媒体片段的位置
    CMTime cursorTime = kCMTimeZero;
    for (Video * video in _videos){
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        //AVURLAssetPreferPreciseDurationAndTimingKey值为YES确保当资源的属性使用
        NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
        AVAsset * asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
        /**
         AVAsynchronousKeyValueLoading协议载入时可以计算出准确的时长和时间信息。
         会对载入过程增加一些额外开销，但可以保证资源正处于合适的编辑状态。
         */
        NSArray * keys=@[@"tracks",@"duration",@"commonMetadata"];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            
        }];
        
        /**
         从一个AVAsset中提取视频轨道，返回一个匹配给定媒体类型的轨道数组
         不过由于这个媒体只包含一个单独的视频轨道，取第一个对象
         */
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        /**
         目标是捕捉每个视频前5秒的内容
         创建一个CMTimeRange，从kCMTimeZero开始，持续时间5秒
         */
        CMTime videoDuration = CMTimeMake(5, 1);
        CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoDuration);
        /**
         在视频轨道上将视频片段插入到轨道中。
             @timeRange:要插入的轨道的时间范围。
             @track:要插入的轨道源
             @startTime:在合成轨道中表示的开始时间
             @error:如果没有成功插入track，则返回描述问题的NSError对象。
         */
        [videoTrack insertTimeRange:videoTimeRange ofTrack:assetTrack atTime:cursorTime error:nil];
        //移动光标插入时间，让下一段内容在另一段内容最后插入。
        cursorTime = CMTimeAdd(cursorTime, CMTimeMake(6, 1));   //插入1秒黑屏
        
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


/**
获取压缩后的大小
*/
- (CGFloat)fileSize:(NSURL *)path{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

-(void)exportVideo{
    for (Video * video in _videos){
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        [self exportWithUrl:nsUrl];
    }
}

-(void)exportWithUrl:(NSURL *)nsUrl{
    //返回所有可用的Preset
    for (NSString * preset in [AVAssetExportSession allExportPresets]){
        NSLog(@"allExportPresets:%@",preset);
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:nsUrl options:nil];
    //返回与给定Asset兼容的Preset
    for (NSString * preset in [AVAssetExportSession exportPresetsCompatibleWithAsset:asset]){
        NSLog(@"exportPresetsCompatibleWithAsset:%@",preset);
    }
    //初始化导出session
    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset960x540];
    NSLog(@"presetName:%@",exportSession.presetName);   //初始化会话时用的Preset名称
    //url
    NSString *documentsDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSURL *documentsDirUrl=[NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
    NSURL * outputURL=[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",[self getNowTime]] relativeToURL:documentsDirUrl];
    //配置输出
    exportSession.outputURL =outputURL;                 //输出的URL
    for (AVFileType avFileType in exportSession.supportedFileTypes){
        NSLog(@"AVFileType:%@",avFileType);
    }
    exportSession.outputFileType = AVFileTypeMPEG4;     //输出文件类型
    exportSession.shouldOptimizeForNetworkUse = YES;    //是否为网络使用优化
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            [self saveVideoAtUrl:outputURL];
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            //NSLog(@"视频时长：%@",exportSession.maxDuration);
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}

#pragma mark --- 获取当前时间戳
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

@end
