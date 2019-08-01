//
//  OADetailViewController.m
//  同安政务
//
//  Created by wx_air on 16/5/15.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OADetailViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "RequestSerive.h"
#import "UIView+FrameMethods.h"
#import "OA_File_ViewController.h"

#import <QuickLook/QuickLook.h>

#define kTempUrlAft @"/oa/upload/temp/"

#define fontSize 14

@interface OADetailViewController ()<RSeriveDelegate,QLPreviewControllerDelegate,QLPreviewControllerDataSource>{
    RequestSerive *request;
    NSDictionary *self_dic;
    
    NSString *fileUrl;
}

@end

@implementation OADetailViewController
@synthesize listArray,num,hyId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:bgColor];
    self.title = @"会议管理详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    request = [[RequestSerive alloc]init];
    [request setDelegate:self];
    [self pushData];
}
- (void)pushData{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:hyId forKey:@"id"];
    
    [request PostFromURL:AgetHYTZDetail params:dic mHttp:httpUrl isLoading:YES];
}
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if (dic == nil) {
        kAlertShow(@"发生错误，请重试。");
        if ([urlName isEqualToString:AgetHYTZDetail]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        return;
    }
    if ([urlName isEqualToString:AgetHYTZDetail]) {
        NSLog(@"会议详情：%@",dic);
        self_dic = dic[@"NewDataSet"][@"Table"];
        [self setData:self_dic];
    }
}
- (void)setData:(NSDictionary *)dic{
    NSArray *titleArr = @[@"标题:",@"开会日期:",@"紧急程度:",@"发文单位:",@"发件人:",@"会议地点:",@"是否反馈:",@"反馈时限:",@"来文日期:",@"收文单位:",@"备注:"];
    NSArray *keyArr = @[@"MettingTitle",@"MettingTime",@"Urgency",@"SendDept",@"SendUserName",@"MettingAddress",@"IsNeedReback",@"RebackDays",@"SendDate",@"ReceiveDeptName",@"Remark"];
    
    UIScrollView *srol1 = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 5, screenMySize.size.width-10, screenMySize.size.height-10-64)];
    [srol1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:srol1];
    
    UIView *bodyView1 = [[UIView alloc]initWithFrame:CGRectMake(5, 5, srol1.frame.size.width-10, 0)];
    [bodyView1 setBackgroundColor:[UIColor whiteColor]];
    [bodyView1.layer setCornerRadius:8.0];
    [srol1 addSubview:bodyView1];
    UIView *view1;

    for (int i=0; i< titleArr.count; i++) {
        view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view1.frame), bodyView1.frame.size.width, 40)];
        
        UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, view1.frame.size.height)];
        [labelOne setNumberOfLines:0];
        [labelOne setFont:[UIFont systemFontOfSize:fontSize]];
        [labelOne setTextAlignment:NSTextAlignmentRight];
        [labelOne setText:[titleArr objectAtIndex:i]];
        [labelOne setTextColor:grayFontColor];
        //        [labelOne setText:@"集装箱号/车牌号/铅封号"];
        [view1 addSubview:labelOne];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelOne.frame)+4, 0, 1, view1.frame.size.height)];
        [line2 setBackgroundColor:bgColor];
        [view1 addSubview:line2];
        
        NSString *labelTwoStr = dic[[keyArr objectAtIndex:i]][@"text"];
//        float labelSize = [self getLabelHeight];
        float labelHeight = [self getLabelHeight:labelTwoStr FontSize:fontSize LabelWidth:view1.frame.size.width-20-labelOne.frame.size.width];
        if (labelHeight < labelOne.frame.size.height) {
            labelHeight = labelOne.frame.size.height;
        }else{
            [line2 setHeight:labelHeight];
            [view1 setHeight:labelHeight];
        }
        UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame)+5, 0, view1.frame.size.width-20-labelOne.frame.size.width, labelHeight)];
        [labelTwo setNumberOfLines:0];
        [labelTwo setFont:[UIFont systemFontOfSize:fontSize]];
        //        [labelTwo setTextAlignment:NSTextAlignmentCenter];
        
//        [labelTwo setTextColor:[UIColor grayColor]];
        
        if ([labelOne.text isEqualToString:@"是否反馈:"]) {
            if ([labelTwoStr intValue] == 1) {
                labelTwoStr = @"是";
            }else{
                labelTwoStr = @"否";
            }
        }
        [labelTwo setText:labelTwoStr];
        [view1 addSubview:labelTwo];
        
        if (i!=0) {
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, srol1.frame.size.width, 1)];
            [line setBackgroundColor:bgColor];
            [view1 addSubview:line];
        }
        
        [bodyView1 addSubview:view1];
    }
    [bodyView1 setHeight:CGRectGetMaxY(view1.frame)];
    [srol1 setContentSize:CGSizeMake(srol1.frame.size.width, CGRectGetMaxY(bodyView1.frame))];
    
//    if (CGRectGetMaxY(view1.frame) < srol1.frame.size.height) {
//        CGRect frame = srol1.frame;
//        frame.size.height = CGRectGetMaxY(view1.frame);
//        [srol1 setFrame:frame];
//    }else{
//        
//    }
    
    NSString *fileStr = dic[@"AttachName"][@"text"];
    if (fileStr != nil) {
        UIView *bodyView2 = [[UIView alloc]initWithFrame:CGRectMake(5, 5 + CGRectGetMaxY(bodyView1.frame), bodyView1.frame.size.width, 0)];
        [bodyView2 setBackgroundColor:bodyView1.backgroundColor];
        [bodyView2.layer setCornerRadius:bodyView1.layer.cornerRadius];
        [srol1 addSubview:bodyView2];
        
        NSArray *fileArr = [fileStr componentsSeparatedByString:@","];
        UIView *view2;
        for (int i = 0; i<fileArr.count; i++) {
            NSString *str = [fileArr objectAtIndex:i];
            view2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view2.frame), srol1.frame.size.width, 40)];
            
            float labelHeight = [self getLabelHeight:str FontSize:fontSize LabelWidth:view2.frame.size.width-90];
            if (labelHeight < view2.frame.size.height) {
                labelHeight = view2.frame.size.height;
            }else{
                [view2 setHeight:labelHeight];
            }
            UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, view2.frame.size.width-90, labelHeight)];
            [labelOne setNumberOfLines:0];
            [labelOne setFont:[UIFont systemFontOfSize:fontSize]];
            [labelOne setText:str];
            [view2 addSubview:labelOne];
            
            UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(view2.frame.size.width-70, 0, 50, 30)];
            [btn2 setTag:1000+i];
            [btn2.layer setCornerRadius:4.0];
            [btn2 setClipsToBounds:YES];
            [btn2 setTitle:@"查看" forState:0];
            [btn2.titleLabel setFont:[UIFont systemFontOfSize:fontSize+1]];
            [btn2 setTitleColor:[UIColor whiteColor] forState:0];
            [btn2 setTitleColor:blueFontColor forState:UIControlStateHighlighted];
            [btn2 setBackgroundImage:[ToolCache createImageWithColor:blueFontColor] forState:0];
            [btn2 setBackgroundImage:[ToolCache createImageWithColor:lineColor] forState:UIControlStateHighlighted];
            [btn2 setCenter:CGPointMake(btn2.center.x, labelOne.center.y)];
            [btn2 addTarget:self action:@selector(showFile:) forControlEvents:UIControlEventTouchUpInside];
            [view2 addSubview:btn2];
            
            [bodyView2 addSubview:view2];
        }
        [bodyView2 setHeight:CGRectGetMaxY(view2.frame)];
        [srol1 setContentSize:CGSizeMake(srol1.frame.size.width, CGRectGetMaxY(bodyView2.frame))];
    }
}

- (float)getLabelHeight:(NSString*)str FontSize:(int)fSize LabelWidth:(int)lWidth
{
    if ([[NSString stringWithFormat:@"%@",str] isEqualToString:@"<null>"]) {
        return 0;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize totalTextSize = [str boundingRectWithSize:CGSizeMake(lWidth,CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
//    NSLog(@"aTypeaTypeaType:%@,%f",str,totalTextSize.height+10);
    return totalTextSize.height+20;
}
- (void)showFile:(UIButton *)btn{
    NSString *fileStr = self_dic[@"AttachId"][@"text"];
    NSArray *fileArr = [fileStr componentsSeparatedByString:@","];
    NSString *urlString = [NSString stringWithFormat:@"http://222.76.243.119:8088%@%@", kTempUrlAft, [fileArr objectAtIndex:btn.tag - 1000]];
    OA_File_ViewController *pushView = [[OA_File_ViewController alloc]init];
    pushView.fileUrl = urlString;
    pushView.title = @"附件";
    [self.navigationController pushViewController:pushView animated:YES];
    
//    return;
    
#if 0
    //暂留
    NSString *fileStr = self_dic[@"AttachId"][@"text"];
    NSArray *fileArr = [fileStr componentsSeparatedByString:@","];

    NSString *urlString = [NSString stringWithFormat:@"%@%@", kTempUrlAft, [fileArr objectAtIndex:btn.tag - 1000]];
    fileStr = [fileStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"附件链接：%@ ",urlString);
    
    [request GetFromOA_File_URL:urlString params:nil mHttp:@"222.76.243.119:8088" isLoading:NO];
    
#endif
//    PreviewDataSource *dataSource = [[[PreviewDataSource alloc]init] autorelease];
//    dataSource.path=[[NSString alloc] initWithString:appFile];
//    previewoCntroller.dataSource=dataSource;
//    [app.nav pushViewController: previewoCntroller animated:YES];
//    [previewoCntroller setTitle:fileName];
//    previewoCntroller.navigationItem.rightBarButtonItem=nil;
//    if (my_wifi)
//    {
//        [self AttachInt];
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未连接WIFI网络,确定查看？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        alert.tag = 100;
//        [alert show];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
