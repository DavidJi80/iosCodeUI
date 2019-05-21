//
//  AVPlayerViewController.h
//  iosCodeUI
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "Video.h"
#import "AVPlayerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerViewController : UIViewController<AVPlayerDelegate>

@property (nonatomic,copy) NSMutableArray<Video *> * videos;

@end

NS_ASSUME_NONNULL_END
