//
//  AssetCollectionView.h
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray * assetDataSource;

@end

NS_ASSUME_NONNULL_END
