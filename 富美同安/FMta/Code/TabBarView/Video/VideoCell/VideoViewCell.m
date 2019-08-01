//
//  VideoViewCell.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "VideoViewCell.h"
#import "Global.h"
#import "UIImageView+WebCache.h"

@interface VideoViewCell ()
@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UIImageView *videoImageView;
@property (nonatomic, retain)UIImageView *line1ImageView;
@end

@implementation VideoViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5, sizeHight*75/55,sizeHight)];
        _bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
        _bgImageView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
        [self.contentView addSubview:_bgImageView];
        
        _videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(sizeHight*75/55-30)/2,5+(sizeHight-30)/2, 30, 30)];
        [_videoImageView setImage:[UIImage imageNamed:@"video.png"]];
        [self.contentView addSubview:_videoImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width+10, _bgImageView.frame.origin.y, screenMySize.size.width-_bgImageView.frame.origin.x-_bgImageView.frame.size.width-20, sizeHight/4-5)];
        _titleLabel.textAlignment = 0;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width+10, _bgImageView.frame.origin.y+sizeHight/4-5, screenMySize.size.width-_bgImageView.frame.origin.x-_bgImageView.frame.size.width-20, sizeHight*3/4)];
        _nameLabel.textAlignment = 0;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self.contentView addSubview:_nameLabel];
        
        _line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [_line1ImageView setFrame:CGRectMake(10, sizeHight+10-2, screenMySize.size.width-20, 2)];
        [self.contentView addSubview:_line1ImageView];
    }
    return self;
}

- (void)setEntity:(VideoModel *)entity
{
    if ([entity.title hash] && (id)entity.title != [NSNull null])
        _titleLabel.text = entity.title;
    if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
        _nameLabel.text = entity.SumnaryString;
    
    if ([entity.bgImage hash] && (id)entity.bgImage != [NSNull null])
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.bgImage]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
}
@end
