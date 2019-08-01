//
//  VideoViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "VideoViewController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "ToolCache.h"
#import "ViedoDetialsViewController.h"
#import "VideoViewCell.h"

@implementation VideoViewController
@synthesize mTableView,fListArray,RowID;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.frame.size.height-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    mTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];
    
    [mTableView.header beginRefreshing];
    
}
-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetVideosList])
    {
        if (dic != nil) {
            [fListArray addObjectsFromArray:dic[@"DataList"]];
        }
        
        [mTableView reloadData];
        [mTableView.header endRefreshing];
        [mTableView.footer endRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)ReloadThe
{
    [mTableView.header beginRefreshing];
}

- (void)loadNewData
{
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];
    [self upDateTableView];
}
- (void)loadMoreData
{
    pageForNumber++;
    [self upDateTableView];
}

-(void)upDateTableView
{
    if ((pageForNumber-1)*itemLabel <= [fListArray count]||pageForNumber ==1)
    {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[ToolCache userKey:kDeviceToken] forKey:@"IMEINO"];
        [dic setValue:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
        [dic setValue:RowID forKey:@"classID"];
        [dic setValue:@"" forKey:@"lastTime"];
        [dic setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
        [dic setValue:[NSString stringWithFormat:@"%d",itemLabel] forKey:@"PageSize"];
        [serive PostFromURL:AGetVideosList params:dic mHttp:httpUrl isLoading:NO];
    }
    else
    {
        [mTableView.footer endRefreshingWithNoMoreData];
        [mTableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sizeHight+10;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"VideoViewCell"];
    if (cell==nil) {
        cell = [[VideoViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"VideoViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = bgColor;
        aTableView.showsVerticalScrollIndicator = NO;
    }
    if (fListArray.count != 0)
        [cell setEntity:[[VideoModel alloc] initWithDictionary:fListArray[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    ViedoDetialsViewController *vc = [[ViedoDetialsViewController alloc] init];
    vc.title = self.title;
    vc.dic = [fListArray objectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

