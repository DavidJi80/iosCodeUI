//
//  AVCompositionViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "AVCompositionViewController.h"

@interface AVCompositionViewController ()

@end

@implementation AVCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)aa{
    for (Video * video in _videos){
        NSURL * nsUrl=[NSURL URLWithString:video.url];
        NSDictionary * options=@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES};
        AVAsset * asset=[AVURLAsset URLAssetWithURL:nsUrl options:options];
        NSArray * keys=@[@"tracks",@"duration",@"commonMetadata"];
        [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
            
        }];
    }
}

@end
