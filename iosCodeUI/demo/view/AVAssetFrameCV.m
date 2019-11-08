//
//  AVAssetFrameCV.m
//  iosCodeUI
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVAssetFrameCV.h"
#import "AVAssetFrameCVCell.h"



static NSString *CellIdentiifer = @"AVAssetFrameCVCellIdentiifer";

@interface AVAssetFrameCV ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@end

@implementation AVAssetFrameCV

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
        
        [self registerClass:[AVAssetFrameCVCell class] forCellWithReuseIdentifier:CellIdentiifer];
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
    return _frameDataSource.count;
}

/**
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AVAssetFrameCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    FrameAsset * frameAsset=self.frameDataSource[indexPath.row];
    cell.frameImageView.image=frameAsset.frameImage;
    cell.pointLabel.text=[NSString stringWithFormat:@"%ld:[%d,%d]",(long)indexPath.row,(int)frameAsset.point.x,(int)frameAsset.point.y ];
    return cell;
}

/**
 指定的单元格被取消选中
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index=indexPath.row;
    FrameAsset * frameAsset=[self.frameDataSource objectAtIndex:index];
    [_frameCVDelegate showImage:frameAsset.frameImage index:index];
}


@end
