//
//  IOAssetVC.m
//  iosCodeUI
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "IOAssetVC.h"

@interface IOAssetVC ()

@property(nonatomic,strong) AVAssetReader * assetReader;
@property(nonatomic,strong) AVAssetWriter * assetWriter;

@end

@implementation IOAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self writeWithAVAsset];
}

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
                    //
                } else {
                    
                }
            }];
        }
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
