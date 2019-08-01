//
//  FKViewController.m
//  港务移动信息
//
//  Created by _ADY on 14-11-14.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "FKViewController.h"
#import "Global.h"
#import "ToolCache.h"
#define mFkLabel @"请输入您的反馈意见"
@interface FKViewController ()

@end

@implementation FKViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    feedBackMsg = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.bounds.size.height-50-64)] ;
    feedBackMsg.backgroundColor = [UIColor whiteColor];
    feedBackMsg.textColor = [UIColor blackColor];
    [feedBackMsg setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
    feedBackMsg.editable = YES;
    feedBackMsg.scrollEnabled = YES;
    feedBackMsg.delegate = self;
    feedBackMsg.layer.borderColor = [UIColor grayColor].CGColor;
    feedBackMsg.layer.borderWidth =1.0;
    feedBackMsg.layer.cornerRadius =5.0;
    [feedBackMsg scrollRectToVisible:CGRectMake(0, 0, screenMySize.size.width, self.view.bounds.size.height-50-64) animated:YES];
    [self.view addSubview:feedBackMsg];
    
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screenMySize.size.width, 30)];
    label1.text = mFkLabel;
    [label1 setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor grayColor];
    [self.view addSubview:label1];

    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, feedBackMsg.frame.size.height+feedBackMsg.frame.origin.y+5, feedBackMsg.frame.size.width, 40)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"提交" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:UIColorFromRGB(41194)];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
}

-(void)dealloc{
    [serive cancelRequest];
}

//提交
-(void)loginAction
{
    if (feedBackMsg.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mFkLabel delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [feedBackMsg becomeFirstResponder];
        
        return;
    }
  
    
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[ToolCache userKey:kDeviceToken] forKey:@"IMEIStr"];
    [postDic setObject:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
    [postDic setObject:@"" forKey:@"OAUserName"];
    [postDic setObject:feedBackMsg.text forKey:@"MsgContent"];

    [serive PostFromURL:AUpFeedback params:postDic mHttp:httpUrl isLoading:YES];
    
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AUpFeedback])
    {
        if (dic) {
            if (([[dic objectForKey:@"error"] isEqualToString:@"0"])) {
                [RequestSerive alerViewMessage:mActionSuccess];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [RequestSerive alerViewMessage:mActionFailure];
            }
        }
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (feedBackMsg.text.length == 0)
    {
        label1.text = mFkLabel;
    }
    else
    {
        label1.text = @"";
    }
}

#pragma mark - textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
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
