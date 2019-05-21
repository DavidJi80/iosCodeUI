//
//  AlertViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AlertViewController.h"
#import <objc/runtime.h>

#define videoActionText NSLocalizedString(@"Video", nil)
#define gifActionText   NSLocalizedString(@"Gif", nil)
#define photoActionText NSLocalizedString(@"Take Photos", nil)
#define albumActionText NSLocalizedString(@"Album", nil)
#define cancelText      NSLocalizedString(@"Cancle", nil)

@interface AlertViewController ()

@property(nonatomic,strong) UIButton * styleAlertBtn;
@property(nonatomic,strong) UIButton * colorStyleAlertBtn;
@property(nonatomic,strong) UIButton * styleActionSheetBtn;
@property(nonatomic,strong) UIButton * styleDatePickerBtn;
@property(nonatomic,strong) UIButton * styleCountDownBtn;

@property(nonatomic,copy) dispatch_source_t timer;

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _styleAlertBtn=[UIButton new];
    _styleAlertBtn.backgroundColor=[UIColor blackColor];
    _styleAlertBtn.frame=CGRectMake(30, 100, SCREEN_WIDTH-60, 45);
    [_styleAlertBtn setTitle:@"Style Alert" forState:UIControlStateNormal];
    [_styleAlertBtn.layer setCornerRadius:10.0];
    [_styleAlertBtn addTarget:self action:@selector(openStyleAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    _colorStyleAlertBtn=[UIButton new];
    _colorStyleAlertBtn.backgroundColor=[UIColor redColor];
    _colorStyleAlertBtn.frame=CGRectMake(30, 150, SCREEN_WIDTH-60, 45);
    [_colorStyleAlertBtn setTitle:@"Color Style Alert" forState:UIControlStateNormal];
    [_colorStyleAlertBtn.layer setCornerRadius:10.0];
    [_colorStyleAlertBtn addTarget:self action:@selector(openColorStyleAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    _styleActionSheetBtn=[UIButton new];
    _styleActionSheetBtn.backgroundColor=[UIColor greenColor];
    _styleActionSheetBtn.frame=CGRectMake(30, 200, SCREEN_WIDTH-60, 45);
    [_styleActionSheetBtn setTitle:@"Style Action Sheet" forState:UIControlStateNormal];
    [_styleActionSheetBtn.layer setCornerRadius:10.0];
    [_styleActionSheetBtn addTarget:self action:@selector(openActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    _styleDatePickerBtn=[UIButton new];
    _styleDatePickerBtn.backgroundColor=[UIColor cyanColor];
    _styleDatePickerBtn.frame=CGRectMake(30, 250, SCREEN_WIDTH-60, 45);
    [_styleDatePickerBtn setTitle:@"Style Date Picker" forState:UIControlStateNormal];
    [_styleDatePickerBtn.layer setCornerRadius:10.0];
    [_styleDatePickerBtn addTarget:self action:@selector(openDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    _styleCountDownBtn=[UIButton new];
    _styleCountDownBtn.backgroundColor=[UIColor brownColor];
    _styleCountDownBtn.frame=CGRectMake(30, 300, SCREEN_WIDTH-60, 45);
    [_styleCountDownBtn setTitle:@"Style Count Down" forState:UIControlStateNormal];
    [_styleCountDownBtn.layer setCornerRadius:10.0];
    [_styleCountDownBtn addTarget:self action:@selector(openCountDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_styleAlertBtn];
    [self.view addSubview:_colorStyleAlertBtn];
    [self.view addSubview:_styleActionSheetBtn];
    [self.view addSubview:_styleDatePickerBtn];
    [self.view addSubview:_styleCountDownBtn];
}

-(void)openStyleAlert:(UIButton*)sender{
    NSString *title = NSLocalizedString(@"Title", nil);
    NSString *message = NSLocalizedString(@"I'm message", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    NSString *okTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Click Cancel Button!");
    }];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *urlStr = [NSURL URLWithString:@"http://www.baidu.com"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                [[UIApplication sharedApplication] openURL:urlStr options:@{} completionHandler:nil];
            }
        });
    }];
    
    
    
    // 添加取消按钮才能点击空白隐藏
    [alertController addAction:cancelAction];
    [alertController addAction:OKAction];
    
    // 由于它是一个控制器 直接modal出来就好了
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)openColorStyleAlert:(UIButton*)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"Tip"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(0, 3)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    // message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"Message Content"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(4, 7)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 15)];
    [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    NSString *okTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"Click Cancel Button!");
    }];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *urlStr = [NSURL URLWithString:@"http://www.baidu.com"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                [[UIApplication sharedApplication] openURL:urlStr options:@{} completionHandler:nil];
            }
        });
    }];
    // 添加取消按钮才能点击空白隐藏
    [alertController addAction:cancelAction];
    [alertController addAction:OKAction];
    
    // 由于它是一个控制器 直接modal出来就好了
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)openActionSheet:(UIButton*)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *videoAction = [UIAlertAction actionWithTitle:videoActionText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *gifAction = [UIAlertAction actionWithTitle:gifActionText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:photoActionText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:albumActionText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    // KVC 改变颜色
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([UIAlertAction class], &count);
    for(int i = 0; i < count; i ++) {
        objc_property_t property = propertys[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([propertyName isEqualToString:@"_titleTextColor"]) {
            [self setValue:[UIColor greenColor] forKey:propertyName];
        }
    }
    
    [cancelAction setValue:[UIColor redColor] forKey:@"_titleTextColor"];
    
    [alert addAction:videoAction];
    [alert addAction:gifAction];
    [alert addAction:photoAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openDatePicker:(UIButton*)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIDatePicker *datePicker=[[UIDatePicker alloc] init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];// 设置日期选择控件的地区
    datePicker.locale = locale;
    [alertVC.view addSubview:datePicker];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [cancelAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}


-(void)openCountDown:(UIButton*)sender{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@向您发起连麦请求", @"username"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:OKAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    if (!_timer) {
        // 倒计时时间
        __block int timeout = 60;
        if (timeout!=0) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if (timeout<=0) {
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [OKAction setValue:[NSString stringWithFormat:@"%@(%02d)", @"同意", 0] forKey:@"title"];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [OKAction setValue:[NSString stringWithFormat:@"%@(%02d)", @"同意",timeout] forKey:@"title"];
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}


@end
