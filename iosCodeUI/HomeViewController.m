//
//  HomeViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/15.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * labalText=[NSString stringWithFormat:@"tel is %@",_phone];
    UILabel * label = [[UILabel alloc]init];
    label.text=labalText;
    [label sizeToFit];
    label.center =self.view.center;
    [self.view addSubview:label];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
