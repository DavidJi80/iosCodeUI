//
//  SimpleCollectionView.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleCollectionView.h"
#import "SimpleCollectionViewCell.h"

#define Count 25

static NSString *CellIdentiifer = @"CellIdentiifer";

@interface SimpleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation SimpleCollectionView

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
        self.backgroundColor = [UIColor redColor];
        
        //[self addGesture];
        [self registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
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
    return Count;
}

/**
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    return cell;
}

@end
