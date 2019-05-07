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
    flowLayout.minimumLineSpacing = 1;
    // 定义水平间隔
    flowLayout.minimumInteritemSpacing=1;
    // 定义item的大小
    flowLayout.itemSize = CGSizeMake(60, 60);
    // 定义滚动方式
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置头视图尺寸大小
    flowLayout.headerReferenceSize = CGSizeMake(50, 50);
    // 设置尾视图尺寸大小
    flowLayout.footerReferenceSize = CGSizeMake(50, 50);
    // 定义内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);
    //flowLayout.sectionFootersPinToVisibleBounds = YES;
    //flowLayout.sectionHeadersPinToVisibleBounds = YES;
    
    // 初始化CollectionView
    _collectionView = [[SimpleCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
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
    NSArray * a=[self.collectionView.dataSource indexTitlesForCollectionView:self.collectionView];
    NSLog(@"%ld",a.count);
}

@end
