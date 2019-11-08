//
//  VideoAsset.h
//  iosCodeUI
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoAsset : NSObject

@property (nonatomic,assign) NSInteger duration;
@property (nonatomic,strong) UIImage *coverImage;
@property (nonatomic,strong) PHAsset *phAsset;

@end

NS_ASSUME_NONNULL_END
