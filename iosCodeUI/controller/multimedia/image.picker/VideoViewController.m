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
    _imageView.frame=CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:self.imageView];
    
}

-(void)initMedia{
    NSMutableArray<PHAsset *> *assets = [NSMutableArray array];
    
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetMediaType type =PHAssetMediaTypeImage;
    //self.type==5 ? PHAssetMediaTypeImage:PHAssetMediaTypeVideo;
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:type options:option];
    //__strong typeof(weakSelf) strongSelf=weakSelf;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHAsset *asset = (PHAsset *)obj;
            NSInteger type = asset.mediaType;
            //照片
            if(type==1){
                [assets addObject:asset];
            }
            else if (type==2){
                [assets addObject:asset];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            //complate(assets);
        });
    });
}

-(void)getVideo{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeVideo options:option];
    //NSMutableArray *sourceArray = [NSMutableArray arrayWithCapacity:result.count];
    for (PHAsset *assets in result) {
        NSArray *assetResources = [PHAssetResource assetResourcesForAsset:assets];
        PHAssetResource *assetRes = [assetResources firstObject];
        NSLog(@"originalFilename %@", assetRes.originalFilename);
        NSLog(@"uniformTypeIdentifier %@", assetRes.uniformTypeIdentifier);
        NSLog(@"assetLocalIdentifier %@", assetRes.assetLocalIdentifier);
    }
}

-(void)getImages{
    // 先试试用图片的identifier
    NSMutableArray * assetIdentifierArr = [NSMutableArray array];
    NSMutableArray * identifierArr = [NSMutableArray array];
    PHFetchResult<PHAssetCollection *> * result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.localIdentifier.length > 0) {
            NSLog(@"%@--%@", obj.localIdentifier, obj.localizedTitle);
            [identifierArr addObject:obj.localIdentifier];
            PHFetchResult<PHAsset *> * assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
            PHAsset * asset = assetResult.firstObject;
            [assetIdentifierArr addObject:asset.localIdentifier];
        }
    }];
    // 注意：这里使用的是单个资源的identifier
    PHFetchResult<PHAssetCollection *> * assetIdentifierResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:assetIdentifierArr options:nil];
    [assetIdentifierResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.localIdentifier.length > 0) {
            NSLog(@"%@", obj);
        }
    }];
    NSLog(@"================================");
    // 注意：这里使用的是相册的identifier
    PHFetchResult<PHAssetCollection *> * identifierResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:identifierArr options:nil];
    [identifierResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.localIdentifier.length > 0) {
            NSLog(@"%@", obj);
        }
    }];
}

/**
 初始化UIImagePickerController
 */
- (UIImagePickerController *)picker{
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
    
    UIBarButtonItem * nextBBI=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:(UIBarButtonItemStylePlain) target:self action:@selector(next)];
    self.navigationItem.rightBarButtonItems=@[nextBBI];
}

/**
 打开图片相册
 */
-(void)photoLibrary{
    self.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //自定义代理方法
    self.picker.delegate = self;
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
    self.picker.delegate = self;
    self.picker.allowsEditing = NO;
    [self presentViewController:self.picker animated:YES completion:nil];
}

/**
 打开相机
 */
-(void)camera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //self.picker.showsCameraControls=YES;
        self.picker.delegate = self;
        [self presentViewController:self.picker animated:YES completion:nil];
    } else {
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
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是照片 or 视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage * image =nil;
        //判断照片是否允许修改
        if ([self.picker allowsEditing]) {
            //获取编辑后的照片
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        self.imageView.image=image;
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        //视频
        //获取视频url
        NSURL * mediaUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        //NSString *urlPath = [mediaUrl path];
        VideoPlayerViewController * vc=[VideoPlayerViewController new];
        vc.mediaUrl=mediaUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    self.picker.delegate = nil;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
