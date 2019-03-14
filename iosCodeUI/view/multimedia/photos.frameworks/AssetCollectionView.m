//
//  AssetCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AssetCollectionView.h"
#import "AssetCollectionViewCell.h"
#import "Asset.h"
#import "PhotosFrameworksUtility.h"

static NSString *CellIdentiifer = @"CellIdentiifer";

@interface AssetCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@end

@implementation AssetCollectionView

/**
 重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self registerClass:[AssetCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
    }
    return self;
}

/**
 指定Section的个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

/**
 指定每格Section的Cell的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assetDataSource.count;
}

/**
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    Asset * asset=self.assetDataSource[indexPath.row];
    cell.descriptionLabel.text=asset.assetDescription;
    cell.imageView.image=asset.image;
    if (asset.type==1){
        cell.durationLabel.text=[PhotosFrameworksUtility formatCMTime:asset.duration];
    }else{
        cell.durationLabel.text=@"";
    }
    return cell;
}

/**
 UICollectionView被选中时调用的方法
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.row);
    Asset * asset=self.assetDataSource[indexPath.row];
    NSString * localIdentifier=asset.localIdentifier;
    PHFetchResult<PHAsset *> * assetResult=[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil];
    PHAsset * phAsset=[assetResult firstObject];
    if (asset.type==1){
        /**
         asset PHAsset - 要播放的视频资源。
         options PHVideoRequestOptions - 告诉Photos如何处理请求，并且通知你的应用处理过程和错误。
         resultHandler block - 加载资源数据后被调用。
            playerItem AVPlayerItem - 获取到的视频数据。
            info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
         */
        [[PHCachingImageManager defaultManager] requestPlayerItemForVideo:phAsset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        }];
        
        /**
         asset PHAsset - 将要被创建导出会话的视频资源。
         options PHVideoRequestOptions - 告诉Photos如何处理请求，并且通知你的应用处理过程和错误。
         exportPreset NSString - 要导出的资源的导出预设名。请查看AVAssetExportSession。
         resultHandler block - 加载资源数据并且准备导出会话后被调用。
            exportSession AVAssetExportSession - 使用这个将视频资源数据写入文件
            info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
         */
        [[PHCachingImageManager defaultManager] requestExportSessionForVideo:phAsset options:nil exportPreset:@"xxx.mov" resultHandler:^(AVAssetExportSession * _Nullable exportSession, NSDictionary * _Nullable info) {
            
        }];
    }else if(asset.type==0){
        /**
         asset PHAsset - 需要获取的PHAsset
         targetSize CGSize - 想要获取的图片的大小。
         contentMode PHImageContentMode - 图片的大小与纵横比的关系。
         options PHImageRequestOptions - 告诉Photos如何处理请求，如何格式化图片，并且通知你的应用处理过程和错误。
         resultHandler block - 加载完成图片后被调用。
            livePhoto PHLivePhoto - 获取到的Live Photo对象
            info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
         */
        [[PHCachingImageManager defaultManager] requestLivePhotoForAsset:phAsset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {
            
        }];
    }
}

@end

