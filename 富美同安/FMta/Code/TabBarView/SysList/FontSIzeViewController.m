//
//  FontSIzeViewController.m
//  XMGW_MIPlatform
//
//  Created by _ADY on 14-10-31.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "FontSIzeViewController.h"
#import "Global.h"
#import "ToolCache.h"
@interface FontSIzeViewController ()

@end

@implementation FontSIzeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"字体大小";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    // Do any additional setup after loading the view.
    
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Font";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    
    
    
    NSArray *listArray = [NSArray arrayWithObjects:@"较小字体",@"正常字体",@"较大字体", nil];
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(60, 10, 180, 20)];
    cellTitle.textColor = [UIColor grayColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:[[fontArray objectAtIndex:indexPath.row] intValue]];
    

    [cell.contentView addSubview:cellTitle];
    cellTitle.text = [listArray objectAtIndex:indexPath.row];
    
    int lSize = [[ToolCache userKey:kFontSize] intValue];
    //10 15 18
    UIImageView *cell1ImageView = [[UIImageView alloc] init];
    [cell1ImageView setFrame:CGRectMake(screenMySize.size.width-25, 15, 15, 15)];
    [cell.contentView addSubview:cell1ImageView];
    [cell1ImageView setImage:[UIImage imageNamed:@"checkbox.png"]];//checkbox.png
    if (lSize == [[fontArray objectAtIndex:indexPath.row] intValue])
    {
        [cell1ImageView setImage:[UIImage imageNamed:@"checkbox_press.png"]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{

    [ToolCache setUserStr:[fontArray objectAtIndex:newIndexPath.row] forKey:kFontSize];
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    [tableView reloadData];
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
