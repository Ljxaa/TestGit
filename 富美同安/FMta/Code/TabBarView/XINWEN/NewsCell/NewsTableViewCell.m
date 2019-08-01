//
//  NewsTableViewCell.m
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "Global.h"
#import "UIImageView+WebCache.h"

#define imageSize (screenMySize.size.width-20)/3-10

@interface NewsTableViewCell ()
//@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)UILabel *titleLabel;
//@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UIImageView *line1ImageView;
@end

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box_yj"]];
        [_line1ImageView setFrame:CGRectMake(10, 5, screenMySize.size.width-20, sizeHight)];
        [self.contentView addSubview:_line1ImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screenMySize.size.width-30,20)];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        _titleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10+20, screenMySize.size.width-30, sizeHight-30)];
        _nameLabel.textAlignment = 0;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        


    }
    return self;
}

+(UITableViewCell*)setImageCell:(UITableViewCell *)cell data:(NewsModel *)entity
{
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5, sizeHight*75/55,sizeHight)];
    ImageView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
    ImageView.contentMode =  UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:ImageView];
    
    UILabel *eLabel = [[UILabel alloc] initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+10, ImageView.frame.origin.y, screenMySize.size.width-ImageView.frame.origin.x-ImageView.frame.size.width-20, sizeHight-15)];
    eLabel.textAlignment = 0;
    eLabel.numberOfLines = 0;
    eLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
    eLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:eLabel];
    
    UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(ImageView.frame.origin.x+ImageView.frame.size.width+10, ImageView.frame.origin.y+sizeHight-15, screenMySize.size.width-ImageView.frame.origin.x-ImageView.frame.size.width-20, 15)];
    Label.textAlignment = 0;
    Label.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    Label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [cell.contentView addSubview:Label];
    
    UIImageView *e1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [e1ImageView setFrame:CGRectMake(10, sizeHight+10-2, screenMySize.size.width-20, 2)];
    [cell.contentView addSubview:e1ImageView];
    
    if ([entity.title hash] && (id)entity.title != [NSNull null])
        eLabel.text = entity.title;
    if ([entity.time hash] && (id)entity.time != [NSNull null])
        Label.text = entity.time;
    
    if ([entity.bgImage hash] && (id)entity.bgImage != [NSNull null])
        [ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.bgImage]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
    
    return cell;
}

+(UITableViewCell*)setImageCell:(UITableViewCell *)cell data:(NewsModel *)entity forI:(int)iType
{
    UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(imageSize+12)*(iType%3),0, imageSize+5,sizeHight+10)];
    ImageView.contentMode =  UIViewContentModeScaleAspectFill;
    ImageView.clipsToBounds = YES;
    ImageView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
    [cell.contentView addSubview:ImageView];
    
    UILabel *eLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ImageView.frame.size.height-35, ImageView.frame.size.width, 35)];
    eLabel.textAlignment = 1;
    eLabel.numberOfLines = 2;
    eLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-3];
    eLabel.textColor = [UIColor whiteColor];
    eLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [ImageView addSubview:eLabel];
    
    if ([entity.title hash] && (id)entity.title != [NSNull null])
        eLabel.text = entity.title;
    
    if ([entity.bgImage hash] && (id)entity.bgImage != [NSNull null])
        [ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.bgImage]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
    
    if (iType == 2) {
        UIImageView *lImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [lImageView setFrame:CGRectMake(10, sizeHight+10-2, screenMySize.size.width-20, 2)];
        [cell.contentView addSubview:lImageView];
    }
    
    return cell;
}

- (void)setEntity:(NewsModel *)entity  setSource:(BOOL)isSource
{
    if ([entity.title hash] && (id)entity.title != [NSNull null])
        _nameLabel.text = entity.title;
    
    if (isSource) {
        NSString *timeStr = [entity.time substringToIndex:10];
        if ([entity.person hash] && (id)entity.person != [NSNull null])
            _titleLabel.text = [NSString stringWithFormat:@"来源:%@(%@)",entity.Source,timeStr];
    }
    else
    {
        if ([entity.person hash] && (id)entity.person != [NSNull null])
            _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",entity.person,entity.time];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
