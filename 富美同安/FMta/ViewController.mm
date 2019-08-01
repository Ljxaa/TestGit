//
//  ViewController.m
//  FMta
//
//  Created by wx_air on 2017/3/27.
//  Copyright © 2017年 push. All rights reserved.
//

#import "ViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "MyNavigationController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "PushViewController.h"
#import "ValidationController.h"
#import "RegisteredController.h"
#import "NewMenuItem.h"

#import "AppDelegate.h"
#import "ForgetPasswordController.h"

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
//#import "MCHelper.h"

@interface ViewController ()

@end

#define mSizeWid 40
#define mSizeHid 60

@implementation ViewController

- (void)viewDidLoad {
    //    NSLog(@"wfwfwfwf== %@",wfSubCodeDic);
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录页-背景"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:self.view.frame];
    [backButton addTarget:self action:@selector(closeTextField)forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backButton];
    
    //    UIImage *titleImage = [UIImage imageNamed:@"登录页-标题"];
    UIImage *titleImage =[UIImage imageNamed:@"title_fmta"];
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleImage.size.width/2, titleImage.size.height/2)];
    titleImageView.center = CGPointMake(screenMySize.size.width/2, 70);
    [titleImageView setImage:titleImage];
    [self.view addSubview:titleImageView];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame =CGRectMake(0, 130, screenMySize.size.width, screenMySize.size.height -100);
    [self.view addSubview:bgView];
    
    NSArray *aTarray = [NSArray arrayWithObjects:@"请输入手机号/用户名",@"请输入密码", nil];
    for (int i = 0; i < aTarray.count; i ++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame =CGRectMake(mSizeWid, mSizeHid*(i+1), screenMySize.size.width-mSizeWid*2, 2);
        lineView.backgroundColor = UIColorFromRGB(9811154);
        [bgView addSubview:lineView];
        
        UIImageView *lIage = [[UIImageView alloc] initWithFrame:CGRectMake(mSizeWid, mSizeHid*i+(mSizeHid-32)/2, 32, 32)];
        if (i == 0) {
            lIage.image  = [UIImage imageNamed:@"人"];
        }
        else
            lIage.image  = [UIImage imageNamed:@"密码锁"];
        [bgView addSubview:lIage];
        
        if (i == 0) {
            field1 =[[UITextField alloc]initWithFrame:CGRectMake(lIage.frame.origin.x+lIage.frame.size.width+15,lIage.frame.origin.y, screenMySize.size.width-mSizeWid*2-32-15, 32)];
            [field1 setFont:[UIFont fontWithName:@"Arial" size:labelSize+2]];
            field1.clearButtonMode = UITextFieldViewModeWhileEditing;
            [field1 setBackgroundColor:[UIColor clearColor]];
            [field1 setPlaceholder:[aTarray objectAtIndex:i]];
            [field1 setTextColor:[UIColor whiteColor]];
            field1.delegate = self;
            [field1  setTintColor:UIColorFromRGB(7772885)];
            if ([ToolCache userKey:kAccount]) {
                field1.text = [ToolCache userKey:kAccount];
            }
            [field1 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [bgView addSubview:field1];
        }
        else
        {
            field2 =[[UITextField alloc]initWithFrame:CGRectMake(lIage.frame.origin.x+lIage.frame.size.width+15,lIage.frame.origin.y, screenMySize.size.width-mSizeWid*2-32-15, 32)];
            [field2 setFont:[UIFont fontWithName:@"Arial" size:labelSize+2]];
            field2.clearButtonMode = UITextFieldViewModeWhileEditing;
            [field2 setBackgroundColor:[UIColor clearColor]];
            [field2 setPlaceholder:[aTarray objectAtIndex:i]];
            [field2 setTextColor:[UIColor whiteColor]];
            field2.delegate = self;
            field2.secureTextEntry = YES;
            field2.returnKeyType = UIReturnKeyGo;
            [field2  setTintColor:UIColorFromRGB(7772885)];
            [field2 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [bgView addSubview:field2];
        }
    }
    
    yesBool = YES;
    UIImage *imageD = [UIImage imageNamed:@"勾选框"];
    inButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(mSizeWid, mSizeHid*2+(mSizeHid-32)/2, 32+100, 32);
    [inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+2];
    [inButton setTitle:@"记住密码" forState:UIControlStateNormal];
    [inButton setFrame:frame];
    [inButton setTitleEdgeInsets:UIEdgeInsetsMake(0, imageD.size.width-10, 0, 0)];
    [inButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [inButton setImage:imageD forState:UIControlStateNormal];
    [inButton addTarget:self action:@selector(aInBction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:inButton];
    if ([[ToolCache userKey:KRemember] isEqualToString:@"1"])
    {
        [inButton setImage:[UIImage imageNamed:@"勾选框1"] forState:UIControlStateNormal];
        if ([ToolCache userKey:kPassword]) {
            field2.text = [ToolCache userKey:kPassword];
        }
    }
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(mSizeWid, mSizeHid*3+20, screenMySize.size.width-mSizeWid*2,mSizeWid)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:UIColorFromRGB(41194)];
    [loginButton addTarget:self action:@selector(bgbuttonType) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginButton];
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(screenMySize.size.width-mSizeWid*2, mSizeHid*2+(mSizeHid-32)/2, mSizeWid,mSizeWid)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(RegisteredType) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:loginButton];
    
    //忘记密码按钮
    forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetButton setFrame:CGRectMake(CGRectGetMaxX(loginButton.frame)-mSizeWid-40, CGRectGetMaxY(loginButton.frame)+mSizeWid+25, mSizeWid+40,mSizeWid)];
    [forgetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetPasswordAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:forgetButton];
    
    
    UILabel* label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(10, screenMySize.size.height-100, screenMySize.size.width-20,100 )];
    label.font = [UIFont boldSystemFontOfSize:labelSize];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.text = @"厦门市同安区委办公室\n厦门市同安区人民政府办公室\n开发单位: 同安区政务信息中心\n 技术支持: 厦门微信软件有限公司";
    [self.view addSubview:label];
    
    self.navigationController.navigationBarHidden = YES;
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [serive GetFromURL:ACheckIOSPhone params:nil mHttp:httpUrl isLoading:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

-(void)closeTextField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

//忘记密码
- (void)forgetPasswordAction{
    ForgetPasswordController *vc = [[ForgetPasswordController alloc]init];
    vc.title = @"忘记密码"; [self.navigationController pushViewController:vc animated:YES];
}

-(void)RegisteredType
{
    RegisteredController* vc1 = [[RegisteredController alloc] init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}


-(void)aInBction
{
    yesBool = !yesBool;
    if (yesBool)
    {
        [inButton setImage:[UIImage imageNamed:@"勾选框"] forState:UIControlStateNormal];
    }else
        [inButton setImage:[UIImage imageNamed:@"勾选框1"] forState:UIControlStateNormal];
    [ToolCache setUserStr:[NSString stringWithFormat:@"%d",!yesBool] forKey:KRemember];
}

#pragma mark 登录
-(void)bgbuttonType
{
    if (field1.text.length == 0)
    {
        [RequestSerive alerViewMessage:mAccount];
        [field1 becomeFirstResponder];
    }
    else if (field2.text.length == 0)
    {
        [RequestSerive alerViewMessage:mPassword];
        [field2 becomeFirstResponder];
    }
    else
    {
        [@"" archiveWithKey:[NSString stringWithFormat:@"NewsClass%@",[menuArray objectAtIndex:2]]];
        [@"" archiveWithKey:[NSString stringWithFormat:@"NewsClass%@",[menuArray objectAtIndex:9]]];
        [field1 resignFirstResponder];
        [field2 resignFirstResponder];
        
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        
        [postDic setObject:[ToolCache setUrlStr:field1.text] forKey:@"UID"];
        [postDic setObject:[ToolCache setUrlStr:field2.text] forKey:@"PWD"];
        [postDic setObject:[ToolCache userKey:kDeviceToken] forKey:@"Udid"];
        [postDic setObject:@"" forKey:@"ReturnCode"];
        [serive PostFromURL:AOALogin2 params:postDic mHttp:httpUrl isLoading:YES];
        
    }
    
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:ACheckIOSPhone])
    {
        if (dic) {
            myDictionary = dic;
            NSLog(@"-=-=-=-=%@",dic);
            if ([[dic objectForKey:@"Version"] isEqualToString:Version])
            {
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最新客户端 V%@",[dic objectForKey:@"Version"]] message:[dic objectForKey:@"UpdateLog"]  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
                alert.tag =2;
                [alert show];
            }
        }
    }
    if ([urlName isEqualToString:AOALogin2])
    {
        if (dic)
        {
            if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"msg"])
            {
                [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
            }
            else if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"RandomCode"])
            {
                if ([[NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][@"RandomCode"][@"text"]] isEqualToString:@"false"]) {
                    ValidationController* vc1 = [[ValidationController alloc] init];
                    vc1.isLogin = YES;
                    [self.navigationController pushViewController:vc1 animated:YES];
                    [ToolCache setUserStr:field1.text forKey:kAccountD];
                    [ToolCache setUserStr:field2.text forKey:kPasswordD];
                }
            }
            else
            {
                NSLog(@"NewDataSet:%@",dic[@"NewDataSet"][@"Table"]);
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_ACCOUNT"][@"text"] forKey:kAccount];
                
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_Sex"][@"text"]forKey:kSex];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_DspName"][@"text"]forKey:kDspName];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"User_Title"][@"text"]forKey:kTitle];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"PICTUREURL"][@"text"]forKey:kUserImage];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_GROUPID"][@"text"]forKey:kUserGoupID];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"Type_no1_Ids"][@"text"]forKey:kPermissions];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"AppRoleID"][@"text"]forKey:KAppRoleID];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"USER_Mb"][@"text"]forKey:KPhoneNumber];
                [ToolCache setUserStr:dic[@"NewDataSet"][@"Table"][@"Type_no1_Ids"][@"text"]forKey:KType_no1_Ids];
                
                //                [ToolCache setUserStr:@"13850092556" forKey:KPhoneNumber];
                
                if ([[ToolCache userKey:KRemember] isEqualToString:@"1"])
                {
                    [ToolCache setUserStr:field2.text forKey:kPassword];
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
                
                APPDELEGATE.tabbarController = [[UITabBarController alloc] init];
                [APPDELEGATE.tabbarController setViewControllers:viewControllers];
                APPDELEGATE.tabbarController.selectedIndex = 1;
                [self presentViewController:APPDELEGATE.tabbarController animated:YES completion:nil];
            }
        }else{
            kAlertShow(@"登录失败，请检查网络是否连接。");
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[myDictionary objectForKey:@"AppURI"]]];
        }
    }
}

-(void)dealloc{
    [serive cancelRequest];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == field1) {
        [field2 becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        [self bgbuttonType];
    }
    return YES;
}


//滚动或者触摸隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
