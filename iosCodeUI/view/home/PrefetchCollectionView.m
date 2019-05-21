//
//  PrefetchCollectionView.m
//  iosCodeUI
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PrefetchCollectionView.h"
#import "SimpleCollectionViewCell.h"

static NSString * CellIdentiifer = @"CellIdentiifer";

@interface PrefetchCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching,UICollectionViewDragDelegate,UICollectionViewDropDelegate>


@property (nonatomic,strong) NSIndexPath * dragIndexPath;

@end

@implementation PrefetchCollectionView



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
        self.backgroundColor = [UIColor greenColor];
        self.decelerationRate=UIScrollViewDecelerationRateFast;
        
        //UICollectionView
        self.delegate = self;           //UICollectionViewDataSource
        self.dataSource = self;         //UICollectionViewDelegate
        //注册 Cell
        [self registerClass:[SimpleCollectionViewCell class] forCellWithReuseIdentifier:CellIdentiifer];
        //UICollectionViewDataSourcePrefetching
        self.prefetchingEnabled=YES;    //预取开关
        self.prefetchDataSource=self;   //预取数据源
        //UICollectionViewDragDelegate
        self.dragDelegate = self;
        self.dragInteractionEnabled = YES;  //属性在 iPad 上默认是YES，在 iPhone 默认是 NO，只有设置为 YES 才可以进行 drag 操作
        //UICollectionViewDragDelegate
        self.dropDelegate=self;
        self.reorderingCadence = UICollectionViewReorderingCadenceImmediate;
        
        self.springLoaded = YES;
    }
    return self;
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
    //NSLog(@"cellForItemAtIndexPath:%@",indexPath);
    SimpleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentiifer forIndexPath:indexPath];
    
    Person * person=self.personDataSource[indexPath.section][indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%zd--%zd",indexPath.section,person.age];
    return cell;
}

#pragma mark - UICollectionViewDataSourcePrefetching
/**
 预取将要显示的Cell
 */
- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    //NSLog(@"prefetchItemsAtIndexPaths:%@",indexPaths);
}

/**
 取消预取
 */
- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    //NSLog(@"cancelPrefetchingForItemsAtIndexPaths:%@",indexPaths);
}

#pragma mark - UICollectionViewDragDelegate
/**
 开始拖拽session
 */
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForBeginningDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath{
    self.dragIndexPath=indexPath;
    NSString * imageName=[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:imageName];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    return @[item];
}

/**
 将指定的项添加到现有的Drag Session
 */
- (NSArray<UIDragItem *> *)collectionView:(UICollectionView *)collectionView itemsForAddingToDragSession:(id<UIDragSession>)session atIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point{
    NSString * imageName=[NSString stringWithFormat:@"%ld%ld",indexPath.section,indexPath.row];
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:imageName];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:itemProvider];
    return @[item];
}

/**
 拖拽将开始
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionWillBegin:(id<UIDragSession>)session{
    NSLog(@"dragSessionWillBegin --> drag 会话将要开始");
}

/**
 拖拽结束
 */
- (void)collectionView:(UICollectionView *)collectionView dragSessionDidEnd:(id<UIDragSession>)session{
    NSLog(@"dragSessionDidEnd --> drag 会话已经结束");
}

/**
 设置拖动预览信息
 */
- (UIDragPreviewParameters *)collectionView:(UICollectionView *)collectionView dragPreviewParametersForItemAtIndexPath:(NSIndexPath *)indexPath{
    // 可以在该方法内使用 贝塞尔曲线 对单元格的一个具体区域进行裁剪
    UIDragPreviewParameters *parameters = [[UIDragPreviewParameters alloc] init];
    
    CGFloat previewLength = 90;
    CGRect rect = CGRectMake(0, 0, previewLength, previewLength);
    parameters.visiblePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25];
    parameters.backgroundColor = [UIColor clearColor];
    return parameters;
}

- (BOOL)collectionView:(UICollectionView *)collectionView dragSessionIsRestrictedToDraggingApplication:(id<UIDragSession>)session{
    return YES;
}

#pragma mark - UICollectionViewDropDelegate
/**
 通过该方法判断对应的item 能否被 执行drop会话
 如果返回 NO，将不会调用接下来的代理方法
 如果没有实现该方法，那么默认返回 YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView canHandleDropSession:(id<UIDropSession>)session {
    // 假设在该 drop 只能在当前本 app中可执行，在别的 app 中不可以
    if (session.localDragSession == nil) {
        return NO;
    }
    return YES;
}

/**
 当用户开始进行 drop 操作的时候会调用这个方法
 */
- (void)collectionView:(UICollectionView *)collectionView performDropWithCoordinator:(id<UICollectionViewDropCoordinator>)coordinator {
    
    NSIndexPath *destinationIndexPath = coordinator.destinationIndexPath;
    UIDragItem *dragItem = coordinator.items.firstObject.dragItem;
    
    
    for(id<UICollectionViewDropItem> item in coordinator.items){
        NSItemProvider *itemProvider =item.dragItem.itemProvider;
        
        [itemProvider loadObjectOfClass:[NSString class] completionHandler:^(id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            // 回调在非主线程
            NSString *image = (NSString *)object;
            NSLog(@"%@",image);
        }];
        
        
    }
    
    // 更新 CollectionView
    [collectionView performBatchUpdates:^{
        // 目标 cell 换位置
        Person * person=[[self.personDataSource objectAtIndex:self.dragIndexPath.section] objectAtIndex:self.dragIndexPath.row];
        [[self.personDataSource objectAtIndex:self.dragIndexPath.section] removeObjectAtIndex:self.dragIndexPath.row];
        [[self.personDataSource objectAtIndex:destinationIndexPath.section] insertObject:person atIndex:destinationIndexPath.row];
        
        [collectionView moveItemAtIndexPath:self.dragIndexPath toIndexPath:destinationIndexPath];
    } completion:^(BOOL finished) {
        
    }];
    
    [coordinator dropItem:dragItem toItemAtIndexPath:destinationIndexPath];
}

/**
 当用户拖拽时，UICollectionView会反复调用此方法
 以确定如果Drop发生这个位置时您将如何处理。
 UICollectionView根据您的建议向用户提供视觉反馈。
 */
- (UICollectionViewDropProposal *)collectionView:(UICollectionView *)collectionView dropSessionDidUpdate:(id<UIDropSession>)session withDestinationIndexPath:(NSIndexPath *)destinationIndexPath{
    UICollectionViewDropProposal *dropProposal;
    // 如果是另外一个app，localDragSession为nil，此时就要执行copy，通过这个属性判断是否是在当前app中释放，当然只有 iPad 才需要这个适配
    if (session.localDragSession) {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    } else {
        dropProposal = [[UICollectionViewDropProposal alloc] initWithDropOperation:UIDropOperationCopy intent:UICollectionViewDropIntentInsertAtDestinationIndexPath];
    }
    return dropProposal;
}

/**
 当drop会话进入到 collectionView 的坐标区域内就会调用，
 在[collectionView dragSessionWillBegin]之后调用
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnter:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidEnter --> dropSession进入目标区域");
}

/**
 当 dropSession 不在collectionView 目标区域的时候会被调用
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidExit:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidExit --> dropSession 离开目标区域");
}

/**
 当dropSession 完成时会被调用，不管结果如何
 适合在这个方法里做一些清理的操作
 */
- (void)collectionView:(UICollectionView *)collectionView dropSessionDidEnd:(id<UIDropSession>)session {
    NSLog(@"dropSessionDidEnd --> dropSession 已完成");
}

#pragma mark - 懒加载


@end
