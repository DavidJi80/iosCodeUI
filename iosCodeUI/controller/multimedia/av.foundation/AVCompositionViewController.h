//
//  AVCompositionViewController.h
//  iosCodeUI
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Video.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVCompositionViewController : UIViewController

@property (nonatomic,copy) NSMutableArray<Video *> * videos;

@end

NS_ASSUME_NONNULL_END
