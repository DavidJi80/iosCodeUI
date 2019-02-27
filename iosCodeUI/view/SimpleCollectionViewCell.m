//
//  SimpleCollectionViewCell.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/26.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleCollectionViewCell.h"

@implementation SimpleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 10.f;
        self.backgroundColor = [UIColor greenColor];
        self.clipsToBounds = YES;
    }
    return self;
    
}

@end
