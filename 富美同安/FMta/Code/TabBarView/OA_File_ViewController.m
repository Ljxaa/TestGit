//
//  OA_File_ViewController.m
//  同安政务
//
//  Created by wx_air on 16/5/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OA_File_ViewController.h"

@interface OA_File_ViewController ()

@end

@implementation OA_File_ViewController
@synthesize fileUrl;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    //        webView.delegate = self;
    webView.multipleTouchEnabled = YES;
    webView.scalesPageToFit = YES;
    //        [webView loadData:resData MIMEType:@"application/doc" textEncodingName:@"UTF-8" baseURL:nil];
    NSURLRequest *requestrul =[NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    [webView loadRequest:requestrul];
    //
    //        NSURL *url = [NSURL fileURLWithPath:fileUrl];
    //        NSURLRequest *request222 = [NSURLRequest requestWithURL:url];
    //        [webView loadRequest:request222];
    //
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
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
