//
//  VideoViewController.m
//  iosCodeUI
//
//  Created by mac on 2019/3/10.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoPlayerViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface VideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavigation];
    _imageView=[UIImageView new];
    _imageView.frame=CGRectMake(0, 0, 100, 100);
    [self.view addSubview:self.imageView];
    
    //自定义代理方法
    self.picker.delegate = self;
    //允许编辑
    self.picker.allowsEditing = YES;
    
    
    
}

/**
 初始化UIImagePickerController
 */
- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}

-(void)initNavigation{
    UIBarButtonItem * photoLibraryBBI=[[UIBarButtonItem alloc]initWithTitle:@"图片" style:(UIBarButtonItemStylePlain) target:self action:@selector(photoLibrary)];
    UIBarButtonItem * videoLibraryBBI=[[UIBarButtonItem alloc]initWithTitle:@"视频" style:(UIBarButtonItemStylePlain) target:self action:@selector(videoLibrary)];
    UIBarButtonItem * cameraBBI=[[UIBarButtonItem alloc]initWithTitle:@"相机" style:(UIBarButtonItemStylePlain) target:self action:@selector(camera)];
    self.navigationItem.leftBarButtonItems=@[photoLibraryBBI,videoLibraryBBI,cameraBBI];
    
}

/**
 打开图片相册
 */
-(void)photoLibrary{
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}

/**
 打开视频相册
 */
-(void)videoLibrary{
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}

/**
 打开相机
 */
-(void)camera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //self.picker.showsCameraControls=YES;
        [self presentViewController:self.picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 实现代理方法
 实现选择媒体后的操作
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image=image;
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 实现代理方法
 实现点击取消按钮后的操作
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)next{
    VideoPlayerViewController * vc=[[VideoPlayerViewController alloc]init];
    //再跳界面之前设置跳转后隐藏tabBar
    //self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
