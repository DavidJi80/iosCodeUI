//
//  AssetCollectionViewCell.m
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AssetCollectionViewCell.h"

@implementation AssetCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _descriptionLabel=[[UILabel alloc]init];
        _descriptionLabel.frame=CGRectMake(5, SCREEN_WIDTH/4, SCREEN_WIDTH/4, 30);
        _descriptionLabel.text=@"";
        _descriptionLabel.textColor=[UIColor redColor];
        _descriptionLabel.font=[UIFont systemFontOfSize:(17)];
        
        _imageView=[UIImageView new];
        _imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH/4-1, SCREEN_WIDTH/4);
        
        _durationLabel=[UILabel new];
        _durationLabel.frame=CGRectMake(0, SCREEN_WIDTH/4-20, SCREEN_WIDTH/4-5, 20);
        _durationLabel.textAlignment=NSTextAlignmentRight;
        _durationLabel.textColor=[UIColor whiteColor];
        _durationLabel.font=[UIFont systemFontOfSize:(12)];
        
        [self addSubview:_imageView];
        [self addSubview:_descriptionLabel];
        [self addSubview:_durationLabel];
    }
    return self;
}

@end
