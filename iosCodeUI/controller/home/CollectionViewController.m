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

@property (nonatomic,strong) SimpleCollectionView * collectionView;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    [self initView];
}

-(void)initNavigation{
    self.navigationItem.title=@"Collectionable View";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"选择" style:(UIBarButtonItemStylePlain) target:self action:@selector(showSelected)];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)initView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    // 定义垂直间隔
    flowLayout.minimumLineSpacing = 10;
    // 定义水平间隔
    flowLayout.minimumInteritemSpacing=10;
    // 定义item的大小
    flowLayout.itemSize = CGSizeMake(60, 60);
    // 定义滚动方式
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 定义内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    
    // 初始化CollectionView
    CGFloat viewHeight = 80;
    _collectionView = [[SimpleCollectionView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, viewHeight) collectionViewLayout:flowLayout];
    _collectionView.pagingEnabled = YES;
    // 设置分页滑动的width是SCREEN_WIDTH,不符合要求
    //collectionView.scrollEnabled = NO;
    // 设置分页行不通，改用手势控制滑动，需要把滑动交互关掉
    _collectionView.contentSize = CGSizeMake((290+10)*5+15, 0);
    _collectionView.decelerationRate=UIScrollViewDecelerationRateFast;
    // 允许多选
    _collectionView.allowsMultipleSelection=YES;
    
    [self.view addSubview:_collectionView];
}

-(void)showSelected{
    NSArray<NSIndexPath *> * selectedItems=_collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *selectedItem in selectedItems) {
        NSLog(@"item index:###%ld",selectedItem.item);
    }
}

@end
