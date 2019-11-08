//
//  AVAssetFrameCV.h
//  iosCodeUI
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrameAsset.h"

NS_ASSUME_NONNULL_BEGIN


@protocol AVAssetFrameCVDelegate <NSObject>
@required

- (void)showImage:(UIImage *)image index:(NSInteger)index;

@end

@interface AVAssetFrameCV : UICollectionView

@property (nonatomic,strong) NSMutableArray<FrameAsset *> * frameDataSource;
@property (nonatomic,strong) id<AVAssetFrameCVDelegate> frameCVDelegate;

@end

NS_ASSUME_NONNULL_END
