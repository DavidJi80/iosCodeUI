//
//  SimpleCollectionView.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleCollectionView.h"
#import "SimpleCollectionViewCell.h"
#import "Person.h"

#define Count 100

static NSString *CellIdentiifer = @"CellIdentiifer";

@interface SimpleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic,strong) NSArray * personDataSource;

@end

@implementation SimpleCollectionView

/**
 重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    _personDataSource=[Person initPersonDataSource];
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor redColor];
        
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
    return _personDataSource.count;
}

/**
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    Person * person=self.personDataSource[indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%zd",person.age];
    return cell;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tracking){
        NSLog(@"--------- is tracking!");
    }else if (scrollView.decelerating){
        NSLog(@"--------- is decelerating!");
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell %@",indexPath);
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor whiteColor];
    cell.backgroundColor=[UIColor greenColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消cell %@",indexPath);
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor redColor];
    cell.backgroundColor=[UIColor grayColor];
}

@end
