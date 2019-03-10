//
//  CollectionViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CollectionViewController.h"
#import "SimpleCollectionView.h"


@interface CollectionViewController ()

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    // 定义垂直间隔
    flowLayout.minimumLineSpacing = 10;
    // 定义水平间隔
    flowLayout.minimumInteritemSpacing=10;
    // 定义item的大小
    flowLayout.itemSize = CGSizeMake(30, 30);
    // 定义滚动方式
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 定义内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    // 初始化CollectionView
    CGFloat viewHeight = 50;
    SimpleCollectionView *collectionView = [[SimpleCollectionView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, viewHeight) collectionViewLayout:flowLayout];
    collectionView.pagingEnabled = YES;
    // 设置分页滑动的width是SCREEN_WIDTH,不符合要求
    //collectionView.scrollEnabled = NO;
    // 设置分页行不通，改用手势控制滑动，需要把滑动交互关掉
    collectionView.contentSize = CGSizeMake((290+10)*5+15, 0);
    collectionView.decelerationRate=UIScrollViewDecelerationRateFast;
    
    [self.view addSubview:collectionView];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
