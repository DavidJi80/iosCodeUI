//
//  VideoCollectionView.h
//  iosCodeUI
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"
#import "AVPlayerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoCollectionView : UICollectionView{
}

@property (nonatomic,strong) NSMutableArray<Video *> * videoDataSource;
@property (nonatomic,strong) id<AVPlayerDelegate> avPlayerDelegate;


@end

NS_ASSUME_NONNULL_END
