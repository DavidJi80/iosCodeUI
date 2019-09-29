//
//  LivePhotoViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "LivePhotoViewController.h"

@interface LivePhotoViewController ()

@end

@implementation LivePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PHLivePhotoView *photoView = [[PHLivePhotoView alloc]initWithFrame:CGRectMake(0, 50,SCREEN_WIDTH,SCREEN_HEIGHT)];
    photoView.livePhoto = _livePhoto;
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    [photoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
    [self.view addSubview:photoView];
}



@end
