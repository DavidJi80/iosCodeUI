//
//  LineProcessView.h
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/6.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

NS_ASSUME_NONNULL_BEGIN

@interface LineProcessView : UIView

@property (strong , nonatomic)UIColor * defaultColor;
//背景颜色（默认值RGBA(216, 216, 216, 1)）

@property (strong , nonatomic)UIColor * fillColor;
//进度颜色（默认值RGBA(33, 178, 123, 1)）

@property(assign , nonatomic)float processValue;
//进度值

@end

NS_ASSUME_NONNULL_END
