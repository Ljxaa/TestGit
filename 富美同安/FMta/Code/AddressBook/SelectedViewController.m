//
//  SelectedViewController.m
//  特房移动OA
//
//  Created by chenhuagui on 13-9-19.
//  Copyright (c) 2013年 yiyihulian. All rights reserved.
//

#import "SelectedViewController.h"
#import "ToolCache.h"
#import "Global.h"

@interface SelectedViewController ()<UITableViewDataSource>
{
    IBOutlet UITableView *mTableView;
    NSMutableArray *selectedArray;
}
@end

@implementation SelectedViewController

@synthesize selectedSet,selectedGroupBy;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"已选人员";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ToolCache customViewDidLoad];
    selectedArray = [[NSMutableArray alloc] init];
    [self setArray];

    if (selectedGroupBy==3)
    {
        self.title = @"已选公司";
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 37*.75, 34*.75)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem  = leftButton;
}
-(void)popself
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tongxunlu" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setArray
{
    [selectedArray removeAllObjects];
    for (NSMutableDictionary *temp in self.selectedSet)
    {
        if (![[temp allKeys] containsObject:@"GPLD_UserDspName"])
        {
            if (![[temp objectForKey:@"Group_Name"] isEqualToString:@""])
                [selectedArray addObject:temp];
        }
        else
        {
            if (![[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@""])
                [selectedArray addObject:temp];
        }

    }
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"GPLD_Ord" ascending:YES]];
//    [selectedArray sortUsingDescriptors:sortDescriptors];
//    saveArray = selectedArray;
    [mTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60*(iPadOrIphone);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, 50*(iPadOrIphone), 30*(iPadOrIphone));
        [button setTitle:@"删除" forState:UIControlStateNormal];
        cell.accessoryView = button;
    }

    UIButton *btn = (UIButton *)cell.accessoryView;
    btn.tag = indexPath.row;
    [btn addTarget:self  action:@selector(deletePressed:) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dic = [selectedArray objectAtIndex:indexPath.row];
    if (![[dic allKeys] containsObject:@"GPLD_UserDspName"])
        cell.textLabel.text = [dic objectForKey:@"Group_Name"];
    else
        cell.textLabel.text = [dic objectForKey:@"GPLD_UserDspName"];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+1];
    return cell;
}

- (void)deletePressed:(UIButton *)button
{
    NSInteger index = button.tag;
    [selectedArray removeObjectAtIndex:index];
//    [saveArray removeAllObjects];
//    saveArray = selectedArray;
    [mTableView reloadData];
}




@end
