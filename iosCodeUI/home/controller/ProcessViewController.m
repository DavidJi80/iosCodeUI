//
//  ProcessViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/3/6.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "ProcessViewController.h"
#import "LineProcessView.h"

@interface ProcessViewController ()

@property(nonatomic,strong) UISlider * slider;
@property(nonatomic,strong) LineProcessView * lineProcessView;

@end

@implementation ProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _slider=[UISlider new];
    _slider.frame=CGRectMake(20, SCREEN_HEIGHT-100, SCREEN_WIDTH-40, 20);
    _slider.maximumValue=100.0;
    _slider.minimumValue=0.0;
    _slider.value=50;
    //添加事件
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.slider];
    [self.view addSubview:self.lineProcessView];
}

-(LineProcessView *)lineProcessView{
    if (!_lineProcessView) {
        _lineProcessView = [[LineProcessView alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT-100, SCREEN_WIDTH-40, 20)];
        _lineProcessView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 400);
    }
    return _lineProcessView;
}

/**
 事件相应方法
 */
-(void)sliderValueChanged:(UISlider *)slider{
    NSLog(@"slider value is:%f",slider.value);
    self.lineProcessView.processValue = slider.value/100.0;
}

@end

