//
//  GestureTableViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/21.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "GestureTableViewController.h"
#import "LongPressGestureVC.h"

@interface GestureTableViewController (){
    NSArray * data;
    //定义数据源
}

@end

@implementation GestureTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    data=@[@"Long Press Gesture",@"Ji Zhou"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    return data.count;
}

/**
 配置特定行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier=@"nameID";
    
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        //为单元格设置样式
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //NSString * name=data[indexPath.row];
    cell.textLabel.text=data[indexPath.row];
    return cell;
}

/**
 设置单元格的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

/**
 设置单元格的点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0){
        dispatch_async(dispatch_get_main_queue(), ^{
            LongPressGestureVC * vc=[[LongPressGestureVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        });
    }else{
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"MSG" message:data[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:true completion:nil];
        
    }
    
}

@end
