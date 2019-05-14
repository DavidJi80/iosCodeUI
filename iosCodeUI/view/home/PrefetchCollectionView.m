//
//  PrefetchCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PrefetchCollectionView.h"
#import "SimpleCollectionViewCell.h"

static NSString * CellIdentiifer = @"CellIdentiifer";

@interface PrefetchCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching>

@end

@implementation PrefetchCollectionView

#pragma mark - init
/**
 重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    _personDataSource=[Person initPersonDataSource];
    if (self) {
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor greenColor];
        self.decelerationRate=UIScrollViewDecelerationRateFast;
        
        //UICollectionView
        self.delegate = self;           //UICollectionViewDataSource
        self.dataSource = self;         //UICollectionViewDelegate
        //注册 Cell
        [self registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
        //UICollectionViewDataSourcePrefetching
        self.prefetchingEnabled=YES;    //预取开关
        self.prefetchDataSource=self;   //预取数据源
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
/**
 指定Section的个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _personDataSource.count;
}


/**
 指定每格Section的Cell的个数（必须实现）
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _personDataSource[(int)section].count;
}

/**
 配置Cell的显示（必须实现）
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForItemAtIndexPath:%@",indexPath);
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    
    Person * person=self.personDataSource[indexPath.section][indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%zd--%zd",indexPath.section,person.age];
    return cell;
}

#pragma mark - UICollectionViewDataSourcePrefetching
/**
 预取将要显示的Cell
 */
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSLog(@"prefetchItemsAtIndexPaths:%@",indexPaths);
}

/**
 取消预取
 */
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSLog(@"cancelPrefetchingForItemsAtIndexPaths:%@",indexPaths);
}

@end
