//
//  LivePhotoViewController.h
//  iosCodeUI
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface LivePhotoViewController : UIViewController

@property (nonatomic,strong) PHLivePhoto * livePhoto;

@end

NS_ASSUME_NONNULL_END
