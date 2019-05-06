//
//  LineProcessView.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/6.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "LineProcessView.h"

@implementation LineProcessView{
    CAShapeLayer* _layer;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupView];
}

-(void)setupView{
    CGFloat width =self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    UIBezierPath * bezierPath = [[UIBezierPath alloc]init];
    [bezierPath moveToPoint:CGPointMake(0, height/2)];
    [bezierPath addLineToPoint:CGPointMake(width, height/2)];
    _layer = [CAShapeLayer layer];
    _layer.path= bezierPath.CGPath;
    _layer.fillColor = [UIColor clearColor].CGColor;
    _layer.strokeEnd = 0;
    _layer.strokeColor = RGBA(33, 178, 123, 1).CGColor;
    _layer.lineWidth = height;//线宽
    _layer.lineCap = @"round";//圆角
    [self.layer addSublayer:_layer];
    self.layer.cornerRadius=  height/2;
    self.clipsToBounds = YES;
    self.backgroundColor = RGBA(216, 216, 216, 1);
}

-(void)setProcessValue:(float)processValue{
    _processValue= processValue;
    _layer.strokeEnd= processValue;

}

@end
