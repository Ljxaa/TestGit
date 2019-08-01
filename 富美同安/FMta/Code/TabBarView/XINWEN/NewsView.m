//
//  NewsView.m
//  同安政务
//
//  Created by _ADY on 15/12/25.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "NewsView.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
@implementation NewsView
@synthesize delegate;

#define imageTag 10000
#define imTag 1000
#define howTime 3
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = bgColor;
        aframe = frame;
        taScrollView = [[UIScrollView alloc] initWithFrame:frame];
        [taScrollView setDelegate:self];
        [taScrollView setPagingEnabled:YES];
        [taScrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:taScrollView];
        
    }
    return self;
}

-(void)setDic:(NSMutableArray*)dicArray
{
    dicCount = (int)dicArray.count;
    if (dicCount > 5) {
        dicCount = 5;
    }
    [taScrollView setContentSize:CGSizeMake(aframe.size.width*dicCount,aframe.size.height)];
    if (ADeTimer != nil) {
        [ADeTimer invalidate];
        ADeTimer = nil;
    }
    ADeTimer = [NSTimer scheduledTimerWithTimeInterval:howTime target:self selector:@selector(handleMaxShoweTimer:) userInfo:nil repeats:YES];

    for (int i = 0; i < dicCount; i ++)
    {
        NSMutableDictionary *dictionary = [dicArray objectAtIndex:i];
        UIImageView *bgImageView = (UIImageView*)[self viewWithTag:imTag+i];
        UILabel *titleLabel;
        if (bgImageView == nil)
        {
            bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(aframe.size.width*i,0, aframe.size.width, aframe.size.height)];
            bgImageView.image = [UIImage imageNamed:@"no-imgage1.jpg"];
            bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
            bgImageView.clipsToBounds  = YES;
            bgImageView.tag = imTag+i;
            [taScrollView addSubview:bgImageView];
            
            int  titleHight = 30;
            titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aframe.size.height-titleHight, aframe.size.width, titleHight)];
            titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+2];
            titleLabel.textAlignment = 0;
            titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
            titleLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
            titleLabel.textColor = [UIColor whiteColor];
            [bgImageView addSubview:titleLabel];
            
            UIButton *inButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [inButton setFrame:bgImageView.frame];
            inButton.tag = imageTag+i;
            [inButton addTarget:self action:@selector(getTag:) forControlEvents:UIControlEventTouchUpInside];
            [taScrollView addSubview:inButton];
        }

        NSString *strUrl = dictionary[@"Entity"] ?(dictionary[@"Entity"]):(dictionary[@"VideoThumnAdd"]);
        if ([strUrl hash] && (id)strUrl != [NSNull null])
            [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,strUrl]] placeholderImage:[UIImage imageNamed:@"no-imgage1.jpg"]];


        titleLabel.text = [NSString stringWithFormat:@"%d/%d %@",i+1,dicCount,[dictionary objectForKey:@"Title"]];
    }
}

-(void)getTag:(UIButton*)aTag
{
    [delegate inAction:(int)aTag.tag-imageTag];
}

-(void)handleMaxShoweTimer:(NSTimer *)theTimer
{
    if (taScrollView != nil)
    {
        
        if (eTimerNum > dicCount-1) {
            eTimerNum = 0;
        }
        else
            eTimerNum++;
        [taScrollView scrollRectToVisible:CGRectMake(aframe.size.width*eTimerNum,0, aframe.size.width, aframe.size.height) animated:YES];
    }
    else
    {
        eTimerNum = 0;
        [theTimer invalidate];
        theTimer = nil;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page =scrollView.bounds.origin.x/aframe.size.width;
    if (scrollView == taScrollView)
    {
        eTimerNum = page;
    }
}

-(void)dealloc
{
    if (ADeTimer != nil) {
        [ADeTimer invalidate];
        ADeTimer = nil;
    }
    taScrollView = nil;
}

@end
