//
//  FullCutTableViewCell.m
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "FullCutTableViewCell.h"
#import "Global.h"
#import "ToolCache.h"
#import "UIImageView+WebCache.h"
@interface FullCutTableViewCell ()
@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UILabel *name1Label;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, retain)UILabel *name2Label;
@property (nonatomic, retain)UIImageView *line1ImageView;
@end

@implementation FullCutTableViewCell
#define sizeHight screenMySize.size.width*.2
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
#if 0
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,5, sizeHight*75/55,sizeHight)];
        _bgImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_bgImageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width, _bgImageView.frame.origin.y, screenMySize.size.width-_bgImageView.frame.origin.x-_bgImageView.frame.size.width-10, sizeHight/4-5)];
        _titleLabel.textAlignment = 0;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width, _bgImageView.frame.origin.y+sizeHight/4-5, screenMySize.size.width-_bgImageView.frame.origin.x-_bgImageView.frame.size.width-10, sizeHight/2+5)];
        _nameLabel.textAlignment = 0;
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-1];
        _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+_bgImageView.frame.size.width, _bgImageView.frame.origin.y+sizeHight*3/4+5, screenMySize.size.width-_bgImageView.frame.origin.x-_bgImageView.frame.size.width-10, sizeHight/4-5)];
        _timeLabel.textAlignment = 0;
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-3];
        _timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeLabel];

        _line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [_line1ImageView setFrame:CGRectMake(10, sizeHight+10-2, screenMySize.size.width-20, 2)];
        [self.contentView addSubview:_line1ImageView];
    }
    return self;
}

- (void)setEntity:(FullCutModel *)entity
{
     if ([entity.title hash] && (id)entity.title != [NSNull null])
         _titleLabel.text = entity.title;
    if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
        _nameLabel.text = entity.SumnaryString;
    
    if ([entity.nameString hash] && (id)entity.nameString != [NSNull null]&&[entity.nameString hash] && (id)entity.nameString != [NSNull null])
        _timeLabel.text = [NSString stringWithFormat:@"%@ %@",entity.nameString,entity.CreateTime];
    else if ([entity.CreateTime hash] && (id)entity.CreateTime != [NSNull null])
        _timeLabel.text = [NSString stringWithFormat:@"%@",entity.CreateTime];
    else if ([entity.nameString hash] && (id)entity.nameString != [NSNull null])
        _timeLabel.text = [NSString stringWithFormat:@"%@",entity.nameString];
    
    if ([entity.bgImage hash] && (id)entity.bgImage != [NSNull null])
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.bgImage]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
}
#endif




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        if (scrollPanel == nil) {
            
            scrollPanel = [[UIView alloc] initWithFrame:screenMySize];
            scrollPanel.backgroundColor = [UIColor clearColor];
            scrollPanel.alpha = 0;
            [[UIApplication sharedApplication].keyWindow addSubview:scrollPanel];
            
            markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
            markView.backgroundColor = [UIColor blackColor];
            markView.alpha = 0.0;
            [scrollPanel addSubview:markView];
            
            myScrollView = [[UIScrollView alloc] initWithFrame:screenMySize];
            [scrollPanel addSubview:myScrollView];
            myScrollView.pagingEnabled = YES;
            myScrollView.delegate = self;
        }
        
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(agsize,agsize, txImageSize,txImageSize)];
        _bgImageView.contentMode =  UIViewContentModeScaleAspectFit;
        _bgImageView.image = [UIImage imageNamed:@"tx_tx"];
        [self.contentView addSubview:_bgImageView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+txImageSize+agsize, _bgImageView.frame.origin.y, 150, titleHight)];
        _nameLabel.textAlignment = 0;
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _nameLabel.textColor = [UIColor blueColor];
        [self.contentView addSubview:_nameLabel];
        
        _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width, _nameLabel.frame.origin.y, screenMySize.size.width-(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+agsize), titleHight)];
        _name1Label.textAlignment = 2;
        _name1Label.font = [UIFont fontWithName:@"Arial" size:labelSize-1];
        _name1Label.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name1Label];
    
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+titleHight, screenMySize.size.width-_nameLabel.frame.origin.x, titleH)];
        _titleLabel.textAlignment = 0;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _titleLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self.contentView addSubview:_titleLabel];
        
        _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x-agsize, detialInt)];
        _name2Label.textAlignment = 0;
        _name2Label.numberOfLines = 0;
        _name2Label.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        _name2Label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self.contentView addSubview:_name2Label];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH+detialInt, screenMySize.size.width-_titleLabel.frame.origin.x, timeHight)];
        _timeLabel.textAlignment = 0;
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-3];
        _timeLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_timeLabel];
        
        _line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [_line1ImageView setFrame:CGRectMake(agsize, _timeLabel.frame.origin.y+_timeLabel.frame.size.height, screenMySize.size.width-2*agsize, 2)];
        [self.contentView addSubview:_line1ImageView];
    }
    return self;
}

- (void)setEntity:(FullCutModel *)entity withHigth:(int)aAhight
{
    
    if ([entity.title hash] && (id)entity.title != [NSNull null])
        _titleLabel.text = entity.title;

    if ([entity.CreateTime hash] && (id)entity.CreateTime != [NSNull null])
        _timeLabel.text = [NSString stringWithFormat:@"%@",entity.CreateTime];
    if ([entity.nameString hash] && (id)entity.nameString != [NSNull null])
        _nameLabel.text = [NSString stringWithFormat:@"%@",entity.nameString];

    _name1Label.text = @"党委办";
//    _name1Label.text = [ToolCache userTitle];
     if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
     {
//        detialInt = [ToolCache setString:entity.SumnaryString setSize:labelSize-2 setWight:_name2Label.frame.size.width];
         _name2Label.text = entity.SumnaryString;
     }
    else
    {
//        detialInt = 0;
        _name2Label.text = @"";
    }
    detialInt = aAhight;
    _name2Label.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x, detialInt);
    
    if ([entity.bgImage hash] && (id)entity.bgImage != [NSNull null])
        [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.bgImage]]];
    
     NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
    int contAr = (int)imageUrlArray.count;
    if (contAr >= 9) {
        contAr = 9;
    }

    int hight = 0;
    for (int i = 0 ; i < contAr; i ++)
    {

        CGRect frame = CGRectMake(10+txImageSize+(imageSize+10)*(i%3), _name2Label.frame.size.height+_name2Label.frame.origin.y+i/3*(imageSize+10), imageSize, imageSize);
        
        TapImageView *tmpView = (TapImageView*)[self viewWithTag:10000+i];
        if (tmpView == nil) {
             tmpView = [[TapImageView alloc] initWithFrame:frame];
            tmpView.t_delegate = self;
            tmpView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
            tmpView.tag = 10000 + i;
            
            [self.contentView addSubview:tmpView];
        }
        else
            [tmpView setFrame:frame];

        
//        objc_setAssociatedObject(bgButton, "firstObject", imageUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//        objc_setAssociatedObject(bgButton, "secondObject", imageUrlArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [tmpView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]]]];

        
       
        
        if ((float)contAr/3 <= i+1 && (float)contAr/3>i) {
            hight = i+1;
        }
        
    }
    for (int i = contAr; i  < 9; i ++) {
        TapImageView *imageView = (TapImageView*)[self viewWithTag:10000+i];
        if (imageView) {
            [imageView removeFromSuperview];
            imageView = nil;
        }
    }

    _timeLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10), screenMySize.size.width-_titleLabel.frame.origin.x, timeHight);
    
    _line1ImageView.frame = CGRectMake(agsize, _timeLabel.frame.origin.y+_timeLabel.frame.size.height, screenMySize.size.width-2*agsize, 2);

}

#pragma mark - 长按事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
//        CGPoint point = [gesture locationInView:mTableView];
//        NSIndexPath * indexPath = [mTableView indexPathForRowAtPoint:point];
//        if(indexPath == nil) return ;
//        
//        productId = [NSString stringWithFormat:@"%@",[[spArray objectAtIndex:indexPath.row] objectForKey:@"ProductId"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定取消关注?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }
}
#pragma mark -
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    [self bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    currentIndex = tmpView.tag - 10000;
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self];
    convertRect.origin.y =  convertRect.origin.y +64;
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*screenMySize.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image setUrl:nil];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 9; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag:10000 + i];
        
        if (tmpView == nil) {
            CGSize contentSize = myScrollView.contentSize;
            contentSize.height = screenMySize.size.height;
            contentSize.width = screenMySize.size.width * i;
            myScrollView.contentSize = contentSize;
            return;
        }

        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self];
        convertRect.origin.y =  convertRect.origin.y +64;
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image setUrl:nil];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
