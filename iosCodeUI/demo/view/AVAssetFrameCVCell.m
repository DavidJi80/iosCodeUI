//
//  AVAssetFrameCVCell.m
//  iosCodeUI
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVAssetFrameCVCell.h"



@implementation AVAssetFrameCVCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    
        _frameImageView=[UIImageView new];
        _frameImageView.frame=CGRectMake(0, 0, 160, 90);
        [self addSubview:_frameImageView];
        
        _pointLabel=[UILabel new];
        _pointLabel.frame=CGRectMake(0, 30, 160, 20);
        _pointLabel.textAlignment=NSTextAlignmentCenter;
        _pointLabel.textColor=[UIColor whiteColor];
        _pointLabel.font=[UIFont systemFontOfSize:(12)];
        [self addSubview:_pointLabel];
        

    }
    return self;
}

@end
