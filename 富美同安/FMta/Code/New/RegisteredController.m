//
//  RegisteredController.m
//  同安政务
//
//  Created by _ADY on 16/1/23.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "RegisteredController.h"
#import "Global.h"
#import "ToolCache.h"
@implementation RegisteredController

#define zcHight 40

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.view.backgroundColor = bgColor;
    
    fArray = [NSArray arrayWithObjects:@"手机号:",@"验证码:",@"帐号:",@"姓名:",@"密码:",@"确认密码:",@"所属单位:",@"职务:",@"性别:",@"办公电话:", nil];
    sArray = [NSArray arrayWithObjects:@"请输入手机号",@"请输入验证码",@"请输入姓名全拼",@"请输入中文姓名",@"请输入密码",@"请输入确认密码",@"请输入所属单位",@"请输入职务",@"请选择性别",@"请输入办公电话", nil];
    TeStr = @"";
    
    gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:gScrollView];
    [gScrollView setContentSize:CGSizeMake(0,(zcHight+10)*sArray.count+140)];
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:gScrollView.frame];
    [backButton addTarget:self action:@selector(closeTextField)forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor = [UIColor clearColor];
    [gScrollView addSubview:backButton];
    
    for (int i = 0 ; i < sArray.count; i ++)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5+(zcHight+10)*i, 90, zcHight)];
        titleLabel.text = [NSString stringWithFormat:@"%@",[fArray objectAtIndex:i]];
        titleLabel.textAlignment = 2;
        titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        titleLabel.textColor = [UIColor blackColor];
        [gScrollView addSubview:titleLabel];
        
        if (i == 1) {
            aSmsView = [[SMSValidationView alloc] initWithFrame:CGRectMake(100, 5+(zcHight+10)*i, screenMySize.size.width-115, zcHight) isTime:NO];
            aSmsView.delegate = self;
            [gScrollView addSubview:aSmsView];
            continue;
        }
        
        UITextField* password = [[UITextField alloc] initWithFrame:CGRectMake(95, 5+(zcHight+10)*i, screenMySize.size.width-105, zcHight)];
        password.backgroundColor = [UIColor whiteColor];
        [password setFont:[UIFont systemFontOfSize:labelSize-3]];
        password.returnKeyType = UIReturnKeyNext;
        [password  setTintColor:UIColorFromRGB(7772885)];
        [password.layer setBorderWidth:1];
        [password.layer setBorderColor:[UIColor grayColor].CGColor];
        [password.layer setCornerRadius:5];
        [password setKeyboardType:UIKeyboardTypeASCIICapable];
        password.tag = 100+i;
        [password setPlaceholder:[sArray objectAtIndex:i]];
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
        password.delegate = self;
        if (i == 4 || i == 5) {
            password.secureTextEntry = YES;
        }
        [gScrollView addSubview:password];
        if (i == 0) {
            password.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    bgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [bgButton setFrame:CGRectMake(20, (zcHight+10)*sArray.count+40, screenMySize.size.width-40, 40)];
    [bgButton setTitle:@"注册" forState:UIControlStateNormal];
    [bgButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgButton setBackgroundColor:UIColorFromRGB(41194)];
    [bgButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [gScrollView addSubview:bgButton];
//    [self PtButton];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
}

-(void)dealloc{
    [serive cancelRequest];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
//    if (textField.tag == 106)//所属单位
//    {
//        if (nArray.count == 0) {
//            [serive GetFromURL:AOAgetGroupID params:nil mHttp:httpUrl isLoading:YES];
//        }
//        else
//            [self gotoAst];
//        
//        return NO;
//    }
//    else if (textField.tag == 107)//所属职级
//    {
//        
//        return NO;
//    }
    if (textField.tag == 108)
    {
        [self gotoSex];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    int aTag = (int)textField.tag;
    
//    if (aTag == 106)
//    {
//        [textField resignFirstResponder];
//        
//    }
//    else
    {
        if (aTag == 100) {
            aTag = 101;
        }
        UITextField *aText =  (UITextField*)[self.view viewWithTag:aTag+1];
        
        [gScrollView setContentOffset:CGPointMake(0, 5+(zcHight+10)*(aTag-100)) animated:YES];
        
        [aText becomeFirstResponder];
    }
    return YES;
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AOAgetGroupID])//所属单位
    {
        if (dic)
        {
            if ([[dic[@"NewDataSet"] allKeys] containsObject:@"Table"]) {
                
                nArray = [[NSMutableArray alloc] init];
                
                for (NSDictionary *DIC in dic[@"NewDataSet"][@"Table"])
                {
                    [nArray addObject:DIC];
                }
                [self gotoAst];

            }
        }
    }
    if ([urlName isEqualToString:APhoneCode])//注册
    {
        if (dic)
        {
            if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"msg"])
            {
                [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
            }
           if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"flag"])
            {
//                if ([[NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][@"flag"][@"text"]] isEqualToString:@"true"]) {
//                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
//                }
            }
        }
    }
}

-(void)gotoSex
{
    [self closeTextField];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"男"];
    [actionSheet addButtonWithTitle:@"女"];
    actionSheet.tag = 101;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)gotoAst
{
    [self closeTextField];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSDictionary *DIC in nArray)
    {
        [actionSheet addButtonWithTitle:DIC[@"GROUP_Name"][@"text"]];
    }
    actionSheet.tag = 100;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100)//所属单位
    {
        UITextField *aText =  (UITextField*)[self.view viewWithTag:106];
        aText.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
    if (actionSheet.tag == 101)//性别
    {
        UITextField *aText =  (UITextField*)[self.view viewWithTag:108];
        aText.text = [actionSheet buttonTitleAtIndex:buttonIndex];
    }
}

-(void)setField:(NSString*)aTextField
{

    TeStr = aTextField;
}


-(void)setGoLogin:(BOOL)isBool
{
     UITextField *aText =  (UITextField*)[self.view viewWithTag:100];
    if (![ToolCache isCheckTel:aText.text]) {
        [RequestSerive alerViewMessage:[NSString stringWithFormat:@"%@格式不对",[[sArray objectAtIndex:0] substringFromIndex:3]]];
        [aSmsView setPush1];
    }
    else//获取验证码
    {
        [self gotoAction:NO];
    }
    
}

#pragma mark 注册
-(void)loginAction
{
    for (int i = 0; i < sArray.count; i ++) {
        UITextField *aText =  (UITextField*)[self.view viewWithTag:100+i];
        if (![aText.text hash]&&i != 1)
        {
            [RequestSerive alerViewMessage:[sArray objectAtIndex:i]];
            return;
        }
        if (i == 0) {
            if (![ToolCache isCheckTel:aText.text]) {
                [RequestSerive alerViewMessage:[NSString stringWithFormat:@"%@格式不对",[[sArray objectAtIndex:0] substringFromIndex:3]]];
                return;
            }
        }
        if (i == 1)
        {
            if (![TeStr hash])
            {
                [RequestSerive alerViewMessage:[sArray objectAtIndex:i]];
                return;
            }
        }
        if (i == 2) {
            if (![ToolCache validateUserAcount:aText.text]) {
                [RequestSerive alerViewMessage:[[sArray objectAtIndex:i] substringFromIndex:3]];
                return;
            }
        }
        
        
    }
    UITextField *aText =  (UITextField*)[self.view viewWithTag:104];
    UITextField *aText1 =  (UITextField*)[self.view viewWithTag:105];
    if (![aText.text isEqualToString:aText1.text])
    {
        [RequestSerive alerViewMessage:mPass];
        return;
    }
    //注册
    [self gotoAction:YES];
    
}
//NO获取验证码
-(void)gotoAction:(BOOL)isCode
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    NSArray *keyArray = [NSArray arrayWithObjects:@"Phone",@"ReturnCode",@"Account",@"Name",@"PWD",@"Tel1", @"Tel2",@"Sex",@"OfficePhone",nil];
    for (int i = 0; i < keyArray.count; i ++)
    {
        UITextField *aText =  (UITextField*)[self.view viewWithTag:100+i];
        if (i >= 5)
        {
           aText =  (UITextField*)[self.view viewWithTag:100+i+1];
        }
        NSString *aTextStr = @"";
        if (isCode|| i == 0)
        {
            aTextStr = aText.text;
            if (i == 1) {
                aTextStr = TeStr;
            }
        }
        if (isCode&&(i == 1 || i ==2|| i == 4))
        {
            [postDic setObject:[ToolCache setUrlStr:aTextStr] forKey:[keyArray objectAtIndex:i]];

        }else
             [postDic setObject:aTextStr forKey:[keyArray objectAtIndex:i]];
        
    }
    [serive PostFromURL:APhoneCode params:postDic mHttp:httpUrl isLoading:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)closeTextField
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
