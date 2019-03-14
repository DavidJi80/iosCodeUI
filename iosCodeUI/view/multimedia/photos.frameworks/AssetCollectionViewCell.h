//
//  AssetCollectionViewCell.h
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetCollectionViewCell : UICollectionViewCell

@property IBOutlet UIImageView *imageView;
@property IBOutlet UILabel * descriptionLabel;
@property IBOutlet UILabel * durationLabel;

@end

NS_ASSUME_NONNULL_END
