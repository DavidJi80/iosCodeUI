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
#import "HeaderCollectionReusableView.h"

#define Count 100

static NSString * CellIdentiifer = @"CellIdentiifer";
static NSString * headerIdentiifer = @"HeaderIdentiifer";
static NSString * footerIdentiifer = @"Footerdentiifer";

@interface SimpleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic,strong) NSArray<NSArray *> * personDataSource;

@end

@implementation SimpleCollectionView

/**
 重写initWithFrame方法
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    _personDataSource=[Person initPersonDataSource];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        //注册 Cell
        [self registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
        
        // 注册头部尾部
        [self registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentiifer];
        [self registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentiifer];
    }
    return self;
}



/**
 UICollectionViewDataSource
 指定Section的个数
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _personDataSource.count;
}

/**
 UICollectionViewDataSource
 指定每格Section的Cell的个数
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _personDataSource[(int)section].count;
}

/**
 UICollectionViewDataSource
 配置Cell的显示
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    
    Person * person=self.personDataSource[indexPath.section][indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%zd--%zd",indexPath.section,person.age];
    return cell;
}

/**
 UICollectionViewDataSource
 配置补充视图的显示
 */
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) { // 返回每一组的头部视图
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentiifer forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor greenColor];
        headerView.titleLabel.text=[NSString stringWithFormat:@"Section%ld",indexPath.section];
        return headerView;
    } else { // 返回每一组的尾部视图
        HeaderCollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentiifer forIndexPath:indexPath];
        footerView.titleLabel.text=[NSString stringWithFormat:@"Count:%ld",_personDataSource[indexPath.section].count];
        footerView.backgroundColor = [UIColor purpleColor];
        return footerView;
    }
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
