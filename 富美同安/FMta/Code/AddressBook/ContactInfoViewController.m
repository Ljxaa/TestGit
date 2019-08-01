//
//  ContactInfoViewController.m
//  特房移动OA
//
//  Created by chenhuagui on 13-9-15.
//  Copyright (c) 2013年 yiyihulian. All rights reserved.
//

#import "ContactInfoViewController.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ToolCache.h"
#import "RequestSerive.h"
#import "Global.h"
#import "UsersMenu.h"


@interface ContactInfoViewController ()<UIActionSheetDelegate, MFMessageComposeViewControllerDelegate,ABNewPersonViewControllerDelegate>
{
    NSDictionary *userInfo;
    IBOutlet UITableView *mTableView;
}
@end

@implementation ContactInfoViewController

@synthesize contactInfoDic,nameSString,boolString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"详细信息";
        self.view.backgroundColor = bgColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ToolCache customViewDidLoad];
    share = NO;
//    boolString = NO;

    mTableView.backgroundColor = [UIColor clearColor];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    [self performSelector:@selector(after) withObject:nil afterDelay:.1];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    bool isCopy = NO;
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1.plist",[ToolCache userKey:kAccount]]];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    for (int i = 0; i < [remData count]; i ++) {
        if ([[self.contactInfoDic objectForKey:@"GPLD_UserDspName"] isEqualToString:[[remData objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"GPLD_UserDspName"]]) {
            isCopy = YES;
            break;
        }
    }
    if (!isCopy)
    {
        if (remData == Nil)
        {
            NSMutableDictionary *remData1 = [[NSMutableDictionary alloc] init];
            [remData1 setObject:self.contactInfoDic forKey:@"0"];
            [remData1 writeToFile:filename  atomically:YES];
            [remData1 removeAllObjects];
        }
        else
        {
            [remData setObject:self.contactInfoDic forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[remData count]]];
            [remData writeToFile:filename  atomically:YES];
        }
    }
//    NSLog(@"self.contactInfoDic %@",self.contactInfoDic);
}
-(void)after
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[ToolCache userKey:kAccount]]];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    for (int i = 0; i < [remData count]; i ++) {
        if ([[self.contactInfoDic objectForKey:@"GPLD_UserDspName"] isEqualToString:[[remData objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"GPLD_UserDspName"]]) {
            share = YES;
        }
    }
    if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
    {
        [mTableView reloadData];
    }
    else
    {
        [self loadUserInfo];
    }
    

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    userInfo = nil;
}

- (void)loadUserInfo
{
    
    NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"User_Account"] isEqualToString:[self.contactInfoDic objectForKey:@"GPLD_User"]]||[dic[@"User_Account"] isEqualToString:[self.contactInfoDic objectForKey:@"User_Account"]])
        {
            userInfo = dic;
            [mTableView reloadData];
            return;
        }
    }
}

- (void)smsSendPressed
{
    if (![MFMessageComposeViewController canSendText])
    {
        return;
    }

    
    NSString *mb;

    if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
    {
        mb = [[self.contactInfoDic objectForKey:@"Contact_Mb"] objectForKey:@"text"];
    }
    else
    {
        mb = [userInfo objectForKey:@"User_Mb"];
    }
    if (!zhuanF)
    {
        BOOL result = [mb compare:[NSString stringWithFormat:@"(null)"]] == NSOrderedSame;
        if ([mb isEqual:@""] || result)
        {
            [RequestSerive alerViewMessage:@"电话号码为空无法发送短信!"];
            return;
        }

    }
    
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    if (zhuanF) {
        picker.recipients = nil;
        picker.body = zhuanFString;
    }
    else
        picker.recipients = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@", mb]];

    [self.navigationController presentViewController:picker animated:YES completion:nil];

}

#pragma mark -
#pragma mark MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    NSString*msg = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
        {
            msg = @"您取消了发送短信";
            [RequestSerive alerViewMessage:msg];
        }
            break;
        case MessageComposeResultSent:
        {
            msg = @"短信发送成功";
            [RequestSerive alerViewMessage:msg];
        }
            break;
        case MessageComposeResultFailed:
        {
//            msg = mMailFailure;
//            [RequestSerive alerViewMessage:msg];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
//        CGFloat textHeigh = [ToolCache setString:nameSString setSize:labelSize setWight:280*(iPadOrIphone)];
//        return 35*(iPadOrIphone)+textHeigh*(iPadOrIphone);
        return 70;
    }
    return 44.0*(iPadOrIphone);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.sectionHeaderHeight = 0;
    tableView.sectionFooterHeight = 0;
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier: SimpleTableIdentifier];
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:labelSize];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }


    NSInteger index = indexPath.section;

    if (index == 0)
    {
//        cell.contentView.backgroundColor = [UIColor clearColor];
        UILabel *tLabel = [[UILabel alloc] init];
        tLabel.frame = CGRectMake(10*(iPadOrIphone), 5*(iPadOrIphone), 250*(iPadOrIphone), 30*(iPadOrIphone)) ;
        [tLabel setTextColor:[UIColor orangeColor]];
        [tLabel setFont:[UIFont fontWithName:@"Arial" size:labelSize+6]];
        [tLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:tLabel];
   
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            tLabel.text = [[self.contactInfoDic objectForKey:@"Contact_Chn_Nm"] objectForKey:@"text"];
        }
        else
        {
            tLabel.text = [self.contactInfoDic objectForKey:@"GPLD_UserDspName"];
        }
        NSString *content = nil;
        int  twpe = 25*(iPadOrIphone);

        content = [NSString stringWithFormat:@"%@",nameSString];
//        CGFloat textHeigh = [ToolCache setString:nameSString setSize:labelSize setWight:280*(iPadOrIphone)];
//        twpe = textHeigh*(iPadOrIphone);
        twpe =40;


        content =  [content stringByReplacingOccurrencesOfString:@" " withString:@""];
        content =  [content stringByReplacingOccurrencesOfString:@"null" withString:@""];
        content =  [content stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        UILabel *t1Label = [[UILabel alloc] init];
        t1Label.frame = CGRectMake(10*(iPadOrIphone), 35*(iPadOrIphone), 280*(iPadOrIphone),twpe);
        [t1Label setTextColor:[UIColor blackColor]];
        t1Label.numberOfLines = 0;
        t1Label.text = [NSString stringWithFormat:@"%@",content];
        [t1Label setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        [t1Label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:t1Label];

    }
    else if (index == 1)
    {
        cell.textLabel.textColor = [UIColor grayColor];
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailLabel setFrame:CGRectMake(100*(iPadOrIphone), 0, 160*(iPadOrIphone), 44*(iPadOrIphone))];
        detailLabel.textAlignment = 0;
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:detailLabel];

        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"移动电话:";
            if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
            {
                detailLabel.text = [[self.contactInfoDic objectForKey:@"Contact_Mb"] objectForKey:@"text"];
            }
            else
            {
                detailLabel.text = [userInfo objectForKey:@"User_Mb"];
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(250*(iPadOrIphone), 10*(iPadOrIphone), 25*(iPadOrIphone), 25*(iPadOrIphone));
            [button setImage:[UIImage imageNamed:@"ico_phone.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2000;
            button.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:button];
            
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(button.frame.origin.x+button.frame.size.width+5, 10*(iPadOrIphone), 25*(iPadOrIphone), 25*(iPadOrIphone));
            [button1 setImage:[UIImage imageNamed:@"ico_infon.png"] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button1.tag = 2001;
            button1.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:button1];

            
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"办公电话:";
            if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
            {
                detailLabel.text = [[self.contactInfoDic objectForKey:@"Contact_Tel"] objectForKey:@"text"];
            }
            else
            {
                detailLabel.text = [userInfo objectForKey:@"User_Tel"];
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(280*(iPadOrIphone), 10*(iPadOrIphone), 25*(iPadOrIphone), 25*(iPadOrIphone));
            [button setImage:[UIImage imageNamed:@"ico_phone.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2002;
            button.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:button];

        }
        else if (indexPath.row == 2)
        {
            if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
            {
                cell.textLabel.text = @"QQ号码:";
                detailLabel.text = [[self.contactInfoDic objectForKey:@"Contact_QQ"] objectForKey:@"text"];
            }
            else
            {
                cell.textLabel.text = @"传真号码:";
                detailLabel.text = [userInfo objectForKey:@"User_Fax"];
            }
        }
        else if (indexPath.row == 3)
        {
            
            cell.textLabel.text = @"电子邮箱:";
            detailLabel.numberOfLines = 0;
            if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
            {
                detailLabel.text = [[self.contactInfoDic objectForKey:@"Contact_EMail"] objectForKey:@"text"];
            }
            else
            {
                detailLabel.text = [userInfo objectForKey:@"User_Email"];
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(280*(iPadOrIphone), 10*(iPadOrIphone), 25*(iPadOrIphone), 25*(iPadOrIphone));
            [button setImage:[UIImage imageNamed:@"ico_mail.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2003;
            button.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:button];

        }
        if ([detailLabel.text isEqualToString:@"(null)"])
        {
            detailLabel.text = @"";
        }
    }
    else if (index == 2)
    {

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(12*(iPadOrIphone), 10*(iPadOrIphone), 98*(iPadOrIphone), 28*(iPadOrIphone));
        if (share) {
          [button setImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
        }
        else
            [button setImage:[UIImage imageNamed:@"btn_addgz.png"] forState:UIControlStateNormal];
        button.center = CGPointMake(screenMySize.size.width/6, 22.0*(iPadOrIphone));
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000;
        button.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:button];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(button.frame.origin.x+button.frame.size.width+8*(iPadOrIphone), 10*(iPadOrIphone), 85*(iPadOrIphone), 28*(iPadOrIphone));
        [button1 setImage:[UIImage imageNamed:@"btn_bczbd.png"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button1.tag = 1001;
        button1.center = CGPointMake(screenMySize.size.width/2, 22.0*(iPadOrIphone));
        button1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:button1];

        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(button1.frame.origin.x+button1.frame.size.width+8*(iPadOrIphone), 10*(iPadOrIphone), 90*(iPadOrIphone), 28*(iPadOrIphone));
        [button2 setImage:[UIImage imageNamed:@"btn_tgdxzf.png"] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button2.tag = 1002;
        button2.center = CGPointMake(screenMySize.size.width*5/6, 22.0*(iPadOrIphone));
        button2.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:button2];

    }

    return cell;
}

-(void)buttonAction:(id)sender
{
    NSInteger type = ((UIButton*)sender).tag-1000;
    NSString *phone = nil;
    if (type == 0)//+常用联系人
    {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths  objectAtIndex:0];
        NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[ToolCache userKey:kAccount]]];
        NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
        if (share)
        {

            [RequestSerive alerViewMessage:@"取消关注。"];
            if (remData != Nil)
            {
                for (int i = 0; i < [remData count]; i ++) {
                   if ([[self.contactInfoDic objectForKey:@"GPLD_UserDspName"] isEqualToString:[[remData objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"GPLD_UserDspName"]]) {
                        [remData removeObjectForKey:[remData objectForKey:[NSString stringWithFormat:@"%d",i]]];
                        for (int j  = i; j <[remData count]-1; j++) {
                                                    [remData setObject:[remData objectForKey:[NSString stringWithFormat:@"%d",j+1]] forKey:[NSString stringWithFormat:@"%d",j]];
                        }
                       [remData removeObjectForKey:[NSString stringWithFormat:@"%d",(int)[remData count]-1]];
                        [remData writeToFile:filename  atomically:YES];
                        break;
                        
                    }
                    
                }
                
            }

        }
        else
        {
            [RequestSerive alerViewMessage:@"关注成功。"];
            if (remData == Nil)
            {
                NSMutableDictionary *remData1 = [[NSMutableDictionary alloc] init];
                [remData1 setObject:self.contactInfoDic forKey:@"0"];
                [remData1 writeToFile:filename  atomically:YES];
                [remData1 removeAllObjects];
            }
            else
            {
                [remData setObject:self.contactInfoDic forKey:[NSString stringWithFormat:@"%lu",(unsigned long)[remData count]]];
                [remData writeToFile:filename  atomically:YES];
            }
        }
        UIButton *button = (UIButton*)[self.view viewWithTag:1000];
        if (!share) {
            [button setImage:[UIImage imageNamed:@"btn_cancel.png"] forState:UIControlStateNormal];
        }
        else
            [button setImage:[UIImage imageNamed:@"btn_addgz.png"] forState:UIControlStateNormal];
        share = !share;
            
        
        


    }
    else if (type == 1)//本地
    {
        NSString *phone1 = nil;
        NSString *phone2 = nil;
        NSString *phone3 = nil;
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone1 = [[self.contactInfoDic objectForKey:@"Contact_Mb"] objectForKey:@"text"];
        }
        else
        {
            phone1 = [userInfo objectForKey:@"User_Mb"];
        }
        
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone2 = [[self.contactInfoDic objectForKey:@"Contact_Tel"] objectForKey:@"text"];
        }
        else
        {
            phone2 = [userInfo objectForKey:@"User_Tel"];
        }
        phone3 = [userInfo objectForKey:@"User_Mb2"];
        NSString *mial = nil;
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            mial = [[self.contactInfoDic objectForKey:@"Contact_EMail"] objectForKey:@"text"];
        }
        else
        {
            mial = [userInfo objectForKey:@"User_Email"];
        }
        NSString *name = nil;
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            name = [[self.contactInfoDic objectForKey:@"Contact_Chn_Nm"] objectForKey:@"text"];
        }
        else
        {
            name = [self.contactInfoDic objectForKey:@"GPLD_UserDspName"];
        }
        
        //　　// 创建一条空的联系人
        ABRecordRef record = ABPersonCreate();
        CFErrorRef error;
        ABRecordSetValue(record, kABPersonFirstNameProperty, (__bridge CFTypeRef)name, &error);
         if (![[self.contactInfoDic objectForKey:@"GPLD_JobTitle"] isEqualToString:@"(null)"])
             ABRecordSetValue(record, kABPersonJobTitleProperty, (__bridge CFTypeRef)[self.contactInfoDic objectForKey:@"GPLD_JobTitle"], &error);
        if (![[self.contactInfoDic objectForKey:@"GroupName"] isEqualToString:@"(null)"])
             ABRecordSetValue(record, kABPersonOrganizationProperty, (__bridge CFTypeRef)[self.contactInfoDic objectForKey:@"GroupName"], &error);
        
        //email
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        if (![mial isEqualToString:@"(null)"])
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(mial), kABWorkLabel, NULL);
        ABRecordSetValue(record, kABPersonEmailProperty, multiEmail, &error);
        //phone
        ABMultiValueRef phone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        if (![phone1 isEqualToString:@"(null)"])
            ABMultiValueAddValueAndLabel(phone,(__bridge CFTypeRef)(phone1), kABPersonPhoneMobileLabel, NULL);//添加iphone号码1
        if (![phone2 isEqualToString:@"(null)"])
            ABMultiValueAddValueAndLabel(phone,(__bridge CFTypeRef)(phone2), kABPersonPhoneMainLabel, NULL);//添加移动号码0
        if (![phone3 isEqualToString:@"(null)"])
            ABMultiValueAddValueAndLabel(phone,(__bridge CFTypeRef)(phone3), kABPersonPhoneMainLabel, NULL);
        ABRecordSetValue(record, kABPersonPhoneProperty, phone, &error);
        
        ABNewPersonViewController *view = [[ABNewPersonViewController alloc] init];
        view.newPersonViewDelegate = self;
        view.displayedPerson = record;
        UINavigationController *newNavigationController = [[UINavigationController alloc] initWithRootViewController:view];
//        [self presentModalViewController:newNavigationController animated:YES];
        [self presentViewController:newNavigationController animated:YES completion:nil];
        CFRelease(phone);
        CFRelease(multiEmail);
        CFRelease(record);
    }
    else if (type == 2)//短信转发
    {
        zhuanF = YES;
        NSString *phone = nil;
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [NSString stringWithFormat:@"姓名:%@",[[self.contactInfoDic objectForKey:@"Contact_Chn_Nm"] objectForKey:@"text"]];
        }
        else
        {
            phone = [NSString stringWithFormat:@"姓名:%@",[self.contactInfoDic objectForKey:@"GPLD_UserDspName"]];
        }
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [NSString stringWithFormat:@"%@\n移动电话:%@",phone,[[self.contactInfoDic objectForKey:@"Contact_Mb"] objectForKey:@"text"]];
        }
        else
        {
            phone = [NSString stringWithFormat:@"%@\n移动电话:%@",phone,[userInfo objectForKey:@"User_Mb"]];
        }
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [NSString stringWithFormat:@"%@\n办公电话:%@",phone,[[self.contactInfoDic objectForKey:@"Contact_Tel"] objectForKey:@"text"]];
        }
        else
            phone = [NSString stringWithFormat:@"%@\n办公电话:%@",phone,[userInfo objectForKey:@"User_Tel"]];
        
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [NSString stringWithFormat:@"%@\nQQ号码:%@",phone,[[self.contactInfoDic objectForKey:@"Contact_QQ"] objectForKey:@"text"]];
            
        }
        else
        {
            if ([userInfo objectForKey:@"User_Fax"] == nil) {
                      phone = [NSString stringWithFormat:@"%@\n传真号码:",phone];
            }
            else
            phone = [NSString stringWithFormat:@"%@\n传真号码:%@",phone,[userInfo objectForKey:@"User_Fax"]];
        }
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [NSString stringWithFormat:@"%@\n电子邮箱:%@",phone,[[self.contactInfoDic objectForKey:@"Contact_EMail"] objectForKey:@"text"]];
        }
        else
        {
            phone = [NSString stringWithFormat:@"%@\n电子邮箱:%@",phone,[userInfo objectForKey:@"User_Email"]];
            
        }
        
        phone = [phone stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
        zhuanFString = phone;
        [self smsSendPressed];
    }
    else if (type == 1000)//手机拨打
    {
        NSString *phone = nil;
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [[self.contactInfoDic objectForKey:@"Contact_Mb"] objectForKey:@"text"];
        }
        else
        {
            phone = [userInfo objectForKey:@"User_Mb"];
        }
        BOOL result = [phone compare:[NSString stringWithFormat:@"(null)"]] == NSOrderedSame;
        if ([phone isEqual:@""] || result)
        {
            [RequestSerive alerViewMessage:@"电话号码为空无法拨打!"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];

    }
    else if (type == 1001)//手机短信
    {
        zhuanF = NO;
        [self smsSendPressed];
    }
    else if (type == 1002)//电话拨打
    {
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [[self.contactInfoDic objectForKey:@"Contact_Tel"] objectForKey:@"text"];
        }
        else
        {
            phone = [userInfo objectForKey:@"User_Tel"];
        }
        BOOL result = [phone compare:[NSString stringWithFormat:@"(null)"]] == NSOrderedSame;
        if ([phone isEqual:@""] || result)
        {
            [RequestSerive alerViewMessage:@"电话号码为空无法拨打!"];
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];

    }
    else if (type == 1003)//邮件
    {
        if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
        {
            phone = [[self.contactInfoDic objectForKey:@"Contact_EMail"] objectForKey:@"text"];
        }
        else
        {
            phone = [userInfo objectForKey:@"User_Email"];
        }
        if (phone != nil)
        {
            BOOL result = [phone compare:[NSString stringWithFormat:@"(null)"]] == NSOrderedSame;
            if ([phone isEqual:@""] || result)
            {
                [RequestSerive alerViewMessage:@"电子邮箱为空无法发送邮件!"];
                return;
            }
            

//            WriteMailViewController *vc = [[WriteMailViewController alloc] initWithNibName:nil bundle:nil];
//            vc.type = 0;
//            if ([self.contactInfoDic objectForKey:@"Contact_ID"] != nil)
//            {
//                [vc setmShoujianTextField:[self.contactInfoDic objectForKey:@"GPLD_User"]];
//            }
//            else
//            {
//                [vc setmShoujianTextField:[userInfo objectForKey:@"User_Account"]];
//                
//            }
//            
//            vc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:vc animated:YES];
            
        }

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    int row = indexPath.section;

}

- (void)callTel:(NSString *)tel tag:(NSInteger)tag
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"拨打电话：%@", tel], nil];
    sheet.tag = tag;
    [sheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSString *phone;
        if (actionSheet.tag == 2)
        {
            phone = [userInfo objectForKey:@"User_Tel"];
        }
        else
        {
            phone = [userInfo objectForKey:@"User_Mb"];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]]];
    }
}


- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    if (person!=NULL) {
//        ABAddressBookRef adbk=ABAddressBookCreate();
        ABAddressBookRef addressBook = nil;
        
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        }
//        else
        {
//            addressBook = ABAddressBookCreate();
        }

        ABAddressBookAddRecord(addressBook, person, NULL);
        CFStringRef name=ABRecordCopyCompositeName(person);
        CFRelease(name);
        CFRelease(addressBook);
        [RequestSerive alerViewMessage:@"保存成功。"];
    }
//    [newPersonView dismissModalViewControllerAnimated:YES];
    [newPersonView dismissViewControllerAnimated:YES completion:nil];
}

@end

