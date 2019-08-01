//
//  ChangePassWordViewController.m
//  何五路
//
//  Created by _ADY on 15/7/29.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "ValidationController.h"

@interface ChangePassWordViewController ()

@end

@implementation ChangePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, 380) style:UITableViewStyleGrouped];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.scrollEnabled = NO;
    mTableView.sectionHeaderHeight = 0.0;
    mTableView.sectionFooterHeight = 0.0;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
    
    self.view.backgroundColor = bgColor;
    
    self.title = @"修改密码";
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    TeStr = @"";
}

-(void)rightAction
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if(![oldpassword hasText])
    {
        [RequestSerive alerViewMessage:mOldPass];
        return;
    }
    if(![password hasText])
    {
        [RequestSerive alerViewMessage:mNewPass];
        return;
    }
    if(![aPassWord hasText])
    {
        [RequestSerive alerViewMessage:mSurePass];
        return;
    }
    if (![password.text isEqualToString:aPassWord.text])
    {
        [RequestSerive alerViewMessage:mPass];
        return;
    }
    
    
    [self setGoLogin:YES];

    
}

-(void)setField:(NSString*)aTextField
{
    TeStr = aTextField;
}

-(void)setGoLogin:(BOOL)isBool
{
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    
    [postDic setObject:[ToolCache setUrlStr:[ToolCache userKey:kAccount]] forKey:@"UID"];
    [postDic setObject:[ToolCache setUrlStr:oldpassword.text] forKey:@"PWD"];
    [postDic setObject:[ToolCache setUrlStr:aPassWord.text] forKey:@"NewPWD"];
    if (isBool) {
        [postDic setObject:@"" forKey:@"ReturnCode"];
    }
    else
        [postDic setObject:[ToolCache setUrlStr:TeStr] forKey:@"ReturnCode"];
    
    [serive PostFromURL:APwdChange2 params:postDic mHttp:httpUrl isLoading:YES];
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:APwdChange2])
    {
        if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"msg"])
        {
            [RequestSerive alerViewMessage:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
            if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"flag"])
            {
                if ([[NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][@"flag"][@"text"]] isEqualToString:@"true"])
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            }
        }
        else if ([[dic[@"NewDataSet"][@"Table"] allKeys] containsObject:@"ChangePWDCode"])
        {
            if ([[NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][@"ChangePWDCode"][@"text"]] isEqualToString:@"false"]) {
                ValidationController* vc1 = [[ValidationController alloc] init];
                vc1.isLogin = NO;
                [self.navigationController pushViewController:vc1 animated:YES];
                [ToolCache setUserStr:oldpassword.text forKey:kAccountD];
                [ToolCache setUserStr:password.text forKey:kPasswordD];
            }
        }
    }
}

#pragma mark -
#pragma mark Table View DataSource

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
        return 0.001;
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChangePassWordCell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        aTableView.showsVerticalScrollIndicator = NO;
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    return [self mCell:cell bCTableView:aTableView cellForRowAtIndexPath:indexPath];
    // Configure the cell...
    return cell;
}


- (UITableViewCell *)mCell:(UITableViewCell*)cell bCTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tArray = [NSArray arrayWithObjects:@"旧密码:",@"新密码:",@"确认密码:",nil];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 95, 40)];
    titleLabel.text = [NSString stringWithFormat:@"%@",[tArray objectAtIndex:indexPath.row]];
    titleLabel.textAlignment = 2;
    titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+2];
    titleLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titleLabel];
    
    
    if (indexPath.row == 0)
    {
        oldpassword = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, screenMySize.size.width-110, 40)];
        oldpassword.backgroundColor = [UIColor clearColor];
        [oldpassword setFont:[UIFont systemFontOfSize:labelSize]];
        oldpassword.returnKeyType = UIReturnKeyNext;
        [oldpassword setPlaceholder:@"请输入旧密码"];
        [oldpassword setClearButtonMode:UITextFieldViewModeWhileEditing];
        [oldpassword setKeyboardType:UIKeyboardTypeASCIICapable];
        oldpassword.delegate = self;
        oldpassword.secureTextEntry = YES;
        [cell.contentView addSubview:oldpassword];
        
    }
    else if (indexPath.row == 1)
    {
        password = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, screenMySize.size.width-110, 40)];
        password.backgroundColor = [UIColor clearColor];
        [password setFont:[UIFont systemFontOfSize:labelSize]];
        password.returnKeyType = UIReturnKeyNext;
        [password setPlaceholder:@"请输入新密码"];
        [password setKeyboardType:UIKeyboardTypeASCIICapable];
        [password setClearButtonMode:UITextFieldViewModeWhileEditing];
        password.delegate = self;
        password.secureTextEntry = YES;
        [cell.contentView addSubview:password];
        
    }
    else if (indexPath.row == 2)
    {
        aPassWord = [[UITextField alloc] initWithFrame:CGRectMake(100, 0, screenMySize.size.width-110, 40)];
        aPassWord.backgroundColor = [UIColor clearColor];
        [aPassWord setFont:[UIFont systemFontOfSize:labelSize]];
        aPassWord.returnKeyType = UIReturnKeyDone;
        [aPassWord setKeyboardType:UIKeyboardTypeASCIICapable];
        [aPassWord setClearButtonMode:UITextFieldViewModeWhileEditing];
        aPassWord.delegate = self;
        aPassWord.secureTextEntry = YES;
        [aPassWord setPlaceholder:@"请再次输入新密码"];
        [cell.contentView addSubview:aPassWord];
        
    }
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate
//限制输入长度 by zwb 2011.9.6
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == password ||textField == aPassWord||textField == oldpassword )
    {
        if (range.location > 15){
            
            [RequestSerive alerViewMessage:mPasswordLong];
            textField.text = [textField.text substringToIndex:[textField.text length] - 1];
            return NO;
        }
    }
    return YES;
    
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
    if (textField == password) {
        [aPassWord becomeFirstResponder];
    }
    else
        [textField resignFirstResponder];

    return YES;
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
