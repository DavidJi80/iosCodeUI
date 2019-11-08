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

static NSString * cellIdentifier=@"SimpleTableViewControllerCell";

@interface SimpleTableViewController (){
    NSArray * data;
    //定义数据源
}

@property (nonatomic,strong) NSArray * dataSource;

@end

@implementation SimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItem];  //初始化Navigation
    [self initTableView];       //初始化TableView
}

-(void)initNavigationItem{
    self.navigationItem.title=@"Table View";
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Lfet Bar" style:(UIBarButtonItemStylePlain) target:self action:@selector(goGesture)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Table View" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = barButtonItem;
    self.navigationItem.hidesBackButton=YES;
    
    UIBarButtonItem * showSelectBBI=[[UIBarButtonItem alloc]initWithTitle:@"选择" style:(UIBarButtonItemStylePlain) target:self action:@selector(showSelect)];
    UIBarButtonItem * editBBI=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editMode)];
    self.navigationItem.rightBarButtonItems=@[editBBI,showSelectBBI];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}


-(void)goGesture{
    GestureTableViewController * vc=[[GestureTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)initTableView{
    self.dataSource=[Person initPersonDataSource];
    //1.6. TableView外观
    NSLog(@"%ld",(long)self.tableView.style);             //style
    //tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 20)];
    headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel * titleLabel=[UILabel new];
    titleLabel.frame=CGRectMake(12, 14, SCREEN_WIDTH, 17);
    titleLabel.textColor=[UIColor redColor];
    titleLabel.font=[UIFont systemFontOfSize:(17)];
    titleLabel.text=@"Table Header View";
    [headerView addSubview:titleLabel];
    [headerView.layer setBackgroundColor:UIColor.greenColor.CGColor];
    self.tableView.tableHeaderView=headerView;      //tableHeaderView
    //tableFooterView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 20)];
    footerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel * titleLabel2=[UILabel new];
    titleLabel2.frame=CGRectMake(12, 14, SCREEN_WIDTH, 17);
    titleLabel2.textColor=[UIColor redColor];
    titleLabel2.font=[UIFont systemFontOfSize:(17)];
    titleLabel2.text=@"Table Footer View";
    [footerView addSubview:titleLabel2];
    [footerView.layer setBackgroundColor:UIColor.greenColor.CGColor];
    self.tableView.tableFooterView=footerView;      //footerView
    //backgroundView
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, 20)];
    backgroundView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 20);
    [backgroundView.layer setBackgroundColor:UIColor.grayColor.CGColor];
    self.tableView.backgroundView=backgroundView;
    //1.7. 配置单元格高度和布局
    self.tableView.rowHeight=80;                //行的默认高度
    self.tableView.estimatedRowHeight=80;       //行的估计高度
    self.tableView.cellLayoutMarginsFollowReadableWidth=YES;
    //self.tableView.insetsContentViewsToSafeArea=YES;
    //1.8. 配置页眉和页脚高度
    self.tableView.sectionHeaderHeight=45;
    self.tableView.sectionFooterHeight=45;
    self.tableView.estimatedSectionHeaderHeight=45;
    self.tableView.estimatedSectionFooterHeight=45;
    //1.9. 自定义分隔符外观
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;                      //分隔符的样式
    self.tableView.separatorColor=UIColor.greenColor;                                           //分隔符颜色
    //separatorEffect
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    self.tableView.separatorEffect = vibrancyEffect;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 30, 0, 30);                             //分隔符的默认间隔
    //self.tableView.separatorInsetReference=UITableViewSeparatorInsetFromAutomaticInsets;        //separatorInset属性的参照值
    //1.12. 选择
    self.tableView.allowsSelection=YES;                         //是否可以选择
    self.tableView.allowsMultipleSelection=YES;                 //是否可以多选
    self.tableView.allowsSelectionDuringEditing=YES;            //在编辑模式下是否可以选择
    self.tableView.allowsMultipleSelectionDuringEditing=YES;    //在编辑模式下是否可以多选
}


#pragma mark - UITableView
#pragma mark -- Selecting Rows
-(void)showSelect{
    NSString * selectedIndexPaths=@"";
    for (NSIndexPath * indexPath in self.tableView.indexPathsForSelectedRows){
        selectedIndexPaths=[NSString stringWithFormat:@"%@[%ld,%d],",selectedIndexPaths,indexPath.section,indexPath.row];
    }
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"选中" message:selectedIndexPaths preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -- Putting the Table into Edit Mode
-(void)editMode{
    if (self.tableView.isEditing){
        [self.tableView setEditing:NO];
    }else{
        [self.tableView setEditing:YES];
    }
}



#pragma mark - UITableViewDataSource
/**
 用来指定表视图的分区个数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

/**
 用来指定特定分区有多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray<Person *> * persons=[self.dataSource objectAtIndex:section];
    return persons.count;
}

/**
 配置特定行的单元格
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SimpleTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell){
        cell=[[SimpleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Person * person=self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text=person.name;
    cell.ageLabel.text=[NSString stringWithFormat:@"%d-%zd",indexPath.section,person.age];
    return cell;
}

/**
 Section的页眉
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"Section%d",section];
}

/**
 Section的页脚
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSMutableArray<Person *> * persons=[self.dataSource objectAtIndex:section];
    return [NSString stringWithFormat:@"Count：%d",persons.count];
}

#pragma mark - UITableViewDelegate
#pragma mark -- Configuring Rows for the Table View
/**
 Cell将要显示时调用
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Cell %@ will Display",indexPath);
}

/**
 text的缩进
 */
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 5;
}

/**
 SpringLoad
 */
- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context  NS_AVAILABLE_IOS(11_0){
    return YES;
}

#pragma mark -- Responding to Row Selections
/**
 在点击一行后手指离开时调用
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@ will Select Row",indexPath);
    return indexPath;
}

/**
 设置单元格的点击事件
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"MSG" message:data[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"didSelect:%d--%d",indexPath.section,indexPath.row] style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"MSG" message:data[indexPath.row] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"didDeselect:%d--%d",indexPath.section,indexPath.row] style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

#pragma mark -- Providing Custom Header and Footer Views
/**
 设置Section的自定义页眉视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat width=self.tableView.frame.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width, 20)];
    headerView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UILabel * titleLabel=[UILabel new];
    titleLabel.frame=CGRectMake(12, 14, SCREEN_WIDTH, 17);
    titleLabel.textColor=[UIColor redColor];
    titleLabel.font=[UIFont systemFontOfSize:(17)];
    titleLabel.text=[NSString stringWithFormat:@"Section%d",section];
    [headerView addSubview:titleLabel];
    [headerView.layer setBackgroundColor:UIColor.yellowColor.CGColor];
    return headerView;
}

/**
 设置Section的自定义页眉视图
 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSMutableArray<Person *> * persons=[self.dataSource objectAtIndex:section];
    CGFloat width=self.tableView.frame.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width, 20)];
    headerView.frame=CGRectMake(0, 0, width, 45);
    UILabel * titleLabel=[UILabel new];
    titleLabel.frame=CGRectMake(12, 14, width, 17);
    titleLabel.textColor=[UIColor redColor];
    titleLabel.font=[UIFont systemFontOfSize:(17)];
    titleLabel.text=[NSString stringWithFormat:@"Count:%d",persons.count];
    [headerView addSubview:titleLabel];
    [headerView.layer setBackgroundColor:UIColor.greenColor.CGColor];
    return headerView;
}

/**
 将显示指定Section的页眉视图
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    NSLog(@"willDisplayHeaderView:%d",section);
}

/**
 将显示指定Section的页脚视图
 */
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    NSLog(@"willDisplayFooterView:%d",section);
}


#pragma mark -- Providing Header, Footer, and Row Heights
/**
 设置单元格的高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

/**
 Section页眉的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

/**
 Section页脚的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 45;
}

#pragma mark -- Responding to Row Actions
/**
 右滑
 */
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(11_0) {
    UIContextualAction *favourRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:@"收藏" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        CGFloat red   = (arc4random() % 256) / 256.0;
        CGFloat green = (arc4random() % 256) / 256.0;
        CGFloat blue  = (arc4random() % 256) / 256.0;
        
        cell.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        
        completionHandler(YES);
    }];
    favourRowAction.backgroundColor = [UIColor orangeColor];
    
    UISwipeActionsConfiguration *favourRowConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[favourRowAction]];
    return favourRowConfiguration;

}

/**
 左滑
 */
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(11_0) {
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //[self.dataSource removeObjectAtIndex:0];
        
        completionHandler(YES);
    }];
    if (indexPath.row % 2==0) {
        deleteRowAction.image = [UIImage imageNamed:@"deleteRow"];
    }
    UISwipeActionsConfiguration *deleteRowConfiguration = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return deleteRowConfiguration;
}

/**
 是否显示编辑菜单
 */
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

/**
 指定可以执行的命令
 */
-(BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    //NSLog(@"%@",NSStringFromSelector(action));
    if (indexPath.row==0){
        if (action == @selector(copy:)) {
            return YES;
        }
        return NO;
    }else{
        return YES;
    }
}

/**
 执行命令
 */
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (action==@selector(copy:)) {//如果操作为复制
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];//黏贴板
        [pasteBoard setString:cell.textLabel.text];
        NSLog(@"%@",pasteBoard.string);//获得剪贴板的内容
    }
}

/**
 ios老版本左滑手势
 */
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        }];
    rowAction.backgroundColor = [UIColor purpleColor];
    UITableViewRowAction *rowaction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    rowaction.backgroundColor = [UIColor grayColor];
    NSArray *arr = @[rowAction,rowaction];
    return arr;
}

#pragma mark -- Managing Table View Highlights
/**
 
 */
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor greenColor];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=[UIColor darkGrayColor];
}


@end
