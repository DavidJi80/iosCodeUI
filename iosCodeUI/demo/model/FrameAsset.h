//
//  FrameAsset.h
//  iosCodeUI
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface FrameAsset : NSObject

@property (nonatomic,strong) UIImage * frameImage;
@property (nonatomic,assign) CGPoint point;

@end

NS_ASSUME_NONNULL_END
