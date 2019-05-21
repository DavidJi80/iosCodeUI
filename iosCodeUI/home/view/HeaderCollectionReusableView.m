//
//  HeaderCollectionReusableView.m
//  iosCodeUI
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.frame=CGRectMake(0, 0, SCREEN_WIDTH, 30);
        _titleLabel.text=@"A";
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.font=[UIFont systemFontOfSize:(17)];
        
        [self addSubview:_titleLabel];
    }
    return self;
    
}


@end
