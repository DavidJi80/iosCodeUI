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
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        self.decelerationRate=UIScrollViewDecelerationRateFast;
        
        
        //UICollectionView
        self.delegate = self;           //UICollectionViewDataSource
        self.dataSource = self;         //UICollectionViewDelegate
        //选择
        self.allowsSelection=YES;                   //允许选中
        self.allowsMultipleSelection=YES;           //允许多选
        //背景视图
        UIView * backgroundView=[UIView new];
        backgroundView.frame=CGRectMake(0, 0, 200, 400);
        backgroundView.backgroundColor=[UIColor redColor];
        self.backgroundView=backgroundView;
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
                NSLog(@"开始移动%@",selectedIndexPath);
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{// 手势变化
            //移动过程根据新的位置坐标更新UI
            [self updateInteractiveMovementTargetPosition:touchPoint];
            NSLog(@"移动过程根据新的位置坐标更新UI[%lf,%lf]",touchPoint.x,touchPoint.y);
            break;
        }
        case UIGestureRecognizerStateEnded:{// 手势结束
            //结束移动
            [self endInteractiveMovement];
            NSLog(@"结束移动%@",selectedIndexPath);
            break;
        }
        default:{
            //取消移动，回到原始位置
            [self cancelInteractiveMovement];
            NSLog(@"取消移动，回到原始位置%@",selectedIndexPath);
            break;
        }
    }
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

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSIndexPath * indexPath=[NSIndexPath new];
    return indexPath;
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

#pragma mark -- 跟踪视图的添加和删除
/**
 在Cell被添加之前调用
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell%@将被添加",indexPath);
}

/**
 在Cell被删除之后调用
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell%@被删除",indexPath);
}

/**
 在Section被添加之前调用
 */
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Section%@将被添加",indexPath);
}

/**
 在Section被删除之后调用
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
   NSLog(@"Section%@被删除",indexPath);
}

#pragma mark -- 管理焦点
- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
/**
 设置Item尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}

/**
 设置特定section的margin
 */
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

/**
 设置特定section的最小行距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

/**
 设置特定section的item最小水平间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

/**
 设置特定section的页眉尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(50, 50);
}

/**
 设置特定section的页脚尺寸
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(30, 30);
}



#pragma mark - scrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tracking){
//        NSLog(@"--------- is tracking!");
    }else if (scrollView.decelerating){
//        NSLog(@"--------- is decelerating!");
    }
}






@end
