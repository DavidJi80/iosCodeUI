//
//  SimpleTableViewController.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/18.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleTableViewCell.h"
#import "Person.h"
#import "GestureTableViewController.h"

@interface SimpleTableViewController (){
    NSArray * data;
    //定义数据源
}

@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItem];
    
    //初始化数据
    [self initDataSource];
}

-(void)initNavigationItem{
    self.navigationItem.title=@"Table View";
    
    //self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Lfet Bar" style:(UIBarButtonItemStylePlain) target:self action:@selector(goGesture)];
    //UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Table View" style:UIBarButtonItemStylePlain target:nil action:nil];
    //self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationItem.hidesBackButton=YES;
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Gesture" style:(UIBarButtonItemStylePlain) target:self action:@selector(goGesture)];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}

-(void)initDataSource{
    
    self.dataSource=[Person initPersonDataSource];
}

-(void)goGesture{
    GestureTableViewController * vc=[[GestureTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

/**
 用来指定表视图的分区个数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //warning Incomplete implementation, return the number of sections
    return 1;
}

/**
 用来指定特定分区有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //warning Incomplete implementation, return the number of rows
    //return data.count;
    return self.dataSource.count;
}

/**
 配置特定行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier=@"nameID";
    
    SimpleTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        //为单元格设置样式
        cell=[[SimpleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //NSString * name=data[indexPath.row];
    Person * person=self.dataSource[indexPath.row];
    cell.textLabel.text=person.name;
    cell.ageLabel.text=[NSString stringWithFormat:@"%zd",person.age];
    return cell;
}

/**
 设置单元格的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/**
 设置单元格的点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"MSG" message:data[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
