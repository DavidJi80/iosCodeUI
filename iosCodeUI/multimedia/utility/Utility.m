//
//  Utility.m
//  iosCodeUI
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (UIViewController *)getViewControllerByView:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
