//
//  IOAssetVC.m
//  iosCodeUI
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "IOAssetVC.h"
#import "PhotosFrameworksUtility.h"

@interface IOAssetVC ()

@property(nonatomic,strong) AVAssetReader * assetReader;
@property(nonatomic,strong) AVAssetWriter * assetWriter;

@end

@implementation IOAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showAVAssetinfo];
    

    
}
#pragma mark - AVAsset Info
-(void)showAVAssetinfo{
    NSString * avAssetInfo;
    
    Asset * asset=[self.videos objectAtIndex:0];
    NSURL *fileUrl=[NSURL URLWithString:asset.url];
    AVAsset *avAsset = [AVAsset assetWithURL:fileUrl];
    //AVAsset信息
    avAssetInfo=[NSString stringWithFormat:@"时长：%@",[PhotosFrameworksUtility formatCMTime:avAsset.duration]];
    if(avAsset.providesPreciseDurationAndTiming){
        avAssetInfo=[NSString stringWithFormat:@"%@（精确）\n",avAssetInfo];
    }else{
        avAssetInfo=[NSString stringWithFormat:@"%@（不精确）\n",avAssetInfo];
    }
    avAssetInfo=[NSString stringWithFormat:@"%@创作时间：%@\n",avAssetInfo,avAsset.creationDate.value];
    avAssetInfo=[NSString stringWithFormat:@"%@播放速率：%f\n",avAssetInfo,avAsset.preferredRate];
    avAssetInfo=[NSString stringWithFormat:@"%@播放音量：%f\n",avAssetInfo,avAsset.preferredVolume];
    //确定可用性
    avAssetInfo=[NSString stringWithFormat:@"%@是否可播放：%d\n",avAssetInfo,avAsset.playable];
    avAssetInfo=[NSString stringWithFormat:@"%@是否可导出：%d\n",avAssetInfo,avAsset.exportable];
    avAssetInfo=[NSString stringWithFormat:@"%@是否可提取：%d\n",avAssetInfo,avAsset.readable];
    avAssetInfo=[NSString stringWithFormat:@"%@是否可合成：%d\n",avAssetInfo,avAsset.composable];
    avAssetInfo=[NSString stringWithFormat:@"%@是否有受保护的内容：%d\n",avAssetInfo,avAsset.hasProtectedContent];
    avAssetInfo=[NSString stringWithFormat:@"%@是否兼容AirPlay：%d\n",avAssetInfo,avAsset.compatibleWithAirPlayVideo];
    avAssetInfo=[NSString stringWithFormat:@"%@是否可以写入到相簿：%d\n",avAssetInfo,avAsset.compatibleWithSavedPhotosAlbum];
    //Metadata
    avAssetInfo=[NSString stringWithFormat:@"%@歌词：%@\n",avAssetInfo,avAsset.lyrics];
    avAssetInfo=[NSString stringWithFormat:@"%@Metadata：\n",avAssetInfo];
    for(NSString * availableMetadataFormat in avAsset.availableMetadataFormats){
        avAssetInfo=[NSString stringWithFormat:@"%@  %@\n",avAssetInfo,availableMetadataFormat];
    }
    //Track
    avAssetInfo=[NSString stringWithFormat:@"%@Tracks：(%lu)\n",avAssetInfo,(unsigned long)avAsset.tracks.count];
    for(AVAssetTrack * avAssetTrack in avAsset.tracks){
        //Track信息
        avAssetInfo=[NSString stringWithFormat:@"%@  [\n",avAssetInfo];
        avAssetInfo=[NSString stringWithFormat:@"%@    ID:%d\n",avAssetInfo,avAssetTrack.trackID];
        avAssetInfo=[NSString stringWithFormat:@"%@    媒体类型:%@\n",avAssetInfo,avAssetTrack.mediaType];
        avAssetInfo=[NSString stringWithFormat:@"%@    是否启用:%d\n",avAssetInfo,avAssetTrack.enabled];
        avAssetInfo=[NSString stringWithFormat:@"%@    是否可播放:%d\n",avAssetInfo,avAssetTrack.playable];
        avAssetInfo=[NSString stringWithFormat:@"%@    是否可播放:%d\n",avAssetInfo,avAssetTrack.playable];
        avAssetInfo=[NSString stringWithFormat:@"%@    数据是否在本存储容器中:%d\n",avAssetInfo,avAssetTrack.selfContained];
        avAssetInfo=[NSString stringWithFormat:@"%@    估计数据速率:%f\n",avAssetInfo,avAssetTrack.estimatedDataRate];
        avAssetInfo=[NSString stringWithFormat:@"%@    数据总字节数:%lld\n",avAssetInfo,avAssetTrack.totalSampleDataLength];
        if (@available(iOS 11.0, *)) {
            avAssetInfo=[NSString stringWithFormat:@"%@    是否可解码:%d\n",avAssetInfo,avAssetTrack.decodable];
        }
        //时间
        avAssetInfo=[NSString stringWithFormat:@"%@    时间开始:%@，时长：%@\n",avAssetInfo,[PhotosFrameworksUtility formatCMTime:avAssetTrack.timeRange.start],[PhotosFrameworksUtility formatCMTime:avAssetTrack.timeRange.duration]];
        avAssetInfo=[NSString stringWithFormat:@"%@    自然时间:%d\n",avAssetInfo, avAssetTrack.naturalTimeScale];
        //语言
        avAssetInfo=[NSString stringWithFormat:@"%@    语言代码:%@\n",avAssetInfo, avAssetTrack.languageCode];
        avAssetInfo=[NSString stringWithFormat:@"%@    语言标记:%@\n",avAssetInfo, avAssetTrack.extendedLanguageTag];
        //视觉特征
        avAssetInfo=[NSString stringWithFormat:@"%@    尺寸:%f*%f\n",avAssetInfo, avAssetTrack.naturalSize.width,avAssetTrack.naturalSize.height];
        //听觉特征
        avAssetInfo=[NSString stringWithFormat:@"%@    音量:%f\n",avAssetInfo, avAssetTrack.preferredVolume];
        //帧特征
        avAssetInfo=[NSString stringWithFormat:@"%@    帧率%f\n",avAssetInfo, avAssetTrack.nominalFrameRate];
        avAssetInfo=[NSString stringWithFormat:@"%@    帧的最小持续时间:%lld/%d\n",avAssetInfo, avAssetTrack.minFrameDuration.value,avAssetTrack.minFrameDuration.timescale];
        avAssetInfo=[NSString stringWithFormat:@"%@    是否有不同的表示值:%d\n",avAssetInfo, avAssetTrack.requiresFrameReordering];
        //段
        avAssetInfo=[NSString stringWithFormat:@"%@    段：(%lu)\n",avAssetInfo,avAssetTrack.segments.count];
        //Metadata
        avAssetInfo=[NSString stringWithFormat:@"%@    Metadata：\n",avAssetInfo];
        for(NSString * trackMetadata in avAssetTrack.availableMetadataFormats){
            avAssetInfo=[NSString stringWithFormat:@"%@        %@\n",avAssetInfo,trackMetadata];
        }
        //关联轨道
        avAssetInfo=[NSString stringWithFormat:@"%@    关联轨道：\n",avAssetInfo];
        for(NSString * trackAssociationType in avAssetTrack.availableTrackAssociationTypes){
            avAssetInfo=[NSString stringWithFormat:@"%@        %@\n",avAssetInfo,trackAssociationType];
        }
        
        avAssetInfo=[NSString stringWithFormat:@"%@  ]\n",avAssetInfo];
    }
    
    
    UITextView *oneTextView = [[UITextView alloc] init];
    oneTextView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-150); // 设置位置
    oneTextView.backgroundColor = [UIColor yellowColor]; // 设置背景色
    oneTextView.alpha = 1.0; // 设置透明度
    oneTextView.text = avAssetInfo; // 设置文字
    oneTextView.textAlignment = NSTextAlignmentLeft; // 设置字体对其方式
    //oneTextView.font = [UIFont boldSystemFontOfSize:25.5f]; // 设置字体大小
    //oneTextView.textColor = [UIColor redColor]; // 设置文字颜色
    [oneTextView setEditable:YES]; // 设置时候可以编辑
    oneTextView.dataDetectorTypes = UIDataDetectorTypeAll; // 显示数据类型的连接模式（如电话号码、网址、地址等）
    oneTextView.keyboardType = UIKeyboardTypeDefault; // 设置弹出键盘的类型
    oneTextView.returnKeyType = UIReturnKeySearch; // 设置键盘上returen键的类型
    oneTextView.scrollEnabled = YES; // 当文字宽度超过UITextView的宽度时，是否允许滑动
    [self.view addSubview:oneTextView]; // 添加到View上
}

#pragma mark - AVAsset I/O

/**
 从非实时资源中写入样本
 */
-(void)writeWithAVAsset{
    Asset * asset=[self.videos objectAtIndex:0];
    NSURL *fileUrl=[NSURL URLWithString:asset.url];
    //1. 使用AVAsset创建AVAssetReader
    AVAsset *avAsset = [AVAsset assetWithURL:fileUrl];
    NSError *serror;
    self.assetReader = [[AVAssetReader alloc] initWithAsset:avAsset error:&serror];
    //2. 从资源视频轨道中读取样本，将视频帧解压缩为BGRA格式
    NSDictionary *readerOutputSetting =
    @{
      (id)kCVPixelBufferPixelFormatTypeKey :@(kCVPixelFormatType_32BGRA)
      };
    AVAssetTrack *track = [[avAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:readerOutputSetting];
    //3. 将AVAssetReaderTrackOutput添加到AVAssetReader中
    if ([self.assetReader canAddOutput:trackOutput]) {
        [self.assetReader addOutput:trackOutput];
    }
    //4. 开始读取AVAssetTrack中的样本缓冲（sample buffers）
    [self.assetReader startReading];
    //5. 创建AVAssetWriter
    NSString *documentsDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
    NSURL *documentsDirUrl=[NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
    NSURL * outputUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",[self getNowTime]] relativeToURL:documentsDirUrl];
    NSError *wError;
    self.assetWriter = [[AVAssetWriter alloc] initWithURL:outputUrl fileType:AVFileTypeQuickTimeMovie error:&wError];
    //6. 创建AVAssetWriterInput
    NSDictionary *writerOutputSettings =
    @{
      AVVideoCodecKey:AVVideoCodecH264,
      AVVideoWidthKey:@1280,
      AVVideoHeightKey:@720,
      AVVideoCompressionPropertiesKey:@{
              AVVideoMaxKeyFrameIntervalKey:@1,
              AVVideoAverageBitRateKey:@10500000,
              AVVideoProfileLevelKey:AVVideoProfileLevelH264Main31,
              }
      
      };
    AVAssetWriterInput *writerInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:writerOutputSettings];
    //7. 将AVAssetWriterInput添加到AVAssetWriter
    if ([self.assetWriter canAddInput:writerInput]) {
        [self.assetWriter addInput:writerInput];
    }
    //8. 开始写入数据
    [self.assetWriter startWriting];
    //9. 创建一个新的写入会话，传递资源样本的开始时间
    [self.assetWriter startSessionAtSourceTime:kCMTimeZero];
    /**
     10. 收集媒体数据以便写入到输出文件
     在写入器输入准备好添加更多样本时，被不断调用。
     每次调用期间，输入准备添加更多数据时，再从轨道的输出中复制可用的样本，并附加到输入中。
     所有样本从轨道输出中复制后，标记AVAssetWriterInput已经结束并指明添加操作已完成。
     */
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.github.davidji80.iosCodeUI", NULL);
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        BOOL complete = NO ;
        //10.1. 输入是否准备好接受更多的媒体数据
        while ([writerInput isReadyForMoreMediaData] && !complete) {
            //10.2. 为输出复制下一个样本缓存（sample buffer）
            CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
            if (sampleBuffer) {
                //10.3. 将样本附加到接收器
                BOOL result = [writerInput appendSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
                complete = !result;
            } else {
                //告诉写入器不能向该输入追加更多的buffer
                [writerInput markAsFinished];
                complete = YES;
            }
        }
        
        if (complete) {
            [self.assetWriter finishWritingWithCompletionHandler:^{
                AVAssetWriterStatus status = self.assetWriter.status;
                if (status == AVAssetWriterStatusCompleted) {
                    [PhotosFrameworksUtility saveVideoAtUrl:outputUrl];
                } else {
                    
                }
            }];
        }
    }];
}

#pragma mark - Audio
-(void)loadAudio{
    Asset * asset=[self.videos objectAtIndex:0];
    NSURL *fileUrl=[NSURL URLWithString:asset.url];
    //1. 使用AVAsset创建AVAssetReader
    AVAsset *avAsset = [AVAsset assetWithURL:fileUrl];
    [self loadAudioSamplesFromAsset:avAsset];
}

- (void)loadAudioSamplesFromAsset:(AVAsset *)asset{
    NSString *tracks = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{
        AVKeyValueStatus status = [asset statusOfValueForKey:tracks error:nil];
        NSData *sampleData = nil;
        
        if (status == AVKeyValueStatusLoaded) { //资源已经加载完成
            sampleData = [self readAudioSamplesFromAsset:asset];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }];
}

- (NSData *)readAudioSamplesFromAsset:(AVAsset *)asset {
    //1. 创建一个AVAssetReader实例，并赋给他一个资源读取。
    NSError *error = nil;
    AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if (!assetReader) {
        NSLog(@"error creating asset reader :^%@",error);
        return nil;
    }
    
    //2. 获取资源找到的第一个音频轨道，根据期望的媒体类型获取轨道。
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    //3. 创建NSDictionary保存从资源轨道读取音频样本时使用的解压设置。
    NSDictionary *outputSettings =
    @{
      AVFormatIDKey:@(kAudioFormatLinearPCM),//样本需要以未压缩的格式被读取
      AVLinearPCMIsBigEndianKey:@NO,
      AVLinearPCMIsFloatKey:@NO,
      AVLinearPCMBitDepthKey:@(16)
      };
    
    
    //4. 创建新的AVAssetReaderTrackOutput实例，将创建的输出设置传递给它，
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:outputSettings];
    if ([assetReader canAddOutput:trackOutput]) {
        [assetReader addOutput:trackOutput];
    }
    
    //5. 将其作为AVAssetReader的输出并调用startReading来允许资源读取器开始预收取样本数据。
    [assetReader startReading];
    
    NSMutableData *sampleData = [NSMutableData data];
    while (assetReader.status == AVAssetReaderStatusReading) {
        //调用跟踪输出的方法开始迭代，每次返回一个包含音频样本的下一个可用样本buffer。
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        if (sampleBuffer) {
            //CMSampleBuffer中的音频样本包含在一个CMBlockBuffer类型中
            CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
            //CMSampleBufferGetDataBuffer函数可以方位block buffer
            size_t length = CMBlockBufferGetDataLength(blockBufferRef);
            //确定长度并创建一个16位带符号整型数组来保存音频样本
            SInt16 sampleBytes[length];
            //生成一个数组，数组中元素为CMBlockBuffer所包含的数据
            CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, sampleBytes);
            //将数组数据内容附加在NDSData实例后面。
            [sampleData appendBytes:sampleBytes length:length];
            //指定样本buffer已经处理和不可再继续使用
            CMSampleBufferInvalidate(sampleBuffer);
            //释放CMSampleBuffer副本来释放内容
            CFRelease(sampleBuffer);
        }
    }
    if (assetReader.status == AVAssetReaderStatusCompleted) {
        //数据读取成功，返回包含音频样本数据的NData
        return sampleData;
    } else {
        NSLog(@"Failed to read audio samples from asset");
        return nil;
    }
    return nil;
}

#pragma mark - 获取当前时间戳
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
