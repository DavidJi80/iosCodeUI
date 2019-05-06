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

static NSString * CellIdentiifer = @"CellIdentiifer";
static NSString * headerIdentiifer = @"HeaderIdentiifer";
static NSString * footerIdentiifer = @"Footerdentiifer";

@interface SimpleCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray<NSMutableArray *> * personDataSource;

@end

@implementation SimpleCollectionView

#pragma mark - init
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
        
        //注册头部尾部
        [self registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentiifer];
        [self registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentiifer];
        
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(reorderCollectionView:)];
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

#pragma mark - UILongPressGestureRecognizer（长按手势）
/**
 长按手势响应方法
 */
- (void)reorderCollectionView:(UILongPressGestureRecognizer *)longPressGesture {
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint touchPoint = [longPressGesture locationInView:self];
    NSIndexPath *selectedIndexPath = [self indexPathForItemAtPoint:touchPoint];
    //根据长按手势的状态进行处理
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:{// 手势开始
            //当没有点击到cell的时候不进行处理
            if (selectedIndexPath) {
                //开始移动
                [self beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{// 手势变化
            //移动过程根据新的位置坐标更新UI
            [self updateInteractiveMovementTargetPosition:touchPoint];
            break;
        }
        case UIGestureRecognizerStateEnded:{// 手势结束
            //结束移动
            [self endInteractiveMovement];
            break;
        }
        default:{
            //取消移动，回到原始位置
            [self cancelInteractiveMovement];
            break;
        }
    }
}


#pragma mark - UICollectionView

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
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    
    Person * person=self.personDataSource[indexPath.section][indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%zd--%zd",indexPath.section,person.age];
    return cell;
}

/**
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

#pragma mark -- reorder 重排序
/**
 是否支持重排序(拖拽)，在开始移动时会调用此代理方法
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

/**
 reorder必须实现方法，在移动结束的时候调用此代理方法
 
 @sourceIndexPath 原始数据 indexpath
 @destinationIndexPath 移动到目标数据的 indexPath
 */
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    Person * person=[[self.personDataSource objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    [[self.personDataSource objectAtIndex:sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    [[self.personDataSource objectAtIndex:destinationIndexPath.section] insertObject:person atIndex:destinationIndexPath.row];
}

#pragma mark - UICollectionViewDelegate
#pragma mark -- 单元格的选中

/**
 指定的单元格是否可以被选中
 */
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"是否可以选中：%@",indexPath);
    return YES;
}

/**
 指定的单元格被选中
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中cell %@",indexPath);
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor whiteColor];
    cell.backgroundColor=[UIColor redColor];
}

/**
 指定的单元格是否可以被取消选中
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"是否可以取消：%@",indexPath);
    return YES;
}

/**
 指定的单元格被取消选中
 */
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"取消cell %@",indexPath);
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor redColor];
    cell.backgroundColor=[UIColor grayColor];
}

#pragma mark -- 单元格的高亮
/**
 当触摸事件到达时，返回指定的单元格是否可以高亮
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"是否高亮：%@",indexPath);
    return YES;
}

/**
 高亮
 */
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor whiteColor];
    cell.backgroundColor=[UIColor greenColor];
}

/**
 当触摸事件消失时取消高亮
 */
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    SimpleCollectionViewCell * cell = (SimpleCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.titleLabel.textColor =[UIColor redColor];
    cell.backgroundColor=[UIColor grayColor];
}


#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tracking){
        NSLog(@"--------- is tracking!");
    }else if (scrollView.decelerating){
        NSLog(@"--------- is decelerating!");
    }
}





@end
