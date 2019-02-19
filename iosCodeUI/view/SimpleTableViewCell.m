//
//  SimpleTableViewCell.m
//  iosCodeUI
//
//  Created by 季舟 on 2019/2/18.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "SimpleTableViewCell.h"
#import "Person.h"

@implementation SimpleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 自定义Table View的Cell
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        UIButton * button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(10, 40, 50, 50);
        [button setTitle:@"Yes" forState:UIControlStateNormal];
        [button setTitle:@"No" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _ageLabel=[[UILabel alloc]init];
        _ageLabel.frame=CGRectMake(100, 40, 50, 50);
        _ageLabel.text=@"";
        _ageLabel.textColor=[UIColor redColor];
        _ageLabel.font=[UIFont systemFontOfSize:(17)];
        
        [self addSubview:button];
        [self addSubview:_ageLabel];
    }
    return self;
}

-(void)buttonPressed:(UIButton *)button{
    button.selected=!button.selected;
}


@end
