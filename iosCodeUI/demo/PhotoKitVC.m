//
//  PhotoKitVC.m
//  iosCodeUI
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PhotoKitVC.h"
#import "PHAssetCollectionView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "VideoAsset.h"
#import "CoreAnimationVC.h"

@interface PhotoKitVC ()
//UI
@property (nonatomic,strong) PHAssetCollectionView * phAssetCollectionView;   //视频的CollectionView

@end

@implementation PhotoKitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

-(void)initUI{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;       // 定义滚动方式
    flowLayout.minimumLineSpacing = 1;                                          // 定义垂直间隔
    flowLayout.minimumInteritemSpacing=1;                                       // 定义水平间隔
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4-1, SCREEN_WIDTH/4);         // 定义item的大小
    _phAssetCollectionView=[[PHAssetCollectionView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-120) collectionViewLayout:flowLayout];
    //_phAssetCollectionView.backgroundColor=UIColor.redColor;
    _phAssetCollectionView.videoDataSource=[self getVideos];
    [self.view addSubview:_phAssetCollectionView];
}

-(NSMutableArray *)getVideos{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option];
    NSMutableArray * videoAssets=@[].mutableCopy;
    for (PHAsset *phAsset in result) {
        if(phAsset.mediaType==PHAssetMediaTypeVideo){
            VideoAsset * videoAsset=[VideoAsset new];
            videoAsset.duration=phAsset.duration;
            videoAsset.phAsset=phAsset;
            [[PHCachingImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                videoAsset.coverImage=result;
                
            }];
            
            [videoAssets addObject:videoAsset];
        }
    }
    return videoAssets;
}

@end
