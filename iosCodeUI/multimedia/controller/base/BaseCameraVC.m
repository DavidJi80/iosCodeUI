//
//  BaseCameraVC.m
//  iosOpenCV
//
//  Created by mac on 2019/8/19.
//  Copyright © 2019 David Ji. All rights reserved.
//

#import "BaseCameraVC.h"

@interface BaseCameraVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>{
    dispatch_queue_t dispatchQueueVideo;
    dispatch_queue_t dispatchQueueAudio;
}

//Camera
@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput * activeVideoInput;
@property (nonatomic,strong) AVCaptureVideoDataOutput * videoDataOutput;
@property (nonatomic,strong) AVCaptureAudioDataOutput * audioDataOutput;
//UI
@property(nonatomic,strong) UIButton * backBtn;
@property(nonatomic,strong) UIButton * positionBtn;
@property(nonatomic,strong) UIButton * cameraBtn;
@property(nonatomic,strong) UIButton * pictureBtn;


@end

@implementation BaseCameraVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCamera];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - init

/**
 初始化相机
 */
-(void)initCamera{
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

/**
 UI
 */
-(void)initView{
    _backBtn=[UIButton new];
    _backBtn.backgroundColor=[UIColor brownColor];
    _backBtn.frame=CGRectMake(10, 30, 60, 30);
    [_backBtn.layer setCornerRadius:10.0];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _positionBtn=[UIButton new];
    _positionBtn.backgroundColor=[UIColor brownColor];
    _positionBtn.frame=CGRectMake(SCREEN_WIDTH-70, 30, 60, 30);
    [_positionBtn.layer setCornerRadius:10.0];
    [_positionBtn setTitle:@"后置" forState:UIControlStateNormal];
    [_positionBtn addTarget:self action:@selector(changePosition:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_positionBtn];
    
    _cameraBtn=[UIButton new];
    _cameraBtn.backgroundColor=[UIColor redColor];
    _cameraBtn.frame=CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-140, 60, 60);
    [_cameraBtn setTitle:@"Start" forState:UIControlStateNormal];
    [_cameraBtn.layer setCornerRadius:30.0];
    [self.view addSubview:self.cameraBtn];
    
    _pictureBtn=[UIButton new];
    _pictureBtn.backgroundColor=[UIColor greenColor];
    _pictureBtn.frame=CGRectMake(60, SCREEN_HEIGHT-130, 40, 40);
    [_pictureBtn setTitle:@"" forState:UIControlStateNormal];
    [_pictureBtn.layer setCornerRadius:20.0];
    [_pictureBtn addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pictureBtn];
}

#pragma mark - Event
-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 切换的摄像头
 */
-(void)changePosition:(UIButton*)sender{
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    //根据指定设备初始化AVCaptureDeviceInput
    NSError *error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [self.captureSession beginConfiguration];
        // 标注源自配置变化的开始
        [self.captureSession removeInput:self.activeVideoInput];
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        } else if (self.activeVideoInput) {
            [self.captureSession addInput:self.activeVideoInput];
        }
        [self.captureSession commitConfiguration];
    }
}

/**
返回当前未激活摄像头
*/
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.activeVideoInput.device.position == AVCaptureDevicePositionBack) {
        device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        [_positionBtn setTitle:@"前置" forState:UIControlStateNormal];
    } else {
        device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        [_positionBtn setTitle:@"后置" forState:UIControlStateNormal];
    }
    return device;
}

/**
 返回指定位置的AVCaptureDevice
 有效位置为 AVCaptureDevicePositionFront 和 AVCaptureDevicePositionBack，
 遍历可用视频设备，并返回position参数对应的值
 */
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device  in devices) {
        if (device.position  == position) {
            return device;
        }
    }
    return nil;
}


@end
