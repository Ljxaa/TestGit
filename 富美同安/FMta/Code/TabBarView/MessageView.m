//
//  ChildHomeView.m
//  同安政务
//
//  Created by wx_air on 16/4/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "MessageView.h"
#import "ChildDataModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+CustomBadge.h"
#import "ToolCache.h"

@implementation MessageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0]];
        [self.layer setCornerRadius:10.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.layer setBorderWidth:1.5];
        [self setClipsToBounds:YES];
        
        //        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        //        [img setImage:[UIImage imageNamed:@"bg.png"]];
        //        [self addSubview:img];
        bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_logo_bg"]];
        [bgImage setBackgroundColor:[UIColor whiteColor]];
//        bgImage.frame = self.frame;
        [bgImage setFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        [self addSubview:bgImage];
    }
    return self;
}
- (void)setListData:(NSDictionary *)dic{
//    NSLog(@"number:::%@\n====%@",numberDic,keyArr);
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
    [labelTitle setText:@"通知"];
//    [labelTitle setBackgroundColor:[UIColor blueColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:19]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [self addSubview:labelTitle];
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelTitle.frame)-40, labelTitle.frame.origin.y + 10, 20, 20)];
    [closeButton setTag:101];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [closeButton addTarget:self action:@selector(touchZhiDaoLe:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    //知道了按钮
    UIButton *knowButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    [knowButton setTag:100];
    [knowButton setTitle:@"知道了" forState:UIControlStateNormal];
    [knowButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:0];
    [knowButton setTitleColor:[UIColor colorWithRed:18/255.f green:112/255.f blue:255/255.f alpha:1.0] forState:UIControlStateNormal];
    [knowButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [knowButton addTarget:self action:@selector(touchZhiDaoLe:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:knowButton];
    //通知内容
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(-1, CGRectGetMaxY(labelTitle.frame), self.frame.size.width+2, knowButton.frame.origin.y-CGRectGetMaxY(labelTitle.frame))];
    [webView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [webView.layer setBorderWidth:1];
    [webView loadHTMLString:dic[@"Content"] baseURL:nil];
    [self addSubview:webView];
    
}

- (void)setShiwStrData:(NSString *)str{
    //    NSLog(@"number:::%@\n====%@",numberDic,keyArr);
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
//    [labelTitle setText:@""];
    //    [labelTitle setBackgroundColor:[UIColor blueColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [labelTitle setFont:[UIFont boldSystemFontOfSize:19]];
    [labelTitle setTextColor:[UIColor whiteColor]];
    [self addSubview:labelTitle];
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelTitle.frame)-40, labelTitle.frame.origin.y + 10, 20, 20)];
    [closeButton setTag:101];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [closeButton addTarget:self action:@selector(touchZhiDaoLe:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    //知道了按钮
    UIButton *knowButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
    [knowButton setTag:100];
    [knowButton setTitle:@"关闭" forState:UIControlStateNormal];
    [knowButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:0];
    [knowButton setTitleColor:[UIColor colorWithRed:18/255.f green:112/255.f blue:255/255.f alpha:1.0] forState:UIControlStateNormal];
    [knowButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [knowButton addTarget:self action:@selector(touchZhiDaoLe:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:knowButton];
    //通知内容
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(-1, CGRectGetMaxY(labelTitle.frame), self.frame.size.width+2, knowButton.frame.origin.y-CGRectGetMaxY(labelTitle.frame))];
    [webView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [webView.layer setBorderWidth:1];
    [webView loadHTMLString:str baseURL:nil];
    [self addSubview:webView];
    
}
-(void)touchZhiDaoLe:(UIButton *)btn{
    if (btn.tag == 100) {
        [delegate touchZhiDaoLe:YES];
    }else{
        [delegate touchZhiDaoLe:NO];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
