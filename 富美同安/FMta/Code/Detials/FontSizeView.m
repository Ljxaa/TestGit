//
//  FontSizeView.m
//  同安政务
//
//  Created by _ADY on 16/1/19.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "FontSizeView.h"
#import "ToolCache.h"
#import "Global.h"

@implementation FontSizeView
@synthesize delegate;
#define fArray [[NSArray alloc] initWithObjects:@"大",@"中",@"小",nil]

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:tabBarView];
        
        UILabel *tLabel = [[UILabel alloc] init];
        tLabel.text = @"字体:";
        tLabel.font = [UIFont fontWithName:@"Arail" size:labelSize-2];
        tLabel.frame = CGRectMake(0, 0, frame.size.width/3, frame.size.height);
        [tabBarView addSubview:tLabel];
        
        int lSize = [[ToolCache userKey:kFontSize] intValue];
        
        for (int i = 1; i < 4; i++)
        {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setFrame:CGRectMake(frame.size.width/3+(frame.size.width*2/3)*(i-1)/3, 0, frame.size.width/4, frame.size.height)];
            [button1 addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
            [button1 setTitle:[fArray objectAtIndex:i-1] forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont fontWithName:@"Arail" size:labelSize-2];
            button1.tag = i;
            if (lSize == [[fontArray objectAtIndex:3-i] intValue])
            {
                [button1 setTitleColor:[UIColor colorWithRed:52/255.0 green:114/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
                button1.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize-2];
            }
            [tabBarView addSubview:button1];
        }
    }
    return self;
}

-(void)collection:(id)sender
{
    int type = (int)((UIButton*)sender).tag;
    for (int i = 1; i < 4; i++)
    {
        UIButton *bBut = (UIButton*)[self viewWithTag:i];
        if (type == i) {
            [bBut setTitleColor:[UIColor colorWithRed:52/255.0 green:114/255.0 blue:217/255.0 alpha:1] forState:UIControlStateNormal];
            bBut.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize-2];
            [ToolCache setUserStr:[fontArray objectAtIndex:3-i] forKey:kFontSize];
        }
        else
        {
            [bBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            bBut.titleLabel.font = [UIFont fontWithName:@"Arail" size:labelSize-2];
        }
    }
    [delegate getFontSize];
}

@end
