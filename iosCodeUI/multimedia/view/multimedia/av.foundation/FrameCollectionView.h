//
//  FrameCollectionView.h
//  iosCodeUI
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Frame.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrameCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray<Frame *> * frameDataSource;

@end

NS_ASSUME_NONNULL_END
