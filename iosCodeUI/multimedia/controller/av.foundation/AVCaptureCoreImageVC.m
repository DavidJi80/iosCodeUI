//
//  AVCaptureCoreImageVC.m
//  iosCodeUI
//
//  Created by mac on 2019/7/9.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVCaptureCoreImageVC.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import <GLKit/GLKit.h>

@interface AVCaptureCoreImageVC ()

@property (strong , nonatomic) EAGLContext *eaglContext;
@property (strong , nonatomic) GLKView *videoPreviewView;

//AVFoundation
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioOutput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoOutput;
/**
 录制的数据传出的队列
 */
@property (strong, nonatomic) dispatch_queue_t queue;

@end

@implementation AVCaptureCoreImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCamera];
}

- (void)loadView{
    UIView *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    _videoPreviewView = [[GLKView alloc] initWithFrame:window.bounds context:_eaglContext];
    _videoPreviewView.enableSetNeedsDisplay = NO;
    /**
     because the native video image from the back camera is in UIDeviceOrientationLandscapeLeft
     (i.e. the home button is on the right),we need to apply a clockwise 90 degree transform so
     that we can draw the video preview as if we were in a landscape-oriented view; if you're
     using the front camera and you want to have a mirrored preview (so that the user is seeing
     themselves in the mirror), you need to apply an additional horizontal flip (by concatenating
     CGAffineTransformMakeScale(-1.0, 1.0) to the rotation transform)
     因为从后置摄像头获取的原始视频图像在UIDeviceOrientationLandscapeLeft(即HOME按钮在右边),
     我们需要顺时针方向变换90度,这样能呈现好像我们是在面向景观视频预览;如果您使用的是前置摄像头，
     并且希望得到镜像预览(以便用户在镜子中看到自己)，则需要应用额外的水平翻转
     (通过将CGAffineTransformMakeScale(-1.0, 1.0)连接到旋转转换)
     */
    _videoPreviewView.transform = CGAffineTransformMakeRotation(M_PI_2);
    _videoPreviewView.frame = window.bounds;
    /**
     we make our video preview view a subview of the window, and send it to the back; this makes
     FHViewController's view (and its UI elements) on top of the video preview, and also makes
     video preview unaffected by device rotation
     使我们的视频预览视图作为窗口的子视图，并将其发送到后面;这使得FHViewController的视图(及其UI元素)之上的视频预览，
     并使
     不受设备旋转影响的视频预览
     */
    [window addSubview:_videoPreviewView];
    [window sendSubviewToBack:_videoPreviewView];
}

#pragma mark - Camera Demo
-(void)initCamera{
    //视频输入
    AVCaptureDevice *video = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:video error:nil];
    
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    if ([session canAddInput:videoInput]) {
        [session addInput:videoInput];
    }
    _session = session;
    [session startRunning];
    //视频输出
    _queue = dispatch_queue_create("DataOutputQueue", DISPATCH_QUEUE_SERIAL);
    
    _videoOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
                                   nil];
    _videoOutput.videoSettings = videoSettings;
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    [_videoOutput setSampleBufferDelegate:self queue:self.queue];
    if ([session canAddOutput:_videoOutput]){
        [session addOutput:_videoOutput];
    }
    AVCaptureConnection *connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    //音频输出
    _audioOutput = [AVCaptureAudioDataOutput new];
    [_audioOutput setSampleBufferDelegate:self queue:self.queue];
    if ([session canAddOutput:_audioOutput]){
        [session addOutput:_audioOutput];
    }
}

@end
