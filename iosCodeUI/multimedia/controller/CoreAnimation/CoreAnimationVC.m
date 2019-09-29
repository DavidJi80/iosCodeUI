//
//  CoreAnimationVC.m
//  iosCodeUI
//
//  Created by mac on 2019/9/6.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CoreAnimationVC.h"

typedef enum _AnimationType {
    BASIC,
    DEFAULT,
    KEYFREAME
} AnimationType;


@interface CoreAnimationVC ()<CALayerDelegate>

@property (nonatomic,strong) CALayer * testLayer;
@property (nonatomic,assign) AnimationType animationType;
@property (nonatomic,strong) CAKeyframeAnimation *positionAnimation;

@end

@implementation CoreAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    [self initAnimation];
}

#pragma mark - UI

-(void)initNavigation{
    UIBarButtonItem * layerBBI=[[UIBarButtonItem alloc]initWithTitle:@"Layer" style:(UIBarButtonItemStylePlain) target:self action:@selector(setLayerActionSheet:)];
    UIBarButtonItem * animationBBI=[[UIBarButtonItem alloc]initWithTitle:@"Animation" style:(UIBarButtonItemStylePlain) target:self action:@selector(setAnimationActionSheet:)];
    self.navigationItem.rightBarButtonItems=@[animationBBI,layerBBI];
}

-(void)setLayerActionSheet:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *delegateAction = [UIAlertAction actionWithTitle:@"CALayerDelegate" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.testLayer display];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    [alert addAction:delegateAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setAnimationActionSheet:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *basicAnimationAction = [UIAlertAction actionWithTitle:@"CABasicAnimation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.animationType=BASIC;
    }];
    UIAlertAction *defaultAnimationAction = [UIAlertAction actionWithTitle:@"隐式动画" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.animationType=DEFAULT;
    }];
    UIAlertAction *keyframeAnimationAction = [UIAlertAction actionWithTitle:@"CAKeyframeAnimation" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.animationType=KEYFREAME;
        [self initKeyframeAnimation];
    }];
    UIAlertAction *keyframeAnimationAction2 = [UIAlertAction actionWithTitle:@"CAKeyframeAnimation 2" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self execKeyframeAnimation2];
    }];
    UIAlertAction *animationGroupAction = [UIAlertAction actionWithTitle:@"CAAnimationGroup" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self animationGroupDemo];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    [alert addAction:basicAnimationAction];
    [alert addAction:defaultAnimationAction];
    [alert addAction:keyframeAnimationAction];
    [alert addAction:keyframeAnimationAction2];
    [alert addAction:animationGroupAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Layer

-(void)initAnimation{
    self.testLayer = ({
        CALayer *tempLayer = [CALayer new];
        //UIImage *image = [UIImage imageNamed:@"basketball80.png"];
        //内容
        //tempLayer.contents=(id)image.CGImage;                       //内容
        //tempLayer.contentsRect=CGRectMake(0.2, 0.2, 0.6, 0.6);      //部分矩形(单元坐标空间)
        //
        tempLayer.delegate=self;
        //图层的外观
        tempLayer.opacity=1.0;                                      //不透明度
        tempLayer.hidden=NO;                                        //是否显示
        tempLayer.cornerRadius=30;                                  //圆角
        tempLayer.borderWidth=0;                                    //边框的宽度
        tempLayer.borderColor=UIColor.blackColor.CGColor;           //边框的颜色
        tempLayer.backgroundColor = [UIColor redColor].CGColor;     //背景颜色
        tempLayer.shadowOpacity=1;                                  //阴影的不透明度
        tempLayer.shadowRadius=5;                                   //阴影的半径
        tempLayer.shadowOffset=CGSizeMake(5.0, 5.0);                //阴影的偏移量
        tempLayer.shadowColor=UIColor.grayColor.CGColor;            //阴影的颜色
        //图层的几何形状
        tempLayer.bounds = CGRectMake(0, 0, 60, 60);                //边界
        tempLayer.position = self.view.center;                      //位置
        
        [self.view.layer addSublayer:tempLayer];
        tempLayer;
    });
    self.animationType=BASIC;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
    switch (self.animationType) {
        case BASIC:
            [self basicAnimation:touches];
            break;
        case DEFAULT:
            [self defalutAnimation:touches];
            break;
        case KEYFREAME:
            [self.testLayer addAnimation:self.positionAnimation forKey:@"position"];
            break;
        default:
            break;
    }
}


#pragma mark - Animation
#pragma mark -- CABasicAnimation

/**
 CABasicAnimation
 */
-(void)basicAnimation:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //CABasicAnimation
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    //CABasicAnimation 篡改值
    positionAnimation.fromValue = [NSValue valueWithCGPoint:self.testLayer.presentationLayer.position]; //开始篡改的值
    positionAnimation.toValue = [NSValue valueWithCGPoint:point];                                       //结束篡改的值
    //CAMediaTiming
    positionAnimation.duration = 0.1f;                   //动画时长
    positionAnimation.fillMode = kCAFillModeForwards;   //动画结束后是否保持状态
    //CAAnimation 动画属性
    positionAnimation.removedOnCompletion = NO;         //是否在完成时移除
    
    [self.testLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    //修改透明度
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.3];
    fadeAnim.duration = 1.0;
    [self.testLayer addAnimation:fadeAnim forKey:@"opacity"];
    
    //旋转动画
    CABasicAnimation* transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:0.0];
    transformAnim.toValue = [NSNumber numberWithFloat:5.0];
    transformAnim.duration = 1.0;
    [self.testLayer addAnimation:transformAnim forKey:@"rotateAnimation"];
}

#pragma mark -- 隐式动画

/**
 隐式动画
 */
- (void)defalutAnimation:(NSSet<UITouch *> *)touches{
    UITouch *touch = [touches anyObject];
    self.testLayer.position = [touch locationInView:self.view];//修改位置的隐式动画
    CGFloat WH = arc4random_uniform(100);
    if (WH < 20) {
        WH += 50;
    }
    //self.testLayer.bounds = CGRectMake(0, 0, WH, WH);
    UIColor *color = [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.f];
    self.testLayer.backgroundColor = color.CGColor;//修改背景色的隐式动画
}

#pragma mark -- CAKeyframeAnimation

-(void)initKeyframeAnimation{
    //重新设置初始位置
    self.testLayer.position = CGPointMake(33.5, 409.5);
    //self.testLayer.bounds = CGRectMake(0, 0, 50, 50);
    
    CGPathRef bezirePath = [self bezirePath];
    
    //绘制轨迹
    CAShapeLayer *positionTrackLayer = [[CAShapeLayer alloc] init];
    
    positionTrackLayer.path = bezirePath;
    positionTrackLayer.strokeColor = [UIColor redColor].CGColor;
    positionTrackLayer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:positionTrackLayer];
    
    //添加保存动画
    self.positionAnimation = [self keyframeAnimation:bezirePath];
}

- (CGPathRef)bezirePath{
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    CGPoint fromPoint = CGPointMake(33.5, 409.5);
    [bezierPath moveToPoint: fromPoint];
    [bezierPath addCurveToPoint: CGPointMake(127.5, 119.78) controlPoint1: CGPointMake(58.5, 433.93) controlPoint2: CGPointMake(86.5, 95.16)];
    [bezierPath addCurveToPoint: CGPointMake(183.5, 554.5) controlPoint1: CGPointMake(168.5, 144.4) controlPoint2: CGPointMake(112.5, 557.05)];
    [bezierPath addCurveToPoint: CGPointMake(251.5, 119.78) controlPoint1: CGPointMake(254.5, 551.95) controlPoint2: CGPointMake(251.5, 119.78)];
    return bezierPath.CGPath;
}

- (CAKeyframeAnimation *)keyframeAnimation:(CGPathRef)bezirePath{
    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    moveAnimation.path = bezirePath;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.duration = 3.f;
    
    return moveAnimation;
}

#pragma mark -- CAKeyframeAnimation path timing
-(void)execKeyframeAnimation2{
    // create a CGPath that implements two arcs (a bounce)
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,NULL,100.0,100.0);
    CGPathAddCurveToPoint(thePath,NULL,100.0,500.0,
                          160.0,500.0,
                          160.0,100.0);
    CGPathAddCurveToPoint(thePath,NULL,160.0,500.0,
                          320.0,500.0,
                          320.0,100.0);
    
    CAKeyframeAnimation * theAnimation;
    
    // Create the animation object, specifying the position property as the key path.
    theAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    theAnimation.path=thePath;
    theAnimation.duration=5.0;
    
    // Add the animation to the layer.
    [self.testLayer addAnimation:theAnimation forKey:@"position"];
}

#pragma mark -- CAAnimationGroup
-(void)animationGroupDemo{
    if (self.testLayer.animationKeys.count>0){
        [self.testLayer removeAllAnimations];
    }else{
        //设置x轴方向的缩放动画
        CAKeyframeAnimation *xScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        xScaleAnimation.values = @[@1, @0.9, @1, @1.1, @0.9, @1];
        xScaleAnimation.duration = 3.f;
        xScaleAnimation.repeatCount = 2;
        xScaleAnimation.removedOnCompletion = NO;
        xScaleAnimation.fillMode = kCAFillModeForwards;
        
        //设置y轴方向的缩放动画
        CAKeyframeAnimation *yScaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        yScaleAnimation.values = @[@0.9, @1, @1.1, @0.8, @1, @0.9];
        yScaleAnimation.duration = 3.f;
        yScaleAnimation.repeatCount = 2;
        yScaleAnimation.removedOnCompletion = NO;
        yScaleAnimation.fillMode = kCAFillModeForwards;
        
        //设置x轴方向的移动动画
        CAKeyframeAnimation *xTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        xTranslationAnimation.values = @[@0, @5, @(-5), @0, @5, @0];
        xTranslationAnimation.duration = 3.f;
        xTranslationAnimation.repeatCount = 2;
        xTranslationAnimation.removedOnCompletion = NO;
        xTranslationAnimation.fillMode = kCAFillModeForwards;
        
        //设置y轴方向的移动动画
        CAKeyframeAnimation *yTranslationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        yTranslationAnimation.values = @[@0, @5, @1, @-5, @0];
        yTranslationAnimation.duration = 3.f;
        yTranslationAnimation.repeatCount = 2;
        yTranslationAnimation.removedOnCompletion = NO;
        yTranslationAnimation.fillMode = kCAFillModeForwards;
        
        //组动画
        CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc] init];
        groupAnimation.animations = @[xScaleAnimation, yScaleAnimation, xTranslationAnimation, yTranslationAnimation];//将所有动画添加到动画组
        groupAnimation.duration = 3.f;
        groupAnimation.repeatCount = 2;
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.fillMode = kCAFillModeForwards;
        
        [self.testLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
    }
}

#pragma mark - CALayerDelegate

- (void)displayLayer:(CALayer *)layer{
    UIImage *image = [UIImage imageNamed:@"basketball80.png"];
    //内容
    layer.contents=(id)image.CGImage;
    //layer.contentsGravity=kCAGravityLeft;
}

- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)theContext {
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath,NULL,15.0f,15.f);
    CGPathAddCurveToPoint(thePath,
                          NULL,
                          15.f,250.0f,
                          295.0f,250.0f,
                          295.0f,15.0f);
    
    CGContextBeginPath(theContext);
    CGContextAddPath(theContext, thePath);
    
    CGContextSetLineWidth(theContext, 5);
    CGContextStrokePath(theContext);
    
    // Release the path
    CFRelease(thePath);
}


@end
