//
//  TabDetialsView.m
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "TabDetialsView.h"
#import "DetialsItem.h"
#import "RequestSerive.h"

@implementation TabDetialsView
@synthesize delegate,dic;

#define iamgeSize 30
#define jiangeWith 20
#define scTag 4//收藏
- (id)initWithFrame:(CGRect)frame styleBool:(BOOL)gBool
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 49)];
        tabBarView.layer.shadowColor= [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
        tabBarView.layer.shadowOffset=CGSizeMake(2,3);
        tabBarView.layer.shadowOpacity=0.5;
        tabBarView.layer.shadowRadius=3.0;
        tabBarView.backgroundColor = [UIColor whiteColor];
        [self addSubview:tabBarView];
        
        //收藏
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setFrame:CGRectMake(frame.size.width-iamgeSize-jiangeWith, (49-iamgeSize)/2, iamgeSize, iamgeSize)];
        [button1 addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = scTag;
        [tabBarView addSubview:button1];
        [button1 setImage:[UIImage imageNamed:@"image_collect1"] forState:UIControlStateNormal];

        if (gBool)
        {
            NSArray *arrayImage = [NSArray arrayWithObjects:@"left",@"right",@"lb", nil];
            for (int i = 1; i < 4; i ++)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:CGRectMake(jiangeWith+(i-1)*(iamgeSize+jiangeWith), (49-iamgeSize)/2, iamgeSize, iamgeSize)];
                [button addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [tabBarView addSubview:button];
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrayImage objectAtIndex:i-1]]] forState:UIControlStateNormal];
            }
        }
        
    }
    return self;
}

-(void)setDetialsViewDic:(NSMutableDictionary *)aSdic
{
    self.dic = aSdic;
    [self setSC:NO setButton:nil];
}

-(void)setSC:(BOOL)aBool setButton:(UIButton*)aTag
{
    if (aTag == nil) {
        aTag = (UIButton*)[self viewWithTag:scTag];
    }
    NSMutableDictionary *scArray = [[NSMutableDictionary alloc]init];
    if ([DetialsItem unarchiveWithKey:@"DetialsSC"] != nil)
    {
        scArray = [DetialsItem unarchiveWithKey:@"DetialsSC"];
    }
    for (int i = 0; i < scArray.count; i++)
    {
        if ([scArray[[NSString stringWithFormat:@"%d",i]][@"Title"] isEqualToString:self.dic[@"Title"]]&&[[NSString stringWithFormat:@"%@",scArray[[NSString stringWithFormat:@"%d",i]][@"RowID"]] isEqualToString:[NSString stringWithFormat:@"%@",self.dic[@"RowID"]]])
        {
            if (aBool)
            {
                for (int j = i; j< scArray.count-1; j++)
                {
                    [scArray setObject:[scArray objectForKey:[NSString stringWithFormat:@"%d",j+1]] forKey:[NSString stringWithFormat:@"%d",j]];
                }
                [scArray removeObjectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-1]];
                [scArray archiveWithKey:@"DetialsSC"];
                [aTag setImage:[UIImage imageNamed:@"image_collect1"] forState:UIControlStateNormal];
                [RequestSerive alerViewMessage:@"取消收藏!"];
                return;
            }
            else
            {
                [aTag setImage:[UIImage imageNamed:@"image_collect2"] forState:UIControlStateNormal];
                return;
            }

        }
    }
    if (aBool)
    {
        [RequestSerive alerViewMessage:@"收藏成功!"];
        
        NSDate *  senddate=[NSDate date];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        
        NSMutableDictionary *myDic = [[NSMutableDictionary alloc] init];
        [myDic setDictionary:self.dic];
        [myDic setObject:locationString forKey:@"myNowTime"];
        
        [aTag setImage:[UIImage imageNamed:@"image_collect2"] forState:UIControlStateNormal];
        [scArray setObject:myDic forKey:[NSString stringWithFormat:@"%ld",(unsigned long)scArray.count]];
        [scArray archiveWithKey:@"DetialsSC"];
    }

}

-(void)collection:(UIButton*)aTag
{
    if (aTag.tag == scTag)
    {
        [self setSC:YES setButton:aTag];
    }
    else
        [delegate getTag:aTag.tag];
}

@end
