//
//  PHAssetCollectionViewCell.m
//  iosCodeUI
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PHAssetCollectionViewCell.h"

@implementation PHAssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    
        _coverImageView=[UIImageView new];
        _coverImageView.frame=CGRectMake(0, 0, SCREEN_WIDTH/4-1, SCREEN_WIDTH/4);
        [self addSubview:_coverImageView];
        
        _durationLabel=[UILabel new];
        _durationLabel.frame=CGRectMake(0, SCREEN_WIDTH/4-20, SCREEN_WIDTH/4-5, 20);
        _durationLabel.textAlignment=NSTextAlignmentRight;
        _durationLabel.textColor=[UIColor whiteColor];
        _durationLabel.font=[UIFont systemFontOfSize:(12)];
        [self addSubview:_durationLabel];
    }
    return self;
}


@end
