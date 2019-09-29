//
//  AVCaptureViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/6/11.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

API_AVAILABLE(ios(10.0))
@interface AVCaptureViewController ()<AVCaptureFileOutputRecordingDelegate,AVCapturePhotoCaptureDelegate>

@property (nonatomic,strong) AVCaptureSession * captureSession;
@property (nonatomic,strong) AVCaptureDeviceInput * activeVideoInput;
@property (nonatomic,strong) AVCaptureStillImageOutput * stillImageOutput;
@property (nonatomic,strong) AVCapturePhotoOutput * capturePhotoOutput;
@property (nonatomic,strong) AVCaptureMovieFileOutput * movieOutput;
@property (nonatomic,strong) NSURL * outputURL;

@property(nonatomic,strong) UIButton * cameraBtn;
@property(nonatomic,strong) UIButton * switchCameraBtn;
@property(nonatomic,strong) UIButton * pictureBtn;

@end

@implementation AVCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self simpleCapture];
    [self initCamera];
    [self initView];

    
}

#pragma mark - Simple Capture
/**
 创建简单捕捉会话
 */
-(void)simpleCapture{
    //1. 创建捕捉会话 AVCaptureSession
    AVCaptureSession * captureSession = [[AVCaptureSession alloc] init];
    //2. 设置session显示分辨率
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    //3. 获取摄像头device,并且默认使用的后置摄像头,并且将摄像头加入到captureSession中
    //创建获取捕捉设备 AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建捕捉输入 AVCaptureDeviceInput
    NSError *error;
    AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    //将捕捉输入加到会话中
    if (input) {
        if ([captureSession canAddInput:input]) {
            //首先检测是否能够添加输入，直接添加可能会有crash
            [captureSession addInput:input];
        }
    }else{
        
    }
    //4. 创建一个静态图片输出 AVCaptureStillImageOutput,10.0以上版本用AVCapturePhotoOutput
    AVCaptureOutput *imageOutput;
    if (@available(iOS 10.0, *)) {
        imageOutput = [[AVCapturePhotoOutput alloc] init];
    }else{
        /**
         4.1.
         创建拍照使用的AVCaptureStillImageOutput,
         并且注册observer观察capturingStillImage,并将output加入到session.
         使用observer的作用监控"capturingStillImage",如果为YES,那么表示开始截取视频帧.在回调方法中显示闪屏效果
         */
        imageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    //将捕捉输出添加到会话中
    if (imageOutput){
        if ([captureSession canAddOutput:imageOutput]) {
            //检测是否可以添加输出
            [captureSession addOutput:imageOutput];
        }
    }else{
        
    }
    
    
    //创建图像预览层AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    previewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:previewLayer];
    //开始会话
    [captureSession startRunning];
}

#pragma mark - Camera Demo
-(void)initCamera{
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;     //表示输出的质量水平或比特率
    
    //获取默认的设备摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //得到一个指向默认视频捕捉设备的指针
    NSError *error;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    //将设备添加到Session之前，先封装到AVCaptureDeviceInput对象
    if (videoInput) {
        if ([self.captureSession canAddInput:videoInput]) {
            [self.captureSession addInput:videoInput];
            self.activeVideoInput = videoInput;
        }
    } else {
    }
    //获取设备麦克风功能
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (audioInput) {
        if ([self.captureSession canAddInput:audioInput]) {
            //对于有效的input，添加到会话并给它传递捕捉设备的输入信息
            [self.captureSession addInput:audioInput];
        }
    } else {
    }
    
    AVCaptureOutput * imageOutput;
    //设置 静态图片输出
    if (@available(iOS 10.0, *)) {
        AVCapturePhotoOutput *capturePhotoOutput = [[AVCapturePhotoOutput alloc] init];
        capturePhotoOutput.highResolutionCaptureEnabled=YES;       //为高分辨率静态图像捕获配置捕获管道
        capturePhotoOutput.livePhotoCaptureEnabled=capturePhotoOutput.livePhotoCaptureSupported;
        self.capturePhotoOutput=capturePhotoOutput;
        imageOutput=self.capturePhotoOutput;
    }else{
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        imageOutput=self.stillImageOutput;
    }
    if (imageOutput){
        if ([self.captureSession canAddOutput:imageOutput]) {
            // 测试输出是否可以添加到捕捉对话，然后再添加
            [self.captureSession addOutput:imageOutput];
        }
    }
    //设置视频文件输出
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if (self.movieOutput){
        if ([self.captureSession canAddOutput:self.movieOutput]) {
            [self.captureSession addOutput:self.movieOutput];
            NSLog(@"add movie output success");
        }
    }
    
    //创建图像预览层AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:previewLayer];
    //开始会话
    [self startSession];
}

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

-(void)startPause{
    if (![self isRecording]){
        [_cameraBtn setTitle:@"Stop" forState:UIControlStateNormal];
        [self startRecording];
    }else{
        [_cameraBtn setTitle:@"Start" forState:UIControlStateNormal];
        [self stopRecording];
    }
}

-(void)takePicture{
    if (@available(iOS 10.0, *)) {
        [self captureCapturePhoto];
    }else{
        [self captureStillImage];
    }
}




#pragma mark - 开始和结束会话

/**
 获取全局异步队列
 */
- (dispatch_queue_t)globalQueue {
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

/**
 开始捕捉会话
 */
- (void)startSession {
    if (![self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            //开始会话 同步调用会消耗一定时间，所以用异步方式在videoQueue排队调用该方法，不会阻塞主线程。
            [self.captureSession startRunning];
        });
    }
}

/**
 停止捕捉会话
 */
- (void)stopSession {
    if ([self.captureSession isRunning]) {
        dispatch_async([self globalQueue], ^{
            [self.captureSession stopRunning];
        });
    }
}



#pragma mark - 拍摄视频
// 当前捕捉会话对应的摄像头，返回激活的捕捉设备输入的device属性
- (AVCaptureDevice *)activeCamera {
    return self.activeVideoInput.device;
}

- (void)startRecording {
    if ([self isRecording]) return;
    AVCaptureConnection * videoConnection = [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
    //将默认的HEVC格式更改为H.264
    if (@available(iOS 11.0, *)) {
        if ([self.movieOutput.availableVideoCodecTypes containsObject:AVVideoCodecTypeH264]) {
            [self.movieOutput setOutputSettings:@{AVVideoCodecKey: AVVideoCodecTypeH264} forConnection:videoConnection];
        }
    }
    if ([videoConnection isVideoStabilizationSupported]) {
        videoConnection.preferredVideoStabilizationMode = YES;
    }
    AVCaptureDevice *device = [self activeCamera];
    if (device.isSmoothAutoFocusEnabled) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.smoothAutoFocusEnabled = YES;
            [device unlockForConfiguration];
        } else {
            
        }
        //摄像头可以进行平滑对焦模式的操作，减慢摄像头镜头对焦的速度。
        //通常情况下，用户移动拍摄时摄像头会尝试快速自动对焦，这会在捕捉视频中出现脉冲式效果。
        //当平滑对焦时，会较低对焦操作的速率，从而提供更加自然的视频录制效果。
    }
    self.outputURL = [self uniqueURL];
    NSLog(@"url %@",self.outputURL);
    [self.movieOutput startRecordingToOutputFileURL:self.outputURL recordingDelegate:self];
    // 查找写入捕捉视频的唯一文件系统URL。保持对地址的强引用，这个地址在后面处理视频时会用到
    // 添加代理，处理回调结果。
}

// 设置存储路径
- (NSURL *)uniqueURL {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directionPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"camera_movie"];
    
    NSLog(@"unique url ：%@",directionPath);
    if (![fileManager fileExistsAtPath:directionPath]) {
        [fileManager createDirectoryAtPath:directionPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [directionPath stringByAppendingPathComponent:@"camera_movie.mov"];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    return [NSURL fileURLWithPath:filePath];
    
    return nil;
}

// 停止录制
- (void)stopRecording {
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
}

// 验证录制状态
- (BOOL)isRecording {
    return self.movieOutput.isRecording;
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


#pragma mark -- AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    NSLog(@"capture output");
    if (error) {
        NSLog(@"record error :%@",error);
    } else {
        // 没有错误的话在存储响应的路径下已经完成视频录制，可以通过url访问该文件。
        [self saveVideoAtUrl:self.outputURL];
        
    }
    self.outputURL = nil;
}


#pragma mark - 拍摄照片
#pragma mark -- AVCaptureStillImageOutput
- (void)captureStillImage {
    NSLog(@"still Image");
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    id handler = ^(CMSampleBufferRef sampleBuffer,NSError *error) {
        if (sampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];
            //这就得到了拍摄到的图片，可以做响应处理。
            [self saveToPhotoAlbum:image];
        } else {
            NSLog(@"NULL sampleBuffer :%@",[error localizedDescription]);
        }
    };
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:handler];
}

/**
 保存图片到相册
 */
-(void)saveToPhotoAlbum:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",@"保存失败");
        } else {
            NSLog(@"%@",@"保存成功");
        }
    }];
}

/**
 保存图片到沙盒
 */
- (void)saveImage:(UIImage *)image {
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"demo.png"]];                     // 保存文件的名称
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];  // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
}

#pragma mark -- AVCapturePhotoOutput
- (void)captureCapturePhoto {
    if (@available(iOS 10.0, *)) {
        AVCapturePhotoSettings * capturePhotoSettings=[AVCapturePhotoSettings new];
        capturePhotoSettings.flashMode=AVCaptureFlashModeAuto;
        capturePhotoSettings.autoStillImageStabilizationEnabled=_capturePhotoOutput.isStillImageStabilizationSupported;
        [self.capturePhotoOutput capturePhotoWithSettings:capturePhotoSettings delegate:self];
    }
}

#pragma mark --- AVCapturePhotoCaptureDelegate
- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    NSLog(@"Capture Photo did Finish");
    // 这个就是HEIF(HEIC)的文件数据,直接保存即可
    NSData *data = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:data];
    [self saveToPhotoAlbum:image];
}

#pragma mark - 切换摄像头
/**
 返回可用视频捕捉设备的数量
 devicesWithMediaType不推荐使用了
 */
- (NSUInteger)cameraCount {
    // 1. 使用devicesWithMediaType实现（不推荐使用）
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    //2. 使用AVCaptureDeviceDiscoverySession实现
    /**
    if (@available(iOS 10.2, *)) {
        AVCaptureDeviceDiscoverySession *discoverySession=[AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDualCamera,AVCaptureDeviceTypeBuiltInWideAngleCamera,AVCaptureDeviceTypeBuiltInTelephotoCamera,AVCaptureDeviceTypeBuiltInMicrophone] mediaType:AVMediaTypeAudio position:AVCaptureDevicePositionUnspecified];
        return discoverySession.devices.count;
    } else {
        return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    }
     */
}

/**
 是否可以切换摄像头
 */
- (BOOL)canSwitchCameras {
    return self.cameraCount > 1;
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

/**
 返回当前未激活摄像头
 */
- (AVCaptureDevice *)inactiveCamera {
    AVCaptureDevice *device = nil;
    if (self.cameraCount > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

/**
 切换的摄像头
 */
- (BOOL)switchCameras {
    //验证是否有可切换的摄像头
    if (![self canSwitchCameras]) {
        return NO;
    }
    
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    //g根据指定设备初始化AVCaptureDeviceInput
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
    } else {
        return NO;
    }
    return YES;
}


@end
