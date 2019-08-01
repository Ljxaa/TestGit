//
//  SearchViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "SearchViewController.h"
#import "Global.h"
#import "ViedoDetialsViewController.h"
#import "DetialsViewController.h"
#import "DetialsItem.h"
#import "UIImageView+WebCache.h"

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor;
    scArray = nil;
    if ([DetialsItem unarchiveWithKey:@"DetialsSC"] != nil)
    {
        scArray = [DetialsItem unarchiveWithKey:@"DetialsSC"];
    }
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.frame.size.height-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    scArray = nil;
    if ([DetialsItem unarchiveWithKey:@"DetialsSC"] != nil)
    {
        scArray = [DetialsItem unarchiveWithKey:@"DetialsSC"];
    }
    [mTableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Sc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    NSMutableDictionary *dictionary = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)indexPath.row-1]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screenMySize.size.width-20,35)];
    titleLabel.text = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"Title"]];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 2;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, screenMySize.size.width-20,15)];
    timeLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text =[dictionary objectForKey:@"myNowTime"];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [cell.contentView addSubview:timeLabel];

    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [lineImageView setFrame:CGRectMake(10, 68, screenMySize.size.width-20, 2)];
    [cell.contentView addSubview:lineImageView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
        NSMutableDictionary *dictionary = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]];
    
    if ([[dictionary allKeys] containsObject:@"VideoThumnAdd"])//视频
    {
        ViedoDetialsViewController *details = [[ViedoDetialsViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.dic = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]];
        [self.navigationController pushViewController:details animated:YES];
    }
    else
    {
        int howG = (int)scArray.count-(int)newIndexPath.row-1;
        

        
        DetialsViewController *details = [[DetialsViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.title = @"内容详情";
//        for (int i = 0; i < wfSubCodeDic.allKeys.count; i ++) {
//            if ([ isEqualToString:[wfSubCodeArray objectAtIndex:i]])
//            {
//                details.title = [menuArray objectAtIndex:i];
//                break;
//            }
//        }
        for (NSString *str in [wfSubCodeDic allKeys]) {
            if ([[NSString stringWithFormat:@"%@",dictionary[@"ClassId"]] isEqualToString:[wfSubCodeDic objectForKey:str]]) {
                details.title = str;
                break;
            }
        }
        details.dic = [scArray objectForKey:[NSString stringWithFormat:@"%d",howG]];
        [self.navigationController pushViewController:details animated:YES];
    }
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)atableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableDictionary *sc1Array = [[NSMutableDictionary alloc]init];
        if ([DetialsItem unarchiveWithKey:@"DetialsSC"] != nil)
        {
            sc1Array = [DetialsItem unarchiveWithKey:@"DetialsSC"];
        }
        
        NSMutableDictionary *dictionary = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)indexPath.row-1]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            for (int i = 0; i < sc1Array.count; i++)
            {
                if ([[[sc1Array objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"Title"] isEqualToString:[dictionary objectForKey:@"Title"]]){
                    for (int j = i; j< sc1Array.count-1; j++)
                    {
                        [sc1Array setObject:[sc1Array objectForKey:[NSString stringWithFormat:@"%d",j+1]] forKey:[NSString stringWithFormat:@"%d",j]];
                    }
                    [sc1Array removeObjectForKey:[NSString stringWithFormat:@"%d",(int)sc1Array.count-1]];
                    [sc1Array archiveWithKey:@"DetialsSC"];
                    scArray = sc1Array;
                    break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [atableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [atableView reloadData];
            });
        });
        
    }
    //新建
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
