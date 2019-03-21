//
//  FrameCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "FrameCollectionView.h"
#import "FrameCollectionViewCell.h"
#import "Frame.h"

static NSString *CellIdentiifer = @"FrameCellIdentiifer";

@implementation FrameCollectionView

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
        
        [self registerClass:[FrameCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
    }
    return self;
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
    FrameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    Frame * frame=_frameDataSource[indexPath.row];
    cell.imageView.image=frame.image;
    return cell;
}


@end
