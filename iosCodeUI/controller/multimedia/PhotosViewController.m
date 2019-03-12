//
//  PhotosViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PhotosViewController.h"
#import <Photos/Photos.h>
#import "CollectionTableViewCell.h"
#import "AssetCollection.h"

@interface PhotosViewController ()

@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAssetCollection];
}

-(void)getAssetCollection{
    NSMutableArray * dataArray=@[].mutableCopy;
    
    /**
     查找给定类型和给定子类型的资源集合
     PHAssetCollectionTypeAlbum - 在[照片]APP中创建的相簿或者通过iTunes同步的在iOS设备上显示的相簿
     PHAssetCollectionSubtypeAlbumRegular - 在[相册]APP中创建的相簿
     */
    PHFetchResult<PHAssetCollection *> * collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    if (collectionResult.count == 0) {
        return;
    }
    /**
     快速枚举获取结果中的所有对象
     ^() block - 快速枚举的操作
     obj ObjectType - 被枚举的对象
     idx NSUInteger - 被枚举的对象的索引
     stop BOOL - 在block中设置为YES将会取消当前对获取结果的处理。
     */
    [collectionResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AssetCollection * ac=[AssetCollection new];
        ac.title=obj.localizedTitle;
        ac.collectionDescription=@"";
        
        /**
         从指定的资源集合中检索资源
         obj - PHAssetCollection 资源集合
         options - PHFetchOptions 检索选项
         */
        NSLog(@"===============");
        NSLog(@"Local Identifier：%@",obj.localIdentifier);
        NSLog(@"Localized Title：%@",obj.localizedTitle);
        NSLog(@"Asset Collection Type：%ld", obj.assetCollectionType);
        NSLog(@"Asset Collection Sub Type：%ld", obj.assetCollectionSubtype);
        NSLog(@"Astimated Asset Count：%ld", obj.estimatedAssetCount);
        NSLog(@"Start Date：%@", obj.startDate);
        NSLog(@"End Date：%@", obj.endDate);
        NSLog(@"Approximate Location：%@", obj.approximateLocation);
        NSLog(@"Localized Location Names：%@", obj.localizedLocationNames);
        
        PHFetchResult<PHAsset *> * assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
        NSLog(@"ID：%ld", idx);
        NSLog(@"Count：%ld", assetResult.count);
        NSLog(@"Image Count:%ld",[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeImage]);
        NSLog(@"Video Count:%ld",[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo]);
        NSLog(@"Audio Count:%ld",[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeAudio]);
        
        ac.collectionDescription=[NSString stringWithFormat:@"文件数量：%ld（图片：%ld，视频：%ld，音频：%ld）", assetResult.count ,[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] ,[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo],[assetResult countOfAssetsWithMediaType:PHAssetMediaTypeAudio]];
        
        
        [dataArray addObject:ac];
        
    }];
    _dataSource=dataArray.copy;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //warning Incomplete implementation, return the number of rows
    //return data.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier=@"collectionID";
    
    CollectionTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        //为单元格设置样式
        cell=[[CollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    AssetCollection * ac=self.dataSource[indexPath.row];
    cell.titleLabel.text=ac.title;
    cell.desciptionLabel.text=ac.collectionDescription;
    return cell;
}

/**
 设置单元格的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
