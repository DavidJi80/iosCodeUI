//
//  FrameCollectionViewCell.m
//  iosCodeUI
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "FrameCollectionViewCell.h"

@implementation FrameCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        float sizeWH=57;
        
        _imageView=[UIImageView new];
        _imageView.frame=CGRectMake(0, 0, sizeWH, sizeWH);
        
        [self addSubview:_imageView];
    }
    return self;
}

@end
