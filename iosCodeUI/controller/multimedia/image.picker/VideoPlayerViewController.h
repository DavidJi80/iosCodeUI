//
//  VideoPlayerViewController.h
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/5.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayerViewController : UIViewController

@property(strong,nonatomic) NSURL * mediaUrl;

@end

NS_ASSUME_NONNULL_END
