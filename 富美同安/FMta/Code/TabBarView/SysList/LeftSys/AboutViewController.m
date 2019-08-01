//
//  AboutViewController.m
//  XMGW_MIPlatform
//
//  Created by _ADY on 14-11-10.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "AboutViewController.h"
#import "Global.h"
#import "MapViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];//ic_launcher
    
//    UIImageView *myImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"12"]];
//    [myImage setFrame:CGRectMake(0, 0, 140, 140)];
//    myImage.center = CGPointMake(screenMySize.size.width/2, screenMySize.size.height/2-150);
//    [self.view addSubview:myImage];
//    
//    UILabel *tLabel = [[UILabel alloc] init];
//    tLabel.text = @"同安政务";
//    tLabel.frame = CGRectMake(0, myImage.frame.origin.y+140, screenMySize.size.width, 40) ;
//    tLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
//    tLabel.textAlignment = NSTextAlignmentCenter;
//    tLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:tLabel];
//    
//    UILabel *mLabel = [[UILabel alloc] init];
//    mLabel.text = [NSString stringWithFormat:@"客户端 V%@",Version];
//    mLabel.frame = CGRectMake(0, tLabel.frame.origin.y+40, screenMySize.size.width, 20) ;
//    mLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
//    mLabel.textAlignment = NSTextAlignmentCenter;
//    mLabel.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:mLabel];
    
    
//    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelTitle.frame), labelTitle.frame.origin.y, 130, labelTitle.frame.size.height)];
//    [btn1 setTitle:@"点击查看操作说明" forState:0];
//    [btn1 addTarget:self action:@selector(touchShuoMing) forControlEvents:UIControlEventTouchUpInside];
//    [btn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    [btn1 setTitleColor:[UIColor blueColor] forState:0];
//    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [self.view addSubview:btn1];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [self.view addSubview:scrollView];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, scrollView.frame.size.width-20, 40)];
    [labelTitle setText:@"同安政务信息平台"];
    [labelTitle setFont:[UIFont systemFontOfSize:21]];
    [labelTitle setTextColor:[UIColor grayColor]];
    [scrollView addSubview:labelTitle];
    
    NSArray *imgArr = @[[UIImage imageNamed:@"安卓手机"],[UIImage imageNamed:@"安卓pad"],[UIImage imageNamed:@"苹果"]];
    NSArray *titleArr = @[@"安卓手机客户端",@"安卓平板客户端",@"iOS客户端"];
    
    UILabel *TopLbl;
    UIImageView *imgView;
    for (int i = 0; i < titleArr.count; i ++) {
        TopLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(labelTitle.frame)+CGRectGetMaxY(imgView.frame), scrollView.frame.size.width-20, 30)];
        [TopLbl setText:titleArr[i]];
        [scrollView addSubview:TopLbl];
        
        imgView = [[UIImageView alloc]initWithImage:imgArr[i]];
        imgView.frame = CGRectMake(TopLbl.frame.origin.x, CGRectGetMaxY(TopLbl.frame), TopLbl.frame.size.width, TopLbl.frame.size.width);
        [scrollView addSubview:imgView];
        
//        //二维码底层视图
//        float originX = (i%2) * scrollView.frame.size.width/2;
//        int tmpY = i/2;
//        float originY = tmpY * (scrollView.frame.size.height-64)/2;
//        UILabel *bottomLbl = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, scrollView.frame.size.width/2, (scrollView.frame.size.height-64)/2)];
//        [scrollView addSubview:bottomLbl];
//        
//        UIImageView *imgView = [[UIImageView alloc]initWithImage:imgArr[i]];
//        imgView.frame = CGRectMake(scrollView.frame.size.width/3/4, 50, scrollView.frame.size.width/3, scrollView.frame.size.width/3);
//        [bottomLbl addSubview:imgView];
//        
//        UILabel *titleLbl = [[UILabel alloc]init];
//        titleLbl.textAlignment = NSTextAlignmentCenter;
//        titleLbl.text = titleArr[i];
//        titleLbl.frame = CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height+20, bottomLbl.frame.size.width, bottomLbl.frame.size.height/4);
//        [bottomLbl addSubview:titleLbl];
//        
//        if (i == titleArr.count-1 && (i+1)/2 /*最后一个二维码 且是基数 将视图置中*/)
//        {
//            bottomLbl.center = CGPointMake(scrollView.frame.size.width/2, bottomLbl.center.y);
//        }
        
    }
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, CGRectGetMaxY(imgView.frame))];
}
//说明点击
- (void)touchShuoMing{
    MapViewController *pushView = [[MapViewController alloc]init];
    [pushView setHidesBottomBarWhenPushed:YES];
    pushView.title = @"操作说明";
    pushView.type = @"web";
    pushView.url = caozuoUrl;
    [self.navigationController pushViewController:pushView animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
