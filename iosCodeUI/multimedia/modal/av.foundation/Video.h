//
//  Video.h
//  iosCodeUI
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface Video : NSObject

@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,assign) CMTime duration;

@end

NS_ASSUME_NONNULL_END
