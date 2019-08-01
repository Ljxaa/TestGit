//
//  SystemViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "SystemViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "RequestSerive.h"
#import "BDModel.h"
#import "SearchViewController.h"
#import "FontSIzeViewController.h"
#import "PushWayViewController.h"
#import "SDImageCache.h"

@interface SystemViewController ()

@end

@implementation SystemViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = bgColor;
    // Do any additional setup after loading the view.
    listArray = [[NSArray alloc] initWithObjects:@"字体大小", @"接收推送消息", @"消息提醒方式",@"清除缓存", @"恢复初始设置", nil];
    imageArray = [[NSArray alloc] initWithObjects:@"set_1.png", @"set_2.png", @"set_3.png",@"set_4.png", @"set_5.png", nil];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height-64) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    myTableView.sectionHeaderHeight = 8.0;
    myTableView.sectionFooterHeight = 8.0;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"System";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    
    UIImageView *cellImageView = [[UIImageView alloc] init];
    [cellImageView setFrame:CGRectMake(20, 10, 17, 17)];
    [cell.contentView addSubview:cellImageView];
    
    [cellImageView setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(60, 10, 180, 20)];
    cellTitle.textColor = [UIColor grayColor];
    cellTitle.backgroundColor = [UIColor clearColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+2];
    [cell.contentView addSubview:cellTitle];
    cellTitle.text = [listArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIImageView *cell1ImageView = [[UIImageView alloc] init];
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [cell1ImageView setFrame:CGRectMake(screenMySize.size.width - 25, 15, 15, 15)];
        [cell.contentView addSubview:cell1ImageView];
        
        if ([[ToolCache userKey:KPushNum] isEqualToString:@"1"]) {
            [cell1ImageView setImage:[UIImage imageNamed:@"checkbox_press.png"]];
        }
        else
            [cell1ImageView setImage:[UIImage imageNamed:@"checkbox.png"]];//checkbox.png
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    if (newIndexPath.row == 0) {
        FontSIzeViewController *details = [[FontSIzeViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (newIndexPath.row == 1)
    {
        
        if ([[ToolCache userKey:KPushNum] isEqualToString:@"1"]) {
            [ToolCache setUserStr:[NSString stringWithFormat:@"%d",0]forKey:KPushNum];
        }
        else
            [ToolCache setUserStr:[NSString stringWithFormat:@"%d",1]forKey:KPushNum];
        [tableView reloadData];
    }
    else if (newIndexPath.row == 2)
    {
        PushWayViewController *details = [[PushWayViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.title = @"消息提示方式";
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (newIndexPath.row == 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要清除缓存数据？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag =1;
        [alert show];
        
        
    }
    else if (newIndexPath.row == 4)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要恢复初始设置？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag =2;
        [alert show];
    }
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1&&alertView.tag==1)
    {
        [[SDImageCache sharedImageCache] clearDisk];
        
        [[SDImageCache sharedImageCache] clearMemory];
        
        [BDModel cleanAllArchiveFile];
        [RequestSerive alerViewMessage:@"已清除缓存"];
    }
    if (buttonIndex == 1&&alertView.tag==2)
    {
        [ToolCache setUserStr:[NSString stringWithFormat:@"%d",15] forKey:kFontSize];
        [ToolCache setUserStr:[NSString stringWithFormat:@"%d",1]forKey:KPushNum];//普通推送
        [ToolCache setUserStr:[NSString stringWithFormat:@"%d",0]forKey:kPushNumWay];
//        [SendService setLogin:[NSString stringWithFormat:@"%d",0]];
        [RequestSerive alerViewMessage:@"已恢复初始化"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

