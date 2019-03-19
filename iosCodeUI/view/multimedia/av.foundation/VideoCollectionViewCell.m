//
//  VideoCollectionViewCell.m
//  iosCodeUI
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoCollectionViewCell.h"

@implementation VideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        float sizeWH=57;
        
        _imageView=[UIImageView new];
        _imageView.frame=CGRectMake(0, 0, sizeWH, sizeWH);
        
        _durationLabel=[UILabel new];
        _durationLabel.frame=CGRectMake(0, sizeWH-14, sizeWH-2, 12);
        _durationLabel.textAlignment=NSTextAlignmentRight;
        _durationLabel.textColor=[UIColor whiteColor];
        _durationLabel.font=[UIFont systemFontOfSize:(12)];
        
        [self addSubview:_imageView];
        [self addSubview:_durationLabel];
    }
    return self;
}

@end
