//
//  IOCaptureVC.m
//  iosCodeUI
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "IOCaptureVC.h"
#import <AVFoundation/AVFoundation.h>
#import "Utility.h"
#import <Photos/Photos.h>
#import "PhotosFrameworksUtility.h"

@interface IOCaptureVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>{
    dispatch_queue_t dispatchQueueVideo;
    dispatch_queue_t dispatchQueueAudio;
}
//Camera
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput * activeVideoInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput * videoDataOutput;
@property (nonatomic,strong) AVCaptureAudioDataOutput * audioDataOutput;
@property (nonatomic,strong) AVAssetWriter * assetWriter;
@property (strong,nonatomic) AVAssetWriterInput * assetWriterVideoInput;
@property (strong,nonatomic) AVAssetWriterInput * assetWriterAudioInput;
@property (nonatomic,assign) bool isWriting;
@property (nonatomic,strong) NSURL * outputUrl;
//UI
@property(nonatomic,strong) UIButton * cameraBtn;
@property(nonatomic,strong) UIButton * switchCameraBtn;
@property(nonatomic,strong) UIButton * pictureBtn;

@end

@implementation IOCaptureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCamera];
    [self initView];
}

#pragma mark - init

-(void)initView{
    _cameraBtn=[UIButton new];
    _cameraBtn.backgroundColor=[UIColor redColor];
    _cameraBtn.frame=CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-140, 60, 60);
    [_cameraBtn setTitle:@"Start" forState:UIControlStateNormal];
    [_cameraBtn.layer setCornerRadius:30.0];
    [_cameraBtn addTarget:self action:@selector(startPause) forControlEvents:UIControlEventTouchUpInside];
    
    
    _switchCameraBtn=[UIButton new];
    _switchCameraBtn.backgroundColor=[UIColor grayColor];
    _switchCameraBtn.frame=CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-130, 40, 40);
    [_switchCameraBtn setTitle:@"[]" forState:UIControlStateNormal];
    [_switchCameraBtn.layer setCornerRadius:20.0];
    [_switchCameraBtn addTarget:self action:@selector(switchCameras) forControlEvents:UIControlEventTouchUpInside];
    
    
    _pictureBtn=[UIButton new];
    _pictureBtn.backgroundColor=[UIColor greenColor];
    _pictureBtn.frame=CGRectMake(60, SCREEN_HEIGHT-130, 40, 40);
    [_pictureBtn setTitle:@"" forState:UIControlStateNormal];
    [_pictureBtn.layer setCornerRadius:20.0];
    [_pictureBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.switchCameraBtn];
    [self.view addSubview:self.pictureBtn];
}

/**
 初始化相机
 */
-(void)initCamera{
    self.isWriting=NO;
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;     //表示输出的质量水平或比特率
    //1. AVCaptureDevice 获取默认的设备摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    //将设备添加到Session之前，先封装到AVCaptureDeviceInput对象
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    }
    //2. AVCaptureDevice 获取设备麦克风功能
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (audioInput) {
        if ([self.captureSession canAddInput:audioInput]) {
            //对于有效的input，添加到会话并给它传递捕捉设备的输入信息
            [self.captureSession addInput:audioInput];
        }
    }
    
    //3. AVCaptureVideoDataOutput 捕捉视频样本
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    //设置输出格式kCVPixelFormatType_32BGRA，结合OpenGL ES和CoreImage时这一格式非常适合。
    NSDictionary *outputSettigns = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    self.videoDataOutput.videoSettings = outputSettigns;
    //要记录输出内容，所以通常我们希望捕捉全部的可用帧
    //设置alwaysDiscardsLateVideoFrames为NO，会给委托方法一些额外的时间来处理样本buffer
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = NO;
    //设置SampleBuffer的委托
    dispatchQueueVideo = dispatch_queue_create("com.github.davidji80.iosCodeUI", NULL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:dispatchQueueVideo];
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
    }
    
    //4. AVCaptureVideoDataOutput 捕捉音频样本
    self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
    dispatchQueueAudio = dispatch_queue_create("com.github.davidji80.iosCodeUI", NULL);
    [self.audioDataOutput setSampleBufferDelegate:self queue:dispatchQueueAudio];
    if ([self.captureSession canAddOutput:self.audioDataOutput]) {
        [self.captureSession addOutput:self.audioDataOutput];
    }
    
    //创建图像预览层AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:previewLayer];
    //开始会话
    [self.captureSession startRunning];
}

#pragma mark - Event
/**
 开始和结束录制
 */
-(void)startPause{
    if (self.isWriting){
        self.isWriting=NO;
        [_cameraBtn setTitle:@"Start" forState:UIControlStateNormal];
        [self.assetWriterVideoInput markAsFinished];
        [self.assetWriter finishWritingWithCompletionHandler:^{
            AVAssetWriterStatus status = self.assetWriter.status;
            if (status == AVAssetWriterStatusCompleted) {
                [PhotosFrameworksUtility saveVideoAtUrl:self.outputUrl];
            } else {
                
            }
        }];
    }else{
        // 创建AVAssetWriter
        NSString *documentsDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)firstObject];
        NSURL *documentsDirUrl=[NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
        self.outputUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4",[Utility getNowTime]] relativeToURL:documentsDirUrl];
        NSError *wError;
        self.assetWriter = [[AVAssetWriter alloc] initWithURL:self.outputUrl fileType:AVFileTypeQuickTimeMovie error:&wError];
        // 创建AVAssetWriterInput
        NSString *fileType = AVFileTypeQuickTimeMovie;
        NSDictionary *videoSettings = [self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:fileType];
        self.assetWriterVideoInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
        //判断用户界面方向，为输入设置一个合适的转换。
        //写入会话期间，方向会按照这一设定保持不变。
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        //self.assetWriterVideoInput.transform = THTransformForDeviceOrientation(orientation);
        // 将AVAssetWriterInput添加到AVAssetWriter
        if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
            [self.assetWriter addInput:self.assetWriterVideoInput];
        }
        
        //创建AVAssetWriterInput附加AVCaptureAudioDataOutput样本
        NSDictionary *audioSettings = [self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:fileType];
        self.assetWriterAudioInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioSettings];
        self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;
        
        if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
            [self.assetWriter addInput:self.assetWriterAudioInput];
        }
        
        self.isWriting=YES;
        [_cameraBtn setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (self.isWriting) {
        //查看buffer的CMFormatDescription
        CMFormatDescriptionRef formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer);
        //使用CMFormatDescriptionGetMediaType判断媒体类型
        CMMediaType mediaType = CMFormatDescriptionGetMediaType(formatDesc);
        
        if (mediaType == kCMMediaType_Video) {
            if (self.assetWriter.status==AVAssetWriterStatusUnknown){
                // 开始写入数据
                [self.assetWriter startWriting];
                // 创建一个新的写入会话，传递资源样本的开始时间
                [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            }else{
                if ([self.assetWriterVideoInput isReadyForMoreMediaData]){
                    // 将样本附加到接收器
                    [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
                }
            }
        }else if(mediaType == kCMMediaType_Audio){
            if (self.assetWriterAudioInput.isReadyForMoreMediaData) {
                if (![self.assetWriterAudioInput appendSampleBuffer:sampleBuffer]) {
                    NSLog(@"Error appending audio sample buffer");
                }
            }
        }
        
    }
}





@end
