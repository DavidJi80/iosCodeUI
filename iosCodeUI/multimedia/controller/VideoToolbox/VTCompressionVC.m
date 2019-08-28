//
//  VTCompressionVC.m
//  iosCodeUI
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VTCompressionVC.h"

@interface VTCompressionVC ()

@property (assign, nonatomic) VTCompressionSessionRef compressionSessionRef;

@end

@implementation VTCompressionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCompression];
}

#pragma mark - VTCompressionSession

-(void)initCompression{
    /**
     创建用于压缩视频帧的会话
     
     @allocator：
     内存分配器，填NULL为默认分配器
     @width、height：
     视频帧像素的宽高，如果编码器不支持这个宽高的话可能会改变
     @codecType：
     编码类型，枚举
     @encoderSpecification：
     指定特定的编码器，填NULL的话由VideoToolBox自动选择
     @sourceImageBufferAttributes：
     源像素缓冲区的属性，用于为源帧创建像素缓冲池。
     如果这个参数有值的话，VideoToolBox会创建一个缓冲池，不需要缓冲池可以设置为NULL。
     使用VideoToolbox没有分配的像素缓冲区可能会增加复制图像数据的机会。
     @compressedDataAllocator：
     压缩后数据的内存分配器，填NULL使用默认分配器
     @outputCallback：
     视频压缩后输出数据的回调函数。
     这个函数在调用VTCompressionSessionEncodeFrame的线程上被异步调用。
     NULL，为编码帧调用VTCompressionSessionEncodeFrameWithOutputHandler时调用。
     @outputCallbackRefCon：
     回调函数中的自定义指针，我们通常传self，在回调函数中就可以拿到当前类的方法和属性了
     @compressionSessionOut：
     编码器句柄，传入编码器的指针
     */
    OSStatus status = VTCompressionSessionCreate(
                             NULL,
                             180,
                             320,
                             kCMVideoCodecType_H264,
                             NULL,
                             NULL,
                             NULL,
                             encodeOutputDataCallback,
                             (__bridge void *)(self),
                             &_compressionSessionRef
                             );
    if (noErr != status){
        NSLog(@"VEVideoEncoder::VTCompressionSessionCreate:failed status:%d", (int)status);
    }
    
    if (NULL == self.compressionSessionRef){
        NSLog(@"VEVideoEncoder::调用顺序错误");
    }
}

/**
 当帧压缩完成时调用回调函数
 
 @param outputCallbackRefCon
 回调函数的引用值。
 @param sourceFrameRefCon
 帧的参考值，从sourceFrameRefCon参数复制到VTCompressionSessionEncodeFrame。
 @param status
 如果压缩成功则返回noErr；如果压缩不成功，则发出错误代码。
 @param infoFlags
 包含有关编码操作的信息。
 如果编码是异步运行的，则设置kVTEncodeInfo_Asynchronous。
 如果帧被丢弃，则设置kVTEncodeInfo_FrameDropped。
 @param sampleBuffer
 如果压缩成功且没有删除该帧，则包含该压缩帧；否则,空。
 */
void encodeOutputDataCallback(void * CM_NULLABLE outputCallbackRefCon, void * CM_NULLABLE sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CM_NULLABLE CMSampleBufferRef sampleBuffer){
    
}

/**
 输入待编码数据
 
 @param sampleBuffer 待编码数据
 @param forceKeyFrame 是否强制I帧
 @return 结果
 */
- (BOOL)videoEncodeInputData:(CMSampleBufferRef)sampleBuffer forceKeyFrame:(BOOL)forceKeyFrame{
    if (NULL == _compressionSessionRef){
        return NO;
    }
    
    if (nil == sampleBuffer){
        return NO;
    }
    
    CVImageBufferRef pixelBuffer = (CVImageBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    NSDictionary *frameProperties = @{(__bridge NSString *)kVTEncodeFrameOptionKey_ForceKeyFrame: @(forceKeyFrame)};
    
    /**
     向编码器输送待编码的视频数据
     
     @session：
     创建编码器时的句柄
     @imageBuffer：
     包含要压缩的视频帧的CVImageBufferRef。
     YUV数据，iOS通过摄像头采集出来的视频流数据类型是CMSampleBufferRef，我们要从里面拿到CVImageBufferRef来进行编码。
     通过CMSampleBufferGetImageBuffer方法可以从sampleBuffer中获得imageBuffer。
     @presentationTimeStamp：
     要附加到样本缓冲区的帧表示时间戳。传递给会话的表示时间戳必须大于前一个。单位是毫秒
     @duration：
     这一帧的持续时间，如果没有持续时间，填kCMTimeInvalid
     @frameProperties：
     指定此帧编码的附加属性的键/值对。注意，一些会话属性也可能在帧之间更改。这些变化会影响随后编码的帧。
     @encodeParams：
     帧的引用值，该值传递给输出回调函数。
     @infoFlagsOut：
     指向VTEncodeInfoFlags的指针，用于接收有关编码操作的信息。
     如果编码是异步的，则设置kVTEncodeInfo_Asynchronous。
     如果帧被删除(同步)，则设置kVTEncodeInfo_FrameDropped。
     如果不希望接收此信息，则传递NULL。
     */
    OSStatus status = VTCompressionSessionEncodeFrame(_compressionSessionRef, pixelBuffer, kCMTimeInvalid, kCMTimeInvalid, (__bridge CFDictionaryRef)frameProperties, NULL, NULL);
    if (noErr != status){
        NSLog(@"VEVideoEncoder::VTCompressionSessionEncodeFrame failed! status:%d", (int)status);
        return NO;
    }
    return YES;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

/**
 摄像头采集的数据回调
 
 @param output 输出设备
 @param sampleBuffer 帧缓存数据，描述当前帧信息
 @param connection 连接
 */
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    CMFormatDescriptionRef formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    //使用CMFormatDescriptionGetMediaType判断媒体类型
    CMMediaType mediaType = CMFormatDescriptionGetMediaType(formatDesc);
    if (mediaType == kCMMediaType_Video) {
        [self videoEncodeInputData:sampleBuffer forceKeyFrame:NO];
    }
}



@end
