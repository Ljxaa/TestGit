//
//  HYListController.m
//  同安政务
//
//  Created by _ADY on 16/1/6.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "HYListController.h"
#import "Global.h"
#import "ToolCache.h"
#import "MJRefresh.h"

@implementation HYListController
@synthesize mTableView,fListArray,RowID,delegate;
#define sizeHight 40
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
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
//        [dic setValue:[wfSubCodeArray objectAtIndex:1] forKey:@"classID"];
        [dic setValue:[wfSubCodeDic objectForKey:@"会议管理"] forKey:@"classID"];
        [dic setValue:@"" forKey:@"lastTime"];
        [dic setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
        [dic setValue:[NSString stringWithFormat:@"%d",itemLabel] forKey:@"PageSize"];
        
        [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
        
        
    }
    else
    {
        [mTableView.footer endRefreshingWithNoMoreData];
        [mTableView reloadData];
    }
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetPerPhotoList])
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sizeHight;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"HYListController"];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"HYListController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aTableView.showsVerticalScrollIndicator = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    cell.textLabel.text = fListArray[indexPath.row][@"Title"];
    cell.backgroundColor = bgColor;
    if (indexPath.row+1 != fListArray.count) {
        UIImageView *lImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [lImageView setFrame:CGRectMake(10, sizeHight-2, screenMySize.size.width-20, 2)];
        [cell.contentView addSubview:lImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary *dic = fListArray[indexPath.row];
    NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:dic[@"Content"]];
    [delegate HYAction:imageUrlArray];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
