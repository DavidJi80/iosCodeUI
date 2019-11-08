//
//  PHAssetCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PHAssetCollectionView.h"
#import "PHAssetCollectionViewCell.h"
#import "VideoAsset.h"
#import "AnimationVideoVC.h"

static NSString *CellIdentiifer = @"PHAssetCollectionViewCellIdentiifer";

@interface PHAssetCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@end

@implementation PHAssetCollectionView

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
        
        [self registerClass:[PHAssetCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
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
    return _videoDataSource.count;
}

/**
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    VideoAsset * videoAsset=self.videoDataSource[indexPath.row];
    cell.durationLabel.text=[NSString stringWithFormat:@"%ld",videoAsset.duration];
    cell.coverImageView.image=videoAsset.coverImage;
    return cell;
}

/**
 指定的单元格被取消选中
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    VideoAsset * videoAsset=[self.videoDataSource objectAtIndex:indexPath.row];
    [[PHCachingImageManager defaultManager]requestAVAssetForVideo:videoAsset.phAsset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
           AnimationVideoVC* vc=[[AnimationVideoVC alloc]init];
           vc.avAsset=asset;
           [self.viewController.navigationController pushViewController:vc animated:YES];
        });
    }];
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


@end
