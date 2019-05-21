//
//  PhotosFrameworksUtility.h
//  iosCodeUI
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotosFrameworksUtility : NSObject

+(NSString *)formatCMTime:(CMTime)cmTime;

@end

NS_ASSUME_NONNULL_END
