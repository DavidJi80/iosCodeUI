//
//  Utility.h
//  iosCodeUI
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject

+ (UIViewController *)getViewControllerByView:(UIView *)view;
+ (NSString *)getNowTime;
+(NSURL *)generateNSURL;

@end

NS_ASSUME_NONNULL_END
