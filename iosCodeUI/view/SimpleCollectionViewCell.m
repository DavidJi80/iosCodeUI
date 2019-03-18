//
//  SimpleCollectionViewCell.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleCollectionViewCell.h"

@interface SimpleCollectionViewCell()



@end

@implementation SimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10.f;
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.frame=CGRectMake(5, 0, 30, 30);
        _titleLabel.text=@"A";
        _titleLabel.textColor=[UIColor redColor];
        _titleLabel.font=[UIFont systemFontOfSize:(17)];
        
        [self addSubview:_titleLabel];
    }
    return self;
    
}

@end
