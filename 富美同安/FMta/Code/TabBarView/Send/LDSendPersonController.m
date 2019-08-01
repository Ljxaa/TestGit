//
//  LDSendPersonController.m
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "LDSendPersonController.h"
#import "Global.h"
#import "ToolCache.h"
#import "MJRefresh.h"

@implementation LDSendPersonController
@synthesize fListArray,mTableView,mSelectionUsers,delegate,deptName;
#define sizeHight 40
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

    fListArray = [[NSMutableArray alloc] init];
    [mTableView.header beginRefreshing];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneSelection)];
}

#pragma mark 完成返回
-(void)doneSelection
{
    if ([delegate respondsToSelector:@selector(doneSelect:)])
    {
        [delegate doneSelect:mSelectionUsers];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadNewData
{

    fListArray = [[NSMutableArray alloc] init];
    [self upDateTableView];
}


-(void)upDateTableView
{
    if (deptName == nil) {
        deptName = @"";
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:deptName forKey:@"dept"];
    [serive PostFromURL:AOAGetLeader params:dic mHttp:httpUrl isLoading:NO];
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AOAGetLeader])
    {
        if (dic != nil) {
            for (NSDictionary *DIC in dic[@"NewDataSet"][@"Table"])
            {
                [fListArray addObject:DIC];
            }
        }
        [mTableView reloadData];
        [mTableView.header endRefreshing];
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
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"LDSendController"];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"LDSendController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aTableView.showsVerticalScrollIndicator = NO;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(13.5, (sizeHight-22)/2, 22, 22)];
    [cell.contentView addSubview:bgImage];
    bgImage.image = [UIImage imageNamed:@"btn_fxk1"];

    for (NSDictionary *dic in mSelectionUsers)
    {
        if ([dic isEqualToDictionary:fListArray[indexPath.row]]) {
            bgImage.image = [UIImage imageNamed:@"btn_fxk2"];
            break;
        }
    }
    UILabel *t1Label = [[UILabel alloc] init];
    t1Label.frame = CGRectMake(50, 0, screenMySize.size.width-50,sizeHight);
    [t1Label setTextColor:[UIColor blackColor]];
    if (fListArray.count != 0) {
        t1Label.text = fListArray[indexPath.row][@"userName"][@"text"];
    }
    [t1Label setFont:[UIFont fontWithName:@"Arial" size:labelSize+1]];
    [t1Label setBackgroundColor:[UIColor clearColor]];
    [cell.contentView addSubview:t1Label];
    
    cell.backgroundColor = bgColor;

    UIImageView *lImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [lImageView setFrame:CGRectMake(10, sizeHight-2, screenMySize.size.width-20, 2)];
    [cell.contentView addSubview:lImageView];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (mSelectionUsers ==nil) {
        mSelectionUsers = [[NSMutableArray alloc] init];
    }
    BOOL isNot = NO;
    for (NSDictionary *dic in mSelectionUsers)
    {
        if ([dic isEqualToDictionary:fListArray[indexPath.row]]) {
            isNot  = YES;
            break;
        }
    }
    if (isNot) {
        [mSelectionUsers removeObject:fListArray[indexPath.row]];
    }
    else
        [mSelectionUsers addObject:fListArray[indexPath.row]];
    [tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
