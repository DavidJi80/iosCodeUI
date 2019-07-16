//
//  McDownloadViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "McDownloadViewController.h"
#import "MCDownloader.h"

@interface McDownloadViewController ()

@property(nonatomic,strong) UIButton * mcDownloadBtn;
@property(nonatomic,strong) UIButton * mcClearBtn;

@property(nonatomic,strong) UILabel * speedLable;
@property(nonatomic,strong) UILabel * bytesLable;
@property (nonatomic,copy) NSString * url;

@end

@implementation McDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url=@"http://v.kaidanwang.com/1b39890fcccc4d58ade19852e174bb4b/53ef3739c02f4948b63c497bc4e4388d-fa6e6b6c35ad7e19d669e4560101404d-ld.mp4";
    
    _mcDownloadBtn=[UIButton new];
    _mcDownloadBtn.backgroundColor=[UIColor blueColor];
    _mcDownloadBtn.frame=CGRectMake(30, 150, 145, 45);
    [_mcDownloadBtn setTitle:@"Download..." forState:UIControlStateNormal];
    [_mcDownloadBtn.layer setCornerRadius:10.0];
    [_mcDownloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mcDownloadBtn];
    
    _speedLable=[[UILabel alloc]init];
    _speedLable.frame=CGRectMake(200, 160, 100, 20);
    _speedLable.text=@"";
    _speedLable.textColor=[UIColor redColor];
    _speedLable.font=[UIFont systemFontOfSize:(17)];
    [self.view addSubview:self.speedLable];
    
    _bytesLable=[[UILabel alloc]init];
    _bytesLable.frame=CGRectMake(300, 160, 100, 20);
    _bytesLable.text=@"";
    _bytesLable.textColor=[UIColor redColor];
    _bytesLable.font=[UIFont systemFontOfSize:(17)];
    [self.view addSubview:self.bytesLable];
    
    _mcClearBtn=[UIButton new];
    _mcClearBtn.backgroundColor=[UIColor blueColor];
    _mcClearBtn.frame=CGRectMake(30, 210, 145, 45);
    [_mcClearBtn setTitle:@"Clear" forState:UIControlStateNormal];
    [_mcClearBtn.layer setCornerRadius:10.0];
    [_mcClearBtn addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mcClearBtn];
    
}

- (void)downloadAction:(UIButton *)sender {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    
    if (receipt.state == MCDownloadStateDownloading) {
        [self.mcDownloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        //[[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
    }else if (receipt.state == MCDownloadStateCompleted) {
        [self.mcDownloadBtn setTitle:@"已下载" forState:UIControlStateNormal];
    }else {
        [self.mcDownloadBtn setTitle:@"停止" forState:UIControlStateNormal];
        [self download];
    }
    
}

- (void)download {
    [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:self.url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.bytesLable.text = [NSString stringWithFormat:@"%0.2fm/%0.2fm", receivedSize/1024.0/1024, expectedSize/1024.0/1024];
            self.speedLable.text = [NSString stringWithFormat:@"%ld/s", speed];
        });
        
    } completed:^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
        NSLog(@"%d",finished);
    }];
    
}

-(void)clearAction:(UIButton *)sender {
    MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:self.url];
    [[MCDownloader sharedDownloader] remove:receipt completed:^{

    }];
    
}

@end
