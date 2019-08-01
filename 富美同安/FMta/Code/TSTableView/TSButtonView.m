//
//  TSButtonView.m
//  同安政务
//
//  Created by _ADY on 16/1/15.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "TSButtonView.h"
#import "Global.h"
#import "ToolCache.h"

#define aWith 80
@implementation TSButtonView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UILabel *_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height/8, aWith, frame.size.height/4)];
        _nameLabel.textAlignment = 0;
        _nameLabel.text = @"统计指标:";
        _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self addSubview:_nameLabel];
        
        UILabel *_name1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.size.height/2+10, aWith, frame.size.height/4)];
        _name1Label.textAlignment = 0;
        _name1Label.text = @"统计区间:";
        _name1Label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self addSubview:_name1Label];
        
        inButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect bframe = CGRectMake(20+aWith,frame.size.height/8-5, frame.size.width-(40+aWith), frame.size.height/4+10);
        [inButton setFrame:bframe];
        [inButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        inButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize];
        [inButton addTarget:self action:@selector(bInBction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inButton];
        [inButton.layer setBorderWidth:1];
        [inButton.layer setBorderColor:[UIColor grayColor].CGColor];
//        [inButton.layer setCornerRadius:5];
        UIImage *imageD = [UIImage imageNamed:@"list_arrow_bottom"];
        UIImageView *imageA = [[UIImageView alloc] initWithImage:imageD];
        [imageA setFrame:CGRectMake(frame.size.width-20-imageD.size.width,frame.size.height/8-10, imageD.size.height, imageD.size.width)];
        [self addSubview:imageA];
        
        
        NSString *aString = @"2016年1月至";
        int with = [ToolCache setString:aString setSize:labelSize setHight:frame.size.height/4];
        tLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+aWith, frame.size.height/2+10, with, frame.size.height/4)];
        tLabel.textAlignment = 0;
        tLabel.text = aString;
        tLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize];
        tLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self addSubview:tLabel];
        
        
        inButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect b1frame = CGRectMake(20+aWith+with,frame.size.height/2+5, frame.size.width-(40+aWith+with), frame.size.height/4+10);
        [inButton1 setFrame:b1frame];
        [inButton1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        inButton1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize];
        [inButton1 addTarget:self action:@selector(bIn1Bction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inButton1];
        [inButton1.layer setBorderWidth:1];
        [inButton1.layer setBorderColor:[UIColor grayColor].CGColor];
        
        UIImageView *image1A = [[UIImageView alloc] initWithImage:imageD];
        [image1A setFrame:CGRectMake(frame.size.width-20-imageD.size.width,frame.size.height/2-5+5, imageD.size.height, imageD.size.width)];
        [self addSubview:image1A];
        
    }
    return self;
}

-(void)setFirst:(NSArray*)fArray setSecond:(NSArray*)sArray
{
    firstArray = fArray;
    secondArray = sArray;
    [inButton setTitle:[fArray objectAtIndex:0] forState:UIControlStateNormal];
    [inButton1 setTitle:[sArray objectAtIndex:0] forState:UIControlStateNormal];
    fInt = sInt = 0;
    [self getGoTo];
}

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)//项目选择
    {
        if (buttonIndex >  firstArray.count ||buttonIndex < 0)
        {
            return;
        }
        [inButton setTitle:[firstArray objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        fInt = (int)buttonIndex;
        [self getGoTo];
    }
    if (actionSheet.tag == 101)//项目选择
    {
        if (buttonIndex >  secondArray.count ||buttonIndex < 0)
        {
            return;
        }

        [inButton1 setTitle:[secondArray objectAtIndex:buttonIndex] forState:UIControlStateNormal];
        sInt = (int)buttonIndex;
        [self getGoTo];
    }
}
-(void)bInBction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *adic in firstArray)
    {
        [actionSheet addButtonWithTitle:adic];
    }
    actionSheet.tag = 100;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self];

}

-(void)bIn1Bction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *adic in secondArray)
    {
        [actionSheet addButtonWithTitle:adic];
    }
    actionSheet.tag = 101;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self];

}

-(void)getGoTo
{
    [delegate setFiset:fInt setSecond:sInt];
}
@end
