//
//  ValidationController.m
//  同安政务
//
//  Created by _ADY on 16/1/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "ValidationController.h"
#import "Global.h"
#import "ToolCache.h"
#import "MyNavigationController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "PushViewController.h"

@implementation ValidationController
@synthesize isLogin;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"短信验证";
    self.view.backgroundColor = bgColor;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:self.view.frame];
    [backButton addTarget:self action:@selector(closeTextField)forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backButton];
    
    aSmsView = [[SMSValidationView alloc] initWithFrame:CGRectMake(20, 40, screenMySize.size.width-40, 40)isTime:YES];
    aSmsView.delegate = self;
    [self.view addSubview:aSmsView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(0, 0, screenMySize.size.width-40, 40)];
    loginButton.center = CGPointMake(screenMySize.size.width/2, 100+aSmsView.frame.size.height+40);
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"提  交" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:UIColorFromRGB(41194)];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    UILabel* label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(10, 70+aSmsView.frame.size.height/2, screenMySize.size.width-20, screenMySize.size.height-(aSmsView.frame.size.height/2+70))];
    label.font = [UIFont boldSystemFontOfSize:labelSize];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = 0;
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.text = @"系统通过移动短信网关发送短信验证码，可能出现部分使用联通、电信号码的手机未能收到短信，如出现该情况，请使用您在系统中登记的手机号码拨打96861086，根据语音提示，按1收听您的短信验证码内容。";
//    [self.view addSubview:label];
    
    TeStr = @"";
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


-(void)dealloc{
    [serive cancelRequest];
}

-(void)closeTextField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)setField:(NSString*)aTextField
{
    TeStr = aTextField;
}

#pragma makr Login
-(void)loginAction
{
    if (TeStr.length == 0)
    {
        [RequestSerive alerViewMessage:@"验证码不能为空"];
    }
    else
    {
        //登录
        [self setGoLogin:NO];
    }
}

-(void)setGoLogin:(BOOL)isBool
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    if (isLogin) {
        [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kAccountD]] forKey:@"UID"];
        [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kPasswordD]] forKey:@"PWD"];
        [postDic setObject:[ToolCache userKey:kDeviceToken] forKey:@"Udid"];
        if (isBool) {
            [postDic setObject:@"" forKey:@"ReturnCode"];
        }
        else
            [postDic setObject:[ToolCache setUrlStr:TeStr] forKey:@"ReturnCode"];
        
        [serive PostFromURL:AOALogin2 params:postDic mHttp:httpUrl isLoading:YES];
    }
    else
    {
        [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kAccount]] forKey:@"UID"];
        [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kAccountD]] forKey:@"PWD"];
        [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kPasswordD]] forKey:@"NewPWD"];
        if (isBool) {
            [postDic setObject:@"" forKey:@"ReturnCode"];
        }
        else
            [postDic setObject:[ToolCache setUrlStr:TeStr] forKey:@"ReturnCode"];
        
        [serive PostFromURL:APwdChange2 params:postDic mHttp:httpUrl isLoading:YES];
    }
    
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AOALogin2]||[urlName isEqualToString:APwdChange2])
    {
        if (dic)
        {
            if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"msg"])
            {
                [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
                if (!isLogin) {
                    
                    if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"flag"])
                    {
                        if ([[NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][@"flag"][@"text"]] isEqualToString:@"true"])
                            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                    }
                }
            }
            else if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"RandomCode"])
            {
            }
            else
            {
                if (!isLogin)
                {
                    return;
                }
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_ACCOUNT"][@"text"] forKey:kAccount];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_Sex"][@"text"]forKey:kSex];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_DspName"][@"text"]forKey:kDspName];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"PICTUREURL"][@"text"]forKey:kUserImage];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"User_Title"][@"text"]forKey:kTitle];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_GROUPID"][@"text"]forKey:kUserGoupID];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"Type_no1_Ids"][@"text"]forKey:kPermissions];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"AppRoleID"][@"text"]forKey:KAppRoleID];
                
                if ([[ToolCache userKey:KRemember] isEqualToString:@"1"])
                {
                    [ToolCache setUserStr:[ToolCache userKey:kPasswordD] forKey:kPassword];
                }
                else
                    [ToolCache setUserStr:@"" forKey:kPassword];
                
                
                HomeViewController* vc1 = [[HomeViewController alloc] init];
                SearchViewController* vc2= [[SearchViewController alloc] init];
                PushViewController* vc3 = [[PushViewController alloc] init];
                
                MyNavigationController* nav1 = [[MyNavigationController alloc] initWithRootViewController:vc1];
                MyNavigationController* nav2 = [[MyNavigationController alloc] initWithRootViewController:vc2];
                MyNavigationController* nav3 = [[MyNavigationController alloc] initWithRootViewController:vc3];
                
                
                [nav1.tabBarItem setImage:[UIImage imageNamed:@"tool_bar_home"]];
                vc1.title = nav1.title = @"首页";
                [nav2.tabBarItem setImage:[UIImage imageNamed:@"tool_bar_search"]];
                nav2.title = vc2.title = @"我的收藏";
                [nav3.tabBarItem setImage:[UIImage imageNamed:@"tool_bar_setting"]];
                vc3.title = nav3.title = @"消息提醒";
                NSArray* viewControllers = [[NSArray alloc] initWithObjects:nav3, nav1, nav2, nil];
                
                UITabBarController *tabBarController = [[UITabBarController alloc] init];
                [tabBarController setViewControllers:viewControllers];
                tabBarController.selectedIndex = 1;
                [self presentViewController:tabBarController animated:YES completion:nil];
                
                
            }
            
        }
    }
}

@end
