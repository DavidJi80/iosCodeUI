//
//  IOAssetVC.h
//  iosCodeUI
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Asset.h"

NS_ASSUME_NONNULL_BEGIN

@interface IOAssetVC : UIViewController

@property (nonatomic,copy) NSMutableArray<Asset *> * videos;

@end

NS_ASSUME_NONNULL_END
