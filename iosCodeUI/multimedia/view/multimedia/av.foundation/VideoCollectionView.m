//
//  VideoCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoCollectionView.h"
#import "VideoCollectionViewCell.h"
#import "PhotosFrameworksUtility.h"
#import "Utility.h"

static NSString *CellIdentiifer = @"VideoCellIdentiifer";

@interface VideoCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@end

@implementation VideoCollectionView

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
        
        [self registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
    }
    return self;
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
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    Video * video=_videoDataSource[indexPath.row];
    cell.imageView.image=video.image;
    cell.durationLabel.text=[PhotosFrameworksUtility formatCMTime:video.duration];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_avPlayerDelegate replacePlayerItem:indexPath.row];
}

@end
