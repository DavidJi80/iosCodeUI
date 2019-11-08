//
//  AddAnimationVC.m
//  iosCodeUI
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AddAnimationVC.h"
#import "VideoFrameCollectionView.h"
#import <AVFoundation/AVFoundation.h>

@interface AddAnimationVC ()
//UI
@property (nonatomic,strong) VideoFrameCollectionView * framesCollectionView;   //帧的CollectionView
//AVFoundation
@property (nonatomic,strong) AVAsset * avAsset;                                 //视频资源

@end

@implementation AddAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAVAsset];
    [self initUI];
    
    [self generateFrames:self.avAsset];
}


#pragma mark - UI
-(void)initUI{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;       // 定义滚动方式
    _framesCollectionView=[[VideoFrameCollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-140, SCREEN_WIDTH, 80) collectionViewLayout:flowLayout];
    _framesCollectionView.backgroundColor=UIColor.yellowColor;
    [self.view addSubview:_framesCollectionView];
}

#pragma mark - init
-(void)initAVAsset{
    Asset * asset=[self.videos objectAtIndex:0];
    NSURL * fileUrl=[NSURL URLWithString:asset.url];
    NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
    self.avAsset=[AVURLAsset URLAssetWithURL:fileUrl options:options];
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
    secend = secend % 60;
    //一秒取一帧
    NSMutableArray * specifiedTimes=[NSMutableArray array];
    for (int i = 1; i <= secend; i++) {
        CMTime timeFrame = CMTimeMake(i, 1);
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [specifiedTimes addObject:timeValue];
    }
    //定义图片生成器
    AVAssetImageGenerator * generator=[AVAssetImageGenerator assetImageGeneratorWithAsset:avAsset];
    //开始异步取帧
    //__weak __typeof(self) weakSelf=self;
    [generator generateCGImagesAsynchronouslyForTimes:specifiedTimes completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        NSLog(@"requestedTime-----: (%lld,%d)", requestedTime.value,requestedTime.timescale);
        NSLog(@"actualTime-----: (%lld,%d)", actualTime.value,actualTime.timescale);
        
        
        switch (result) {
            case AVAssetImageGeneratorCancelled:
                NSLog(@"Cancelled");
                break;
            case AVAssetImageGeneratorFailed:
                NSLog(@"Failed");
                break;
            case AVAssetImageGeneratorSucceeded: {
                UIImage * frameImg = [UIImage imageWithCGImage:image];
                
            }
                break;
        }
        
    }];
}

@end
