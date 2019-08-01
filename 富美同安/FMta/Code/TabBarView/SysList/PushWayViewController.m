//
//  PushWayViewController.m
//  港务移动信息
//
//  Created by _ADY on 14-12-15.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "PushWayViewController.h"
#import "Global.h"
#import "ToolCache.h"
@interface PushWayViewController ()

@end

@implementation PushWayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    listArray = [[NSArray alloc] initWithObjects:@"响铃并振动", @"响铃", @"振动",@"静音",  nil];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height) style:UITableViewStyleGrouped];
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
    
    static NSString *CellIdentifier = @"PushWay";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(60, 10, 180, 20)];
    cellTitle.textColor = [UIColor grayColor];
    cellTitle.backgroundColor = [UIColor clearColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+2];
    [cell.contentView addSubview:cellTitle];
    cellTitle.text = [listArray objectAtIndex:indexPath.row];
    
    UIImageView *cell1ImageView = [[UIImageView alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [cell1ImageView setFrame:CGRectMake(293, 15, 15, 15)];
    else
        [cell1ImageView setFrame:CGRectMake(275, 15, 15, 15)];
    [cell.contentView addSubview:cell1ImageView];
    if ([[ToolCache userKey:kPushNumWay] isEqualToString:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
        [cell1ImageView setImage:[UIImage imageNamed:@"checkbox_press.png"]];
    }
    else
        [cell1ImageView setImage:[UIImage imageNamed:@"checkbox.png"]];//checkbox.png
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [ToolCache setUserStr:[NSString stringWithFormat:@"%d",(int)newIndexPath.row] forKey:kPushNumWay];
    [tableView reloadData];
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
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
