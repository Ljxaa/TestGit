//
//  OACell.m
//  同安政务
//
//  Created by wx_air on 16/5/13.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OACell.h"
#import "Global.h"

@implementation OACell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:bgColor];
        UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(8, 8, screenMySize.size.width-16,(OACell_height-16))];
        [shadow.layer setCornerRadius:6.0];
        [shadow.layer setBorderWidth:0.5];
        [shadow.layer setBorderColor:lineColor.CGColor];
        [shadow setBackgroundColor:[UIColor whiteColor]];
        [shadow setClipsToBounds:YES];
        [self.contentView addSubview:shadow];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,shadow.frame.size.width-10,30)];
        [_titleLabel setNumberOfLines:2];
        [_titleLabel setText:@"标题(2016-05-05)"];
        [_titleLabel setTextColor:grayFontColor];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [shadow addSubview:_titleLabel];
        
        //分割线
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), shadow.frame.size.width, 0.5)];
        [line setBackgroundColor:lineColor];
        [shadow addSubview:line];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, CGRectGetMaxY(line.frame), _titleLabel.frame.size.width, shadow.frame.size.height - _titleLabel.frame.size.height)];
        [_contentLabel setText:@"内容"];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [shadow addSubview:_contentLabel];
    }
    return self;
}

- (void)setModelData:(OaListModel *)model urlName:(NSString *)url{
    NSString *content;

    if ([url isEqualToString:AgetSignHYTZ]) {
        content = [NSString stringWithFormat:@"%@",model.TaskName];
    }else{
        content = [NSString stringWithFormat:@"(%@)%@",model.WfName,model.TaskName];
    }
    [_titleLabel setText:[NSString stringWithFormat:@"%@(%@)",model.User,model.ReceiveTime]];
    [_contentLabel setText:content];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
