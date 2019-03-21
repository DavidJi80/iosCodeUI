//
//  PhotosAssetViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PhotosAssetViewController.h"
#import "AssetCollectionView.h"
#import "Asset.h"
#import "PhotosFrameworksUtility.h"
#import "AVPlayerViewController.h"
#import "Video.h"
#import "AVEditorViewController.h"

@interface PhotosAssetViewController ()

@property (nonatomic,strong) AssetCollectionView *collectionView;

@end

@implementation PhotosAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initView];
    [self a:0 end:2300];
}

-(void)initNavigation{
    self.navigationItem.title=@"Collectionable View";
    UIBarButtonItem * playVideosBBI=[[UIBarButtonItem alloc]initWithTitle:@"播放" style:(UIBarButtonItemStylePlain) target:self action:@selector(playVideo)];
    UIBarButtonItem * editVideosBBI=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editVideo)];
    self.navigationItem.rightBarButtonItems=@[playVideosBBI,editVideosBBI];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)initView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    // 定义垂直间隔
    flowLayout.minimumLineSpacing = 1;
    // 定义水平间隔
    flowLayout.minimumInteritemSpacing=1;
    // 定义item的大小
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH/4-1, SCREEN_WIDTH/4);
    
    // 初始化CollectionView
    _collectionView = [[AssetCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.decelerationRate=UIScrollViewDecelerationRateFast;
    //
    _collectionView.assetDataSource=[self fetchAssetByIdentifier];
    _collectionView.allowsMultipleSelection=YES;
    
    [self.view addSubview:_collectionView];
    
}

-(NSMutableArray * )fetchAssetByIdentifier{
    NSMutableArray * dataArray=@[].mutableCopy;
    /**
     通过localIdentifier获取PHAssetCollection
     identifiers - localIdentifier数组
     options - 过滤选项
     */
    PHFetchResult<PHAssetCollection *> * collectionResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[_localIdentifier] options:nil];
    if (collectionResult.count == 0) {
        return nil;
    }
    //取出第一个PHAssetCollection对象
    PHAssetCollection * ac=[collectionResult firstObject];
    self.navigationItem.title=ac.localizedTitle;
    //从指定AssetCollection中获取Asset
    PHFetchResult<PHAsset *> * assetResult = [PHAsset fetchAssetsInAssetCollection:ac options:nil];
    //在Asset结果集中快速枚举
    [assetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Asset * asset=[Asset new];
        
        asset.localIdentifier=obj.localIdentifier;
        
        NSLog(@"===========%ld=========",idx);
        NSLog(@"mediaType:%ld",obj.mediaType);
        NSLog(@"mediaSubtypes:%ld",obj.mediaSubtypes);
        NSLog(@"sourceType:%ld",obj.sourceType);
        NSLog(@"creationDate:%@",obj.creationDate);
        NSLog(@"location:%@",obj.location);
        
        //获取Asset的底层资源
//        NSArray<PHAssetResource *> * ars=[PHAssetResource assetResourcesForAsset:obj];
//        for (PHAssetResource * ar in ars) {
//
//            asset.assetDescription=ar.originalFilename;
//
//            NSLog(@"type - %ld",ar.type);
//            NSLog(@"originalFilename - %@", ar.originalFilename);
//            NSLog(@"uniformTypeIdentifier - %@", ar.uniformTypeIdentifier);
//            NSLog(@"assetLocalIdentifier - %@", ar.assetLocalIdentifier);
//        }
        [dataArray addObject:asset];
        

    }];
    return dataArray.copy;
}

-(void)a:(int)start end:(int)end{
    if ((start<0)||(end<0)) return;
    if (start>end) return;
    NSMutableArray * assets=self.collectionView.assetDataSource.copy;
    int count=(int)assets.count;
    if (start>(count-1)) return;
    if (end>count) end=count-1;
    
    NSMutableArray<NSString *> * identifiers=@[].mutableCopy;;
    for(int i=start;i<=end;i++){
        Asset * asset=assets[i];
        NSString * identifier=asset.localIdentifier;
        [identifiers addObject:identifier];
    }
    
    PHFetchResult<PHAsset *> * assetResult=[PHAsset fetchAssetsWithLocalIdentifiers:identifiers options:nil];
    [assetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 缓存的图片
        // PHCachingImageManager * cache=[PHCachingImageManager new];
        // [cache startCachingImagesForAssets:@[obj] targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil];

        if (obj.mediaType==PHAssetMediaTypeImage){
            /**
             asset PHAsset - 需要获取的PHAsset
             targetSize CGSize - 想要获取的图片的大小。
             contentMode PHImageContentMode - 图片的大小与纵横比的关系。
             options PHImageRequestOptions - 告诉Photos如何处理请求，如何格式化图片，并且通知你的应用处理过程和错误。
             resultHandler block - 加载完成图片后被调用。
                result UIImage - 获取到的图片
                info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
             */
            [[PHCachingImageManager defaultManager] requestImageForAsset:obj targetSize:CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                Asset * asset=assets[start+idx];
                asset.type=0;
                asset.image=result;
            }];
            
            /**
             asset PHAsset - 要获取的资源。
             options PHImageRequestOptions - 告诉Photos如何处理请求，如何格式化图片，并且通知你的应用处理过程和错误。
             resultHandler block - 加载完成图片后被调用。
                imageData NSData - 获取到的图片数据。
                dataUTI NSString - 请求的图片。
                orientation UIImageOrientation - 图片的想要展示的方向。
                info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
             */
            [[PHCachingImageManager defaultManager] requestImageDataForAsset:obj options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                
            }];

        }else if (obj.mediaType==PHAssetMediaTypeVideo){
            /**
             asset PHAsset - 将要被加载的视频资源。
             options PHVideoRequestOptions - 告诉Photos如何处理请求，并且通知你的应用处理过程和错误。
             resultHandler block - 加载资源数据后被调用。
                asset AVAsset - 提供了访问视频资源轨道和数据的对象。关于AVAsset对象的更详细内容请查看AVFoundation Programming Guide。
                audioMix AVAudioMix - 使用这个对象可以重新排列资源的音频轨道，编辑在组合中的附加音频，或者配置用来输出资源音频数据的AVAssetReaderOutput对象。如果这个参数为nil，那么这个资源使用的是默认音频组合。
                info NSDictionary - 关于请求状态的信息。查看Image Result Info Keys获取可能出现的键合值。
             */
            [[PHCachingImageManager defaultManager]requestAVAssetForVideo:obj options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                Asset * videoAsset=assets[start+idx];
                videoAsset.type=1;
                videoAsset.duration=[asset duration];
                NSString* sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
                NSArray* arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
                NSString* filePath = [NSString stringWithFormat:@"file://%@",arr.lastObject];//[arr.lastObject substringFromIndex:9];
                videoAsset.url=filePath;
            }];
            
            [[PHCachingImageManager defaultManager] requestImageForAsset:obj targetSize:CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                Asset * asset=assets[start+idx];
                asset.image=result;
            }];
        }
        [self.collectionView reloadData];
    }];
}

-(void)playVideo{
    NSArray<NSIndexPath *> * selectedItems=_collectionView.indexPathsForSelectedItems;
    if((selectedItems.count>9)||(selectedItems.count<1)){
        NSString *title = NSLocalizedString(@"警告", nil);
        NSString *message = NSLocalizedString(@"请选择1-9个视频!", nil);
        NSString *okTitle = NSLocalizedString(@"OK", nil);
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSMutableArray<Video *> * videos=@[].mutableCopy;
    for (NSIndexPath *selectedItem in selectedItems) {
        Asset * asset=[_collectionView.assetDataSource objectAtIndex:selectedItem.item];
        Video * video=[Video new];
        video.url=asset.url;
        video.image=asset.image;
        video.duration=asset.duration;
        [videos addObject:video];
    }
    AVPlayerViewController *vc=[AVPlayerViewController new];
    vc.videos=videos;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)editVideo{
    NSArray<NSIndexPath *> * selectedItems=_collectionView.indexPathsForSelectedItems;
    if((selectedItems.count>9)||(selectedItems.count<1)){
        NSString *title = NSLocalizedString(@"警告", nil);
        NSString *message = NSLocalizedString(@"请选择1-9个视频!", nil);
        NSString *okTitle = NSLocalizedString(@"OK", nil);
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSMutableArray<Video *> * videos=@[].mutableCopy;
    for (NSIndexPath *selectedItem in selectedItems) {
        Asset * asset=[_collectionView.assetDataSource objectAtIndex:selectedItem.item];
        Video * video=[Video new];
        video.url=asset.url;
        video.image=asset.image;
        video.duration=asset.duration;
        [videos addObject:video];
    }
    AVEditorViewController *vc=[AVEditorViewController new];
    vc.videos=videos;
    [self.navigationController pushViewController:vc animated:NO];
}


@end
