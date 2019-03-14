//
//  Asset.h
//  iosCodeUI
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface Asset : NSObject

@property (nonatomic,assign) int type;
@property (nonatomic,copy) NSString * localIdentifier;
@property (nonatomic,copy) NSString * assetDescription;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,assign) CMTime duration;

@end

NS_ASSUME_NONNULL_END
