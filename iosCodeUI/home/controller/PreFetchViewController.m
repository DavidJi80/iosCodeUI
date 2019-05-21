//
//  PreFetchViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PreFetchViewController.h"
#import "PrefetchCollectionView.h"

@interface PreFetchViewController ()

@property (nonatomic,strong) PrefetchCollectionView * collectionView;

@end

@implementation PreFetchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;       // 定义滚动方式
    //间隔 Item Spacing
    flowLayout.minimumLineSpacing = 1;                                          // 定义垂直间隔
    flowLayout.minimumInteritemSpacing=1;                                       // 定义水平间隔
    flowLayout.itemSize = CGSizeMake(100, 100);                                   // 定义item默认的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);                 // 定义Section内边距

    // 初始化CollectionView
    _collectionView = [[PrefetchCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    
    [self.view addSubview:_collectionView];
}

@end
