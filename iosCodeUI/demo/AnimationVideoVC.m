//
//  AnimationVideoVC.m
//  iosCodeUI
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AnimationVideoVC.h"
#import "AVAssetFrameCV.h"
#import "FrameAsset.h"
#import "Utility.h"
#import "PhotosFrameworksUtility.h"

@interface AnimationVideoVC ()<AVAssetFrameCVDelegate>{
    CGSize videoSize;
}

@property (nonatomic,strong) AVAssetFrameCV * frameCollectionView;
@property (nonatomic,strong) UIImageView * frameImageView;

@property (nonatomic,strong) CALayer * testLayer;

@property (nonatomic,assign) NSInteger curIndex;

@end

@implementation AnimationVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initUI];
    
    AVAssetTrack *assetVideoTrack = [[self.avAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    videoSize = assetVideoTrack.naturalSize;
    [self generateFrames:_avAsset];
    
    [self initAnimation];
}

-(void)initNavigation{
    UIBarButtonItem * exportBBI=[[UIBarButtonItem alloc]initWithTitle:@"导出" style:(UIBarButtonItemStylePlain) target:self action:@selector(exportCompositionHaveAnimation)];
    self.navigationItem.rightBarButtonItems=@[exportBBI];
}

-(void)initUI{
    _frameImageView=[UIImageView new];
    _frameImageView.frame=CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH*9/16);
    //_frameImageView.backgroundColor=UIColor.redColor;
    [self.view addSubview:_frameImageView];
    
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;       // 定义滚动方式
    flowLayout.minimumLineSpacing = 1;                                          // 定义垂直间隔
    flowLayout.minimumInteritemSpacing=1;                                       // 定义水平间隔
    flowLayout.itemSize = CGSizeMake(160, 90);         // 定义item的大小
    _frameCollectionView=[[AVAssetFrameCV alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-150, SCREEN_WIDTH, 90) collectionViewLayout:flowLayout];
    //_frameCollectionView.backgroundColor=UIColor.redColor;
    _frameCollectionView.frameDataSource=[self getFrameDataSource:_avAsset];
    _frameCollectionView.frameCVDelegate=self;
    [self.view addSubview:_frameCollectionView];
    
}

-(NSMutableArray *)getFrameDataSource:(AVAsset *)avAsset{
    //视频总秒数
    CMTime cmTime = avAsset.duration;
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    int secend = timeInterVal;
    NSMutableArray * frameAssets=[NSMutableArray array];
    for (int i = 0; i < secend*2; i++) {
        [frameAssets addObject:[FrameAsset new]];
    }
    return frameAssets;
}

#pragma mark - AVAssetImageGenerator
/**
 异步取帧
 */
-(void)generateFrames:(AVAsset *)avAsset{
    //视频总秒数
    CMTime cmTime = avAsset.duration;
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    int secend = timeInterVal;
    //一秒取一帧
    NSMutableArray * specifiedTimes=[NSMutableArray array];
    
    for (int i = 0; i < secend*2; i++) {
        CMTime timeFrame = CMTimeMake(i, 2);
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [specifiedTimes addObject:timeValue];
        
    }
    //定义图片生成器
    AVAssetImageGenerator * generator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    //开始异步取帧
    //__weak __typeof(self) weakSelf=self;
    [generator generateCGImagesAsynchronouslyForTimes:specifiedTimes completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        NSLog(@"requestedTime-----: (%f)", CMTimeGetSeconds(requestedTime));
        NSLog(@"actualTime-----: (%f)", CMTimeGetSeconds(actualTime));
        NSInteger index=requestedTime.value;
        
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                
                UIImage * frameImg = [UIImage imageWithCGImage:image];
                [self.frameCollectionView.frameDataSource objectAtIndex:index].frameImage = frameImg;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.frameCollectionView reloadData];
                });
                
            }
                break;
        }
        
    }];
}

- (void)showImage:(UIImage *)image  index:(NSInteger)index{
    _frameImageView.image=image;
    _curIndex=index;
}



#pragma mark - Layer

-(void)initAnimation{
    self.testLayer = ({
        CALayer *tempLayer = [CALayer new];
        UIImage *image = [UIImage imageNamed:@"crown.png"];
        //内容
        tempLayer.contents=(id)image.CGImage;                       //内容
        //tempLayer.contentsRect=CGRectMake(0.2, 0.2, 0.6, 0.6);      //部分矩形(单元坐标空间)
        //
        //tempLayer.delegate=self;
        //图层的外观
        tempLayer.opacity=1.0;                                      //不透明度
        tempLayer.hidden=NO;                                        //是否显示
        //tempLayer.cornerRadius=6;                                  //圆角
        tempLayer.borderWidth=0;                                    //边框的宽度
        tempLayer.borderColor=UIColor.blackColor.CGColor;           //边框的颜色
        //tempLayer.backgroundColor = [UIColor redColor].CGColor;     //背景颜色
        tempLayer.shadowOpacity=1;                                  //阴影的不透明度
        tempLayer.shadowRadius=5;                                   //阴影的半径
        tempLayer.shadowOffset=CGSizeMake(5.0, 5.0);                //阴影的偏移量
        tempLayer.shadowColor=UIColor.grayColor.CGColor;            //阴影的颜色
        //图层的几何形状
        tempLayer.bounds = CGRectMake(0, 0, 12, 12);                //边界
        tempLayer.position = self.view.center;                      //位置
        
        [self.view.layer addSublayer:tempLayer];
        tempLayer;
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"touchesMoved[%lf,%lf]",point.x,point.y);
    [self.frameCollectionView.frameDataSource objectAtIndex:_curIndex].point = point;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.frameCollectionView reloadData];
    });
    [self basicAnimation:touches];
}

/**
 CABasicAnimation
 */
-(void)basicAnimation:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //CABasicAnimation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //CABasicAnimation 篡改值
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.testLayer.presentationLayer.position]; //开始篡改的值
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];                                       //结束篡改的值
    //CAMediaTiming
    positionAnimation.duration = 0.1f;                   //动画时长
    positionAnimation.fillMode = kCAFillModeForwards;   //动画结束后是否保持状态
    //CAAnimation 动画属性
    positionAnimation.removedOnCompletion = NO;         //是否在完成时移除
    
    [self.testLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
}

/**
 导出动画的合并视频
 */
-(void)exportCompositionHaveAnimation{
    NSString *preset = AVAssetExportPresetHighestQuality;
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.avAsset copy] presetName:preset];
    NSURL * outputURL=[Utility generateNSURL];
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.videoComposition=[self configVideoCompositionHaveAnimation:self.avAsset];
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

-(AVVideoComposition *)configVideoCompositionHaveAnimation:(AVAsset * )avAsset{
    // 1. 跟随动画
    //视频总秒数
    CMTime cmTime = self.avAsset.duration;
    NSTimeInterval timeInterVal=CMTimeGetSeconds(cmTime);
    //int secend = timeInterVal;
    
    CGMutablePathRef videoPath = CGPathCreateMutable();
    for(int i=0;i<self.frameCollectionView.frameDataSource.count;i++){
        FrameAsset * frameAsset=[self.frameCollectionView.frameDataSource objectAtIndex:i];
        if (i==0){
            CGPoint cNowPoint=[self calPoint:frameAsset.point];
             CGPathMoveToPoint(videoPath,NULL,cNowPoint.x,cNowPoint.y);
        }else{
            FrameAsset * lastFrameAsset=[self.frameCollectionView.frameDataSource objectAtIndex:i-1];
            CGPoint cLastPoint=[self calPoint:lastFrameAsset.point];
            CGPoint cNowPoint=[self calPoint:frameAsset.point];
            CGPathAddQuadCurveToPoint(videoPath, NULL, cLastPoint.x, cLastPoint.y, cNowPoint.x, cNowPoint.y);
        }
        
    }
   
    
    CALayer *lightLayer = [CALayer new];
    UIImage *lightImg = [UIImage imageNamed:@"crown.png"];
    lightLayer.contents=(id)lightImg.CGImage;
    lightLayer.opacity=1.0;
    lightLayer.bounds = CGRectMake(0, 0, 50, 50);
    CAKeyframeAnimation * lightAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    lightAnimation.path=videoPath;
    lightAnimation.duration=timeInterVal;
    lightAnimation.removedOnCompletion = NO;
    lightAnimation.beginTime = AVCoreAnimationBeginTimeAtZero;
    lightAnimation.fillMode = kCAFillModeForwards;
    [lightLayer addAnimation:lightAnimation forKey:@"position"];
    
    // 动画叠加层 overlayLayer
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    [overlayLayer setMasksToBounds:YES];
    [overlayLayer addSublayer:lightLayer];
    
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

@end
