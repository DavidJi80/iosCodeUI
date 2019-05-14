//
//  CollectionViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CollectionViewController.h"
#import "SimpleCollectionView.h"
#import "Person.h"

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
    self.navigationItem.title=@"";
    //选择，多选
    UIBarButtonItem * selectItemBBI=[[UIBarButtonItem alloc]initWithTitle:@"选择" style:(UIBarButtonItemStylePlain) target:self action:@selector(selectItem)];
    UIBarButtonItem * deSelectItemBBI=[[UIBarButtonItem alloc]initWithTitle:@"取消选择" style:(UIBarButtonItemStylePlain) target:self action:@selector(deSelectItem)];
    UIBarButtonItem * multiSelectBBI=[[UIBarButtonItem alloc]initWithTitle:@"多选" style:(UIBarButtonItemStylePlain) target:self action:@selector(showSelected)];
    //添加、移动、删除Items
    UIBarButtonItem * insertItemBBI=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(insertItem)];
    UIBarButtonItem * moveItemBBI=[[UIBarButtonItem alloc]initWithTitle:@"移动" style:(UIBarButtonItemStylePlain) target:self action:@selector(moveItem)];
    UIBarButtonItem * deleteItemBBI=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:(UIBarButtonItemStylePlain) target:self action:@selector(deleteItem)];
    //添加、移动、删除Section
    UIBarButtonItem * insertSectionBBI=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:(UIBarButtonItemStylePlain) target:self action:@selector(insertSection)];
    UIBarButtonItem * moveSectionBBI=[[UIBarButtonItem alloc]initWithTitle:@"移动" style:(UIBarButtonItemStylePlain) target:self action:@selector(moveSection)];
    UIBarButtonItem * deleteSectionBBI=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:(UIBarButtonItemStylePlain) target:self action:@selector(deleteSection)];
    //布局
    UIBarButtonItem * changeLayoutBBI=[[UIBarButtonItem alloc]initWithTitle:@"布局" style:(UIBarButtonItemStylePlain) target:self action:@selector(changeLayout)];
    self.navigationItem.rightBarButtonItems=@[changeLayoutBBI];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)initView{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;       // 定义滚动方式
    //间隔 Item Spacing
    flowLayout.minimumLineSpacing = 1;                                          // 定义垂直间隔
    flowLayout.minimumInteritemSpacing=1;                                       // 定义水平间隔
    flowLayout.itemSize = CGSizeMake(60, 60);                                   // 定义item默认的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);                 // 定义Section内边距
    //补充视图 Supplementary Views
    flowLayout.headerReferenceSize = CGSizeMake(50, 50);                        // 设置头视图尺寸大小
    flowLayout.footerReferenceSize = CGSizeMake(50, 50);                        // 设置尾视图尺寸大小
    //头尾视图悬浮
    flowLayout.sectionHeadersPinToVisibleBounds = YES;                          // 设置头视图悬浮
    flowLayout.sectionFootersPinToVisibleBounds = YES;                          // 设置尾视图悬浮
    
    
    // 初始化CollectionView
    _collectionView = [[SimpleCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    
    [self.view addSubview:_collectionView];
}



#pragma mark - UICollectionView
#pragma mark -- Inserting, Moving, and Deleting Items
/**
 添加一个Item
 */
-(void)insertItem{
    Person * person=[Person new];
    person.name=@"jz";
    person.age=18;
    [[self.collectionView.personDataSource objectAtIndex:0] insertObject:person atIndex:0];
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

/**
 移动Item
 */
-(void)moveItem{
    [self.collectionView moveItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] toIndexPath:[NSIndexPath indexPathForItem:9 inSection:0]];
}

/**
 删除一个Item
 */
-(void)deleteItem{
    [[self.collectionView.personDataSource objectAtIndex:0] removeObjectAtIndex:0];
    [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

#pragma mark -- Inserting, Moving, and Deleting Sections
/**
 添加一个Sections
 */
-(void)insertSection{
    NSMutableArray<Person *> * persons=[NSMutableArray array];
    Person * person=[Person new];
    person.name=@"jz";
    person.age=18;
    [persons addObject:person];
    [self.collectionView.personDataSource insertObject:persons atIndex:0];
    
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndex:0];
    [self.collectionView insertSections:indexSet];
}

/**
 移动Sections
 */
-(void)moveSection{
    NSMutableArray * persons=[self.collectionView.personDataSource objectAtIndex:0];
    [self.collectionView.personDataSource removeObjectAtIndex:0];
    [self.collectionView.personDataSource addObject:persons];
    [self.collectionView moveSection:0 toSection:2];
}

/**
 删除一个Sections
 */
-(void)deleteSection{
    [self.collectionView.personDataSource removeObjectAtIndex:0];
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    [indexSet addIndex:0];
    [self.collectionView deleteSections:indexSet];
}

#pragma mark -- Managing the Selection
/**
 选择一个Item
 */
-(void)selectItem{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:13 inSection:2] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredVertically];
}

/**
 取消选择一个Item
 */
-(void)deSelectItem{
    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForItem:13 inSection:2] animated:YES];
}

/**
 获取选中的Item的indexPath
 */
-(void)showSelected{
    NSArray<NSIndexPath *> * selectedItems=_collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *selectedItem in selectedItems) {
        NSLog(@"item index:###%@",selectedItem);
    }
}

#pragma mark -- Changing the Layout
-(void)changeLayout{
    UICollectionViewFlowLayout * flowLayout=[UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;       // 定义滚动方式
    //间隔 Item Spacing
    flowLayout.minimumLineSpacing = 1;                                          // 定义垂直间隔
    flowLayout.minimumInteritemSpacing=1;                                       // 定义水平间隔
    flowLayout.itemSize = CGSizeMake(60, 60);                                   // 定义item默认的大小
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);                 // 定义Section内边距
    //补充视图 Supplementary Views
    flowLayout.headerReferenceSize = CGSizeMake(50, 50);                        // 设置头视图尺寸大小
    flowLayout.footerReferenceSize = CGSizeMake(50, 50);                        // 设置尾视图尺寸大小
    //头尾视图悬浮
    flowLayout.sectionHeadersPinToVisibleBounds = NO;                          // 设置头视图悬浮
    flowLayout.sectionFootersPinToVisibleBounds = NO;                          // 设置尾视图悬浮
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES completion:^(BOOL finished) {
        NSLog(@"Change the Layout");
    }];
}




@end
