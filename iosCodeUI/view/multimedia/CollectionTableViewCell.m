//
//  CollectionTableViewCell.m
//  iosCodeUI
//
//  Created by mac on 2019/3/11.
//  Copyright © 2019 季舟. All rights reserved.
//

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.frame=CGRectMake(10, 30, SCREEN_WIDTH-20, 22);
        _titleLabel.text=@"";
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:(20)];
        
        _desciptionLabel=[[UILabel alloc]init];
        _desciptionLabel.frame=CGRectMake(10, 60, SCREEN_WIDTH-20, 20);
        _desciptionLabel.text=@"";
        _desciptionLabel.textColor=[UIColor lightGrayColor];
        _desciptionLabel.font=[UIFont systemFontOfSize:(15)];
        
        
        [self addSubview:_titleLabel];
        [self addSubview:_desciptionLabel];
    }
    return self;
}


@end
