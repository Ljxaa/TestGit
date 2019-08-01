//
//  NewsViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "NewsViewController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "ToolCache.h"
#import "DetialsViewController.h"

@implementation NewsViewController
@synthesize mTableView,fListArray,RowID,imageFArray;
#define imageHieght screenMySize.size.width*9/16
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    notImage = YES;
    if ([self.title isEqualToString:@"效能通报"]) {
        notImage = NO;
    }
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
    IsScroll = 0;
    fListArray = [[NSMutableArray alloc] init];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 37*.75, 34*.75)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self performSelector:@selector(beginReflash) withObject:nil afterDelay:0.1f];
}
- (void)beginReflash{
    if ([self.title isEqualToString:@"廉政参考"]||[self.title isEqualToString:@"责任清单"]) {
        notImage = NO;
    }
    [mTableView.header beginRefreshing];
}
-(void)backAction
{
    if ([self.title isEqualToString:@"效能通报"]||[self.title isEqualToString:@"视频新闻"]) {
      [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    }
    else
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetNewsList] ||[urlName isEqualToString:AGetVideosList])
    {
        if (dic != nil) {
            [fListArray addObjectsFromArray:dic[@"DataList"]];
             TotalCount = [dic[@"TotalCount"] intValue];
            if (notImage)
                [self isShow];
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
        
        if ([self.title isEqualToString:@"视频新闻"]) {
          [serive PostFromURL:AGetVideosList params:dic mHttp:httpUrl isLoading:NO];
        }
        else
            [serive PostFromURL:AGetNewsList params:dic mHttp:httpUrl isLoading:NO];
        
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
    if (notImage) {
     return fListArray.count%8+((int)(fListArray.count/8))*6+IsScroll;
    }
    return fListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IsScroll == 1 &&indexPath.row == 0) {
        return imageHieght;
    }
    return sizeHight+10;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (notImage)
    {
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
        
        if (cell==nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"NewsTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = bgColor;
            aTableView.showsVerticalScrollIndicator = NO;
        }
        int i = (int)[[cell.contentView subviews] count] - 1;
        for(;i >= 0 ; i--)
        {
            [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
        }
        if (indexPath.row == 0 && IsScroll == 1) {
            [cell.contentView addSubview:NewsViews];
            [NewsViews setDic:imageFArray];
        }
        else
        {
            int indexT = [self setType:(int)indexPath.row-IsScroll];
            
            if ((indexPath.row-IsScroll+1)%6 == 0 &&((indexPath.row-IsScroll+1)*8/6)<=fListArray.count)
                for (int i = 0; i < 3; i ++) {
                    [NewsTableViewCell setImageCell:cell data:[[NewsModel alloc] initWithDictionary:fListArray[indexT+i]] forI:i];
                    
                    UIButton *inButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [inButton setFrame:CGRectMake(10+(screenMySize.size.width-20)*i/3,0, (screenMySize.size.width-20)/3,sizeHight+10)];
                    inButton.tag =indexT+i;
                    [inButton addTarget:self action:@selector(inPAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:inButton];
                }
            
            else
                [NewsTableViewCell setImageCell:cell data:[[NewsModel alloc] initWithDictionary:fListArray[indexT]]];
        }

        return cell;
    }
    else
    {
        NewsTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
        
        if (cell==nil)
        {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"NewsTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = bgColor;
            aTableView.showsVerticalScrollIndicator = NO;
        }
        if (fListArray.count != 0)
            [cell setEntity:[[NewsModel alloc] initWithDictionary:fListArray[indexPath.row]]setSource:NO];
        return cell;
    }

}

-(int)setType:(int)taype
{
    int indexT = (int)(taype%6+(taype/6)*8);
    if (indexT >= fListArray.count) {
        indexT = indexT -2;
    }
    return indexT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
     if (notImage)
     {
         if (indexPath.row == 0 && IsScroll == 1) {
         }
         else
         {
             if ((indexPath.row-IsScroll+1)%6 == 0 &&((indexPath.row-IsScroll+1)*8/6)<=fListArray.count)
             {
                 return;
             }
             [self setAcionPush:[self setType:(int)indexPath.row-IsScroll] setIsScroll:NO];
         }

     }
    else
        [self setAcionPush:(int)indexPath.row setIsScroll:NO];

}

-(void)inPAction:(UIButton*)setTag
{
    [self setAcionPush:(int)setTag.tag setIsScroll:NO];
}

-(void)setAcionPush:(int)indexT setIsScroll:(BOOL)isShow
{
   if ([self.title isEqualToString:@"视频新闻"])
   {
       ViedoDetialsViewController *vc = [[ViedoDetialsViewController alloc] init];
       vc.title = self.title;
       if (isShow) {
           vc.dic = [imageFArray objectAtIndex:indexT];
       }
       else
           vc.dic = [fListArray objectAtIndex:indexT];
       vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
   }
    else
    {
        DetialsViewController *vc = [[DetialsViewController alloc] init];
        vc.title = self.title;
        vc.RowID = RowID;
        if (isShow) {
            vc.dic = [imageFArray objectAtIndex:indexT];
        }
        else
            vc.dic = [fListArray objectAtIndex:indexT];
        vc.num = indexT+1;
        vc.TotalCount = TotalCount;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)inAction:(int)aTag
{
    [self setAcionPush:aTag setIsScroll:YES];
}

-(void)isShow
{
    imageFArray = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < fListArray.count; i++)
    {
        NSMutableDictionary *dictionary = [fListArray objectAtIndex:i];
        if ([[dictionary objectForKey:@"IsScroll"] intValue] == 1) {
            [imageFArray addObject:dictionary];
        }
    }
    //排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"PublishDate" ascending:NO]];
    [imageFArray sortUsingDescriptors:sortDescriptors];
    
    IsScroll = 0;

    if ([imageFArray count] > 0) {
        IsScroll = 1;
    }
    
    if (imageFArray.count > 0 && NewsViews == nil) {
        NewsViews = [[NewsView alloc] initWithFrame:CGRectMake(0,0, screenMySize.size.width, imageHieght)];
        NewsViews.delegate = self;
        IsScroll = 1;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
