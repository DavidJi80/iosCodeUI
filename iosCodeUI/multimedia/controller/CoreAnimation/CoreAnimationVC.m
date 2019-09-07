//
//  CoreAnimationVC.m
//  iosCodeUI
//
//  Created by mac on 2019/9/6.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CoreAnimationVC.h"

@interface CoreAnimationVC ()

@property (nonatomic,strong) CALayer * testLayer;

@end

@implementation CoreAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testLayer = ({
        CALayer *tempLayer = [CALayer new];
        tempLayer.backgroundColor = [UIColor cyanColor].CGColor;
        tempLayer.position = self.view.center;
        tempLayer.bounds = CGRectMake(0, 0, 100, 100);
        [self.view.layer addSublayer:tempLayer];
        tempLayer;
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.testLayer.presentationLayer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];
    positionAnimation.duration = 1.f;                   //动画时长
    positionAnimation.removedOnCompletion = NO;         //是否在完成时移除
    positionAnimation.fillMode = kCAFillModeForwards;   //动画结束后是否保持状态
    [self.testLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
}

@end
