//
//  PhotosAssetViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PhotosAssetViewController.h"

@interface PhotosAssetViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PhotosAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _imageView=[UIImageView new];
    _imageView.frame=CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:self.imageView];
    
    
    [self fetchAssetByIdentifier];
}

-(void)fetchAssetByIdentifier{
    /**
     通过localIdentifier获取PHAssetCollection
     identifiers - localIdentifier数组
     options - 过滤选项
     */
    PHFetchResult<PHAssetCollection *> * collectionResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[_localIdentifier] options:nil];
    if (collectionResult.count == 0) {
        return;
    }
    //取出第一个PHAssetCollection对象
    PHAssetCollection * ac=[collectionResult firstObject];
    self.navigationItem.title=ac.localizedTitle;
    //从指定AssetCollection中获取Asset
    PHFetchResult<PHAsset *> * assetResult = [PHAsset fetchAssetsInAssetCollection:ac options:nil];
    //在Asset结果集中快速枚举
    [assetResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"===========%ld=========",idx);
        NSLog(@"mediaType:%ld",obj.mediaType);
        NSLog(@"mediaSubtypes:%ld",obj.mediaSubtypes);
        NSLog(@"sourceType:%ld",obj.sourceType);
        NSLog(@"creationDate:%@",obj.creationDate);
        NSLog(@"location:%@",obj.location);
        
        //获取Asset的底层资源
        NSArray<PHAssetResource *> * ars=[PHAssetResource assetResourcesForAsset:obj];
        for (PHAssetResource * ar in ars) {
            NSLog(@"type - %ld",ar.type);
            NSLog(@"originalFilename - %@", ar.originalFilename);
            NSLog(@"uniformTypeIdentifier - %@", ar.uniformTypeIdentifier);
            NSLog(@"assetLocalIdentifier - %@", ar.assetLocalIdentifier);
        }
        
        if (obj.mediaType==PHAssetMediaTypeImage){
            [[PHCachingImageManager defaultManager] requestImageForAsset:obj targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    self.imageView.image=result;
            }];
            
        }else if (obj.mediaType==PHAssetMediaTypeVideo){
            [[PHImageManager defaultManager]requestAVAssetForVideo:obj options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                NSString* sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
                NSArray* arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
                NSString* filePath = [arr.lastObject substringFromIndex:9];
                NSLog(@"#############%@",filePath);
            }];
        }
    }];
}


@end
