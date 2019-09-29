//
//  AnimationDemoVC.m
//  iosCodeUI
//
//  Created by mac on 2019/9/10.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AnimationDemoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "Utility.h"
#import "PhotosFrameworksUtility.h"

@interface AnimationDemoVC (){
    CGMutablePathRef thePath;
    CGMutablePathRef videoPath;
    CGPoint lastPoint;
    CGPoint middlePoint;
    CGPoint nextPoint;
    int fbs;
    NSTimeInterval beginTime,endTime;
    CGSize videoSize;
}
@property (nonatomic,strong) CALayer * testLayer;
@property (nonatomic,assign) Boolean isPlay;
@property (nonatomic,strong) AVPlayer * player;
@property (nonatomic,strong) AVAsset * asset;
@end

@implementation AnimationDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    fbs=0;
    _isPlay=NO;
    [self initVideo];
    [self initAnimation];
}

-(void)initNavigation{
    UIBarButtonItem * exportBBI=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:(UIBarButtonItemStylePlain) target:self action:@selector(exportCompositionHaveAnimation)];
    self.navigationItem.rightBarButtonItems=@[exportBBI];
}


#pragma mark - Layer

-(void)initAnimation{
    self.testLayer = ({
        CALayer *tempLayer = [CALayer new];
        UIImage *image = [UIImage imageNamed:@"basketball80.png"];
        //内容
        tempLayer.contents=(id)image.CGImage;                       //内容
        //图层的外观
        tempLayer.opacity=1.0;                                      //不透明度
        tempLayer.hidden=NO;                                        //是否显示
        tempLayer.cornerRadius=30;                                  //圆角
        tempLayer.borderWidth=0;                                    //边框的宽度
        tempLayer.shadowOpacity=1;                                  //阴影的不透明度
        tempLayer.shadowRadius=5;                                   //阴影的半径
        tempLayer.shadowOffset=CGSizeMake(5.0, 5.0);                //阴影的偏移量
        tempLayer.shadowColor=UIColor.grayColor.CGColor;            //阴影的颜色
        //图层的几何形状
        tempLayer.bounds = CGRectMake(0, 0, 60, 60);                //边界
        tempLayer.position = self.view.center;                      //位置
        
        [self.view.layer addSublayer:tempLayer];
        tempLayer;
    });
}

-(CGPoint)calPoint:(CGPoint)point{
    CGFloat showYOffset=100;
    CGFloat ratio=videoSize.width/SCREEN_WIDTH;
    CGFloat x=point.x;
    CGFloat y=point.y;
    CGFloat x1=x;
    CGFloat y1=y-showYOffset;
    CGFloat x2=x1*ratio;
    CGFloat y2=y1*ratio;
    y2=videoSize.height-y2;
    return CGPointMake(x2, y2);
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_isPlay){
        [self.player play];
        _isPlay=YES;
    }
    beginTime = [NSDate date].timeIntervalSince1970;
    NSLog(@"Begin Time:%f",beginTime);
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    lastPoint=point;
    middlePoint=point;
    nextPoint=point;
    thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,point.x,point.y);
    CGPoint cPoint=[self calPoint:point];
    videoPath = CGPathCreateMutable();
    CGPathMoveToPoint(videoPath,NULL,cPoint.x,cPoint.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    fbs++;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (fbs==1){
        middlePoint=point;
    }else if (fbs>1){
        nextPoint=point;
        lastPoint=point;
        fbs=0;
        CGPathAddCurveToPoint(thePath,NULL,lastPoint.x,lastPoint.y,
                              middlePoint.x,middlePoint.y,
                              nextPoint.x,nextPoint.y);
        CGPoint cLastPoint=[self calPoint:lastPoint];
        CGPoint cMiddlePoint=[self calPoint:middlePoint];
        CGPoint cNextPoint=[self calPoint:nextPoint];
        CGPathAddCurveToPoint(videoPath,NULL,cLastPoint.x,cLastPoint.y,
                              cMiddlePoint.x,cMiddlePoint.y,
                              cNextPoint.x,cNextPoint.y);
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    endTime = [NSDate date].timeIntervalSince1970;
    NSLog(@"End Time:%f",endTime-beginTime);
    
    CAShapeLayer *positionTrackLayer = [[CAShapeLayer alloc] init];
    positionTrackLayer.path = thePath;
    positionTrackLayer.strokeColor = [UIColor redColor].CGColor;
    positionTrackLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:positionTrackLayer];
    [self execKeyframeAnimation2:endTime-beginTime];
    
}

-(void)execKeyframeAnimation2:(double)duration{
    CAKeyframeAnimation * theAnimation;
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=duration;
    [self.testLayer addAnimation:theAnimation forKey:@"position"];
}

-(void)initVideo{
    NSURL * nsUrl=[NSURL URLWithString:@"file:///private/var/mobile/Media/DCIM/106APPLE/IMG_6399.MP4"];
    NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
    self.asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
    //获取视频尺寸
    AVAssetTrack *assetVideoTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    videoSize = assetVideoTrack.naturalSize;
    
    AVPlayerItem * playerItem=[AVPlayerItem playerItemWithAsset:self.asset];
    self.player=[AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer * avPlayerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    avPlayerLayer.frame=CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH*9/16);
    avPlayerLayer.backgroundColor=UIColor.blackColor.CGColor;
    //self.avPlayerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:avPlayerLayer];
}

-(AVVideoComposition *)configVideoCompositionHaveAnimation:(AVAsset * )avAsset{
    //固定样式的动画
    CALayer *tempLayer = [CALayer new];
    UIImage *image = [UIImage imageNamed:@"basketball80.png"];
    tempLayer.contents=(id)image.CGImage;                       //内容
    tempLayer.opacity=1.0;                                      //不透明度
    tempLayer.cornerRadius=25;                                  //圆角
    tempLayer.bounds = CGRectMake(0, 0, 50, 50);                //边界
    tempLayer.position = CGPointMake(900.0, 100.0);             //位置
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,900.0,100.0);
    CGPathAddCurveToPoint(thePath,NULL,900.0,300,
                          930.0,300.0,
                          930.0,100.0);
    CGPathAddCurveToPoint(thePath,NULL,930.0,200.0,
                          960.0,200.0,
                          960.0,100.0);
    CGPathAddCurveToPoint(thePath,NULL,960.0,300.0,
                          900.0,300.0,
                          900.0,100.0);
    //位移动画
    CAKeyframeAnimation * theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.removedOnCompletion = NO;
    theAnimation.repeatCount = 4;
    theAnimation.duration = 2.0f;
    theAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    theAnimation.fillMode = kCAFillModeForwards;
    //[tempLayer addAnimation:theAnimation forKey:@"position"];
    //旋转动画
    CABasicAnimation* transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:0.0];
    transformAnim.toValue = [NSNumber numberWithFloat:100.0];
    transformAnim.duration = 8.0;
    transformAnim.beginTime = AVCoreAnimationBeginTimeAtZero;
    //[tempLayer addAnimation:transformAnim forKey:@"rotateAnimation"];
    
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
    groupAnimation.animations = @[transformAnim,theAnimation];//将所有动画添加到动画组
    groupAnimation.duration = 8.f;
    groupAnimation.repeatCount = 1;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    [tempLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    
    // 光柱动画
    CALayer *lightLayer = [CALayer new];
    UIImage *lightImg = [UIImage imageNamed:@"crown.png"];
    lightLayer.contents=(id)lightImg.CGImage;
    lightLayer.opacity=1.0;
    lightLayer.bounds = CGRectMake(0, 0, 60, 60);
    CAKeyframeAnimation * lightAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    lightAnimation.path=videoPath;
    lightAnimation.duration=endTime-beginTime;
    lightAnimation.removedOnCompletion = NO;
    lightAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    lightAnimation.fillMode = kCAFillModeForwards;
    [lightLayer addAnimation:lightAnimation forKey:@"position"];
    
    // 动画叠加层 overlayLayer
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [overlayLayer setMasksToBounds:YES];
    [overlayLayer addSublayer:lightLayer];
    [overlayLayer addSublayer:tempLayer];
    
    // 视频层
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    
    // 合成动画后的最终层
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:overlayLayer];
    
    // AVVideoComposition
    AVMutableVideoComposition * videoComposition=[AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:avAsset];
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool
                                      videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    return [videoComposition copy];
}

/**
 导出动画的合并视频
 */
-(void)exportCompositionHaveAnimation{
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.asset copy] presetName:preset];
    NSURL * outputURL=[Utility generateNSURL];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.videoComposition=[self configVideoCompositionHaveAnimation:self.asset];
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
            NSLog(@"文件大小：%lld",exportSession.estimatedOutputFileLength);
            [PhotosFrameworksUtility saveVideoAtUrl:outputURL];
        }else{
            NSLog(@"当前压缩进度:%f",exportSession.progress);
        }
        NSLog(@"%@",exportSession.error);
    }];
}


@end
