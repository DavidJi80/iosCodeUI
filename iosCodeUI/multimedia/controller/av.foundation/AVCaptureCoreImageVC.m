//
//  AVCaptureCoreImageVC.m
//  iosCodeUI
//
//  Created by mac on 2019/7/9.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVCaptureCoreImageVC.h"
#import <AVFoundation/AVFoundation.h>

@interface AVCaptureCoreImageVC ()<AVCaptureVideoDataOutputSampleBufferDelegate>

//AVFoundation
@property (strong, nonatomic) AVCaptureSession * session;
@property (strong, nonatomic) AVCaptureVideoDataOutput * videoOutput;
@property (strong, nonatomic) dispatch_queue_t queue;                    //录制的数据传出的队列

//UI
@property(nonatomic,strong) UIImageView * outputImageView;

@end

@implementation AVCaptureCoreImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initCapture];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)initView{
    _outputImageView=[UIImageView new];
    _outputImageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _outputImageView.contentMode =  UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.outputImageView];
}


#pragma mark - AVFountion Capture
/**
 创建简单捕捉会话
 */
-(void)initCapture{
    //1. 视频输入
    AVCaptureDevice * video = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:video error:nil];
    //2. AVCaptureSession
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    }
    _session = session;
    
    //3. 视频输出
    _queue = dispatch_queue_create("DataOutputQueue", DISPATCH_QUEUE_SERIAL);
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,nil];
    _videoOutput = [AVCaptureVideoDataOutput new];
    _videoOutput.videoSettings = videoSettings;
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [_videoOutput setSampleBufferDelegate:self queue:self.queue];
    if ([session canAddOutput:_videoOutput]){
        [session addOutput:_videoOutput];
    }
    
    /**
    //创建图像预览层AVCaptureVideoPreviewLayer
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    previewLayer.frame = self.view.frame;
    [self.view.layer addSublayer:previewLayer];
     */
    
    //开始会话
    [session startRunning];
}



#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage * sourceImage = [CIImage imageWithCVPixelBuffer:(CVPixelBufferRef)imageBuffer options:nil];
    CIImage * sepiaCIImage = [self sepiaFilterImage:sourceImage withIntensity:0.9];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.outputImageView.image = [UIImage imageWithCIImage:sepiaCIImage];
    });
}

#pragma mark - CoreImage
- (CIImage*) sepiaFilterImage: (CIImage*)inputImage withIntensity:(CGFloat)intensity{
    CIFilter* sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:inputImage forKey:kCIInputImageKey];
    [sepiaFilter setValue:@(intensity) forKey:kCIInputIntensityKey];
    return sepiaFilter.outputImage;
}


@end
