//
//  PickViewVC.m
//  iosCodeUI
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "PickViewVC.h"

@interface PickViewVC ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSDictionary *_books;
    NSArray *_authors;
    NSString *_selectedAuthor;  //保存当前选中的作者
}

@property (strong, nonatomic) UIPickerView *pickerView;

@end

@implementation PickViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _books=@{
             @"莫言":@[@"蛙",@"丰乳肥臀",@"红高粱"],
             @"韩寒":@[@"想得美",@"就这么漂来漂去",@"一座城池"],
             @"郭敬明":@[@"小时代",@"爵迹",@"幻城"],
             };
    _authors=[_books allKeys]; //获取_books中所有的key,也就是获取所有的作者名，以数组形式输出
    _selectedAuthor=_authors[0]; //设置默认选中_authors中的第一个元素
    
    _pickerView=[UIPickerView new];
    //_pickerView.backgroundColor=[UIColor blackColor];
    _pickerView.frame=CGRectMake(30, 100, 300, 200);
    self.pickerView.dataSource=self;
    self.pickerView.delegate=self;
    
    [self.view addSubview:self.pickerView];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component==0) { //如果是第一列
        return _authors.count; //返回_authors中元素的个数,即_authors包含多少个元素，第一列就包含多少个列表项
    }else{ //如果是其他列，当然这里只有第二列(书名列)
        return [_books[_selectedAuthor] count]; //返回_books中_selectedAuthor中对应的NSArray中元素的个数
    }
    
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component==0) {
        return _authors[row]; //思路:按自然顺序0,1,2排下来的
    }else{
        return [_books[_selectedAuthor] objectAtIndex:row];  //接着上面的思路:因为前面的作者列是按自然顺序0,1,2排列下来的，所以书名列也是按照第一个作者的作品自然排序的
    }
}

//UIPickerViewDelegate中定义的方法,该方法返回的CGFloat将作为UIPickerView中指定的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component==0) {
        return 90;
    }else{
        return 200;
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component==0) {
        _selectedAuthor=_authors[row];  //只要第一作者列不变，第二列作品也不会变
        [self.pickerView reloadComponent:1]; //控制重写第二个列表,根据选中的作者来加载第二个列表
        [self.pickerView selectRow:0 inComponent:1 animated:YES]; //每当选择作者列的时候，让书名列默认选中的都是第一行(Row为0的那一行)
    }
    if (component==1) {
    }
}

@end
