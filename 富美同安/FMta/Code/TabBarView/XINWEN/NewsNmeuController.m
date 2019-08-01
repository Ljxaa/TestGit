//
//  NewsNmeuController.m
//  同安政务
//
//  Created by _ADY on 16/1/19.
//  Copyright © 2016年 _ADY. All rights reserved.
//


#import "NewsNmeuController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "ToolCache.h"
#import "DetialsViewController.h"
#import "NewMenuItem.h"

@implementation NewsNmeuController
@synthesize mTableView,RowID,isChild_Page;
#define imageHieght screenMySize.size.width*9/16
#define viewCHieght 38
#define tableTag 100
#define imageTag 2000
#define TableHight 64

@synthesize isOther_Page;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    notImage = YES;
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    tabView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, screenMySize.size.width-80, viewCHieght)];
    [self.navigationItem setTitleView:tabView];
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_add"] landscapeImagePhone:[UIImage imageNamed:@"menu_add_press"]style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];
    
    
    allArray = [NSMutableDictionary dictionaryWithCapacity:10];
    ImageArray = [NSMutableDictionary dictionaryWithCapacity:10];
    pageNumber = [NSMutableDictionary dictionaryWithCapacity:10];
    
    whatNum = 0;
    //    [self goToSetTitle];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 37*.75, 34*.75)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self performSelector:@selector(goToSetTitle) withObject:nil afterDelay:0.1f];
}

-(void)goToSetTitle
{
    if ([self.title isEqualToString:@"视频新闻"]) {
        [serive GetFromURL:AGetVideosClassList params:nil mHttp:httpUrl isLoading:NO];
        return;
    }
    if ([self.title isEqualToString:[menuArray objectAtIndex:5]]||[self.title isEqualToString:@"工作手册"]||[self.title isEqualToString:@"政策采编"]||isChild_Page||[self.title isEqualToString:@"责任清单"]||[self.title isEqualToString:@"廉政参考"]||[self.title isEqualToString:@"机制体制"]) {
        
        notImage = NO;
    }
    arrayN = [self NewsClass];
    NSLog(@"qwewqe===%@,%@",self.title,RowID);
    if (1 || ![arrayN hash])
    {
        
        if ([self.title isEqualToString:@"工作手册"]||[self.title isEqualToString:@"责任清单"]||[self.title isEqualToString:@"廉政参考"]||[self.title isEqualToString:@"机制体制"]) {
            NSLog(@"aa");
            [serive GetFromURL:AGetKnowledgeBaseIdList params:nil mHttp:httpUrl isLoading:NO];
        }
        else if ([self.title isEqualToString:@"政策采编"]) {
            
            [serive GetFromURL:AGetzzcbList params:nil mHttp:httpUrl isLoading:NO];
        }
        else if (isChild_Page) {
            NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
            [postDic setObject:RowID  forKey:@"ParentID"];
            [serive PostFromURL:AGetDepartmentClassList params:postDic mHttp:httpUrl isLoading:NO];
            //            [serive GetFromURL:AGetDepartmentClassList params:nil mHttp:httpUrl isLoading:NO];
        }
        else
            [serive GetFromURL:AGetTodayList params:nil mHttp:httpUrl isLoading:NO];
        
    }else
        [self goToSetTitle1];
    
}

-(void)setNewsClass:(NSMutableArray*)array
{
    if (array == nil) {
        return;
    }
    [array archiveWithKey:[NSString stringWithFormat:@"NewsClass%@",self.title]];
    
}

-(NSMutableArray*)NewsClass
{
    return [NewMenuItem unarchiveWithKey:[NSString stringWithFormat:@"NewsClass%@",self.title]];
}

-(void)backAction
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetNewsList] ||[urlName isEqualToString:AGetVideosList]||[urlName isEqualToString:AOAGetLeader]||[urlName isEqualToString:AGetPerPhotoList])
    {
        if (dic != nil) {
            if (pageForNumber != 1) {
                NSMutableArray *myArray1 = [[NSMutableArray alloc] init];
                [myArray1 addObjectsFromArray:[allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]]];
                [myArray1 addObjectsFromArray:dic[@"DataList"]];
                
                [allArray setValue:myArray1 forKey:[NSString stringWithFormat:@"%d",whatNum]];
            }
            else
                [allArray setValue:dic[@"DataList"] forKey:[NSString stringWithFormat:@"%d",whatNum]];
            
            TotalCount = [dic[@"TotalCount"] intValue];
            if (notImage)
                [self isShow1];
        }
        UITableView *tableView = (UITableView*)[self.view viewWithTag:tableTag+whatNum];
        [tableView reloadData];
        [tableView.header endRefreshing];
        [tableView.footer endRefreshing];
    }
    if ([urlName isEqualToString:AGetTodayList]||[urlName isEqualToString:AGetKnowledgeBaseIdList]||[urlName isEqualToString:AGetzzcbList]||[urlName isEqualToString:AGetDepartmentClassList] || [urlName isEqualToString:AGetVideosClassList]) {
        if (dic != nil) {
            NSMutableArray *dicc = [[NSMutableArray alloc] initWithCapacity:10];
            for (NSDictionary *d in dic) {
                [dicc addObject:d];
            }
            
            if (dicc.count != 0) {
                [self setNewsClass:dicc];
                arrayN = [self NewsClass];
                [self goToSetTitle1];
            }
            
        }
    }
}

-(void)goToSetTitle1
{
    //只有一个选项的时候不现实滑动scrollview
    if (arrayN.count == 1) {
        [self.navigationItem setTitleView:nil];
    }
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    NSString *arrayString = nil;
    for (int i = 0; i <arrayN.count; i ++)
    {
        NSMutableDictionary *dic = [arrayN objectAtIndex:i];
        arrayString = [NSString stringWithFormat:@"%@ %@",arrayString,[dic objectForKey:@"ClassName"]];
        [mArray addObject:[dic objectForKey:@"ClassName"]];
    }
    
    scrollViewWidth =  [ToolCache setString:arrayString setSize:labelSize setWight:5];
#warning 顶部数量太少，分隔的太大
    if (scrollViewWidth <= screenMySize.size.width+20) {
        scrollViewWidth = screenMySize.size.width-80;
    }
#warning end
    if (tScrollView !=nil)
    {
        [tScrollView removeFromSuperview];
        tScrollView =nil;
    }
    
    tScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, tabView.frame.size.width, viewCHieght+12)];
    [tScrollView setDelegate:self];
    [tScrollView setPagingEnabled:NO];
    [tScrollView setShowsHorizontalScrollIndicator:NO];
    tScrollView.backgroundColor = [UIColor clearColor];
    [tabView addSubview:tScrollView];
    
    
    [tScrollView setContentSize:CGSizeMake(scrollViewWidth, 0)];
    
    
    if (gScrollView != nil) {
        [gScrollView removeFromSuperview];
        gScrollView =nil;
    }
    
    gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenMySize.size.width, screenMySize.size.height-TableHight)];
    [gScrollView setDelegate:self];
    [gScrollView setPagingEnabled:YES];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:gScrollView];
    
    if (isOther_Page) {
        notImage = NO;
        NSLog(@"qqq===%@,%@",RowID,self.title);
        [gScrollView setContentSize:CGSizeMake(screenMySize.size.width, 0)];
    }else{
        [gScrollView setContentSize:CGSizeMake(screenMySize.size.width*arrayN.count, 0)];
    }
    
    
    
    if (segmentedControl != nil) {
        [segmentedControl removeFromSuperview];
        segmentedControl =nil;
    }
    segmentedControl = [[CCSegmentedControl alloc] initWithItems:mArray];
    segmentedControl.frame = CGRectMake(0,0, scrollViewWidth, viewCHieght);
    segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_press2.png"]];
    segmentedControl.selectedSegmentTextColor = [UIColor colorWithRed:252/255.0 green:177/255.0 blue:80/255.0 alpha:1];
    segmentedControl.segmentTextColor = [UIColor whiteColor];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.aBool = YES;
    [tScrollView addSubview:segmentedControl];
    
    [self performSelector:@selector(tableShow) withObject:nil afterDelay:.1];
}

-(void)tableShow
{
    UITableView *tableView = (UITableView*)[self.view viewWithTag:tableTag+whatNum];
    if (tableView == nil) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenMySize.size.width*whatNum,0, screenMySize.size.width, screenMySize.size.height-TableHight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag =tableTag+whatNum;
        tableView.backgroundColor = [UIColor clearColor];
        [gScrollView addSubview:tableView];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
        [tableView setTableFooterView:v];
        
        
        __weak __typeof(self) weakSelf = self;
        
        tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
        }];
        tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
        BOOL isSure = NO;
        if (allArray.count > whatNum) {
            NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
            if (fListArray.count > 0) {
                isSure = YES;
            }
        }
        if (!isSure)
        {
            pageForNumber = 1;
            [pageNumber setObject:[NSString stringWithFormat:@"%d",pageForNumber] forKey:[NSString stringWithFormat:@"%d",whatNum]];
            [tableView.header beginRefreshing];
        }
        
    }
    [tableView reloadData];
    pageForNumber = [[pageNumber objectForKey:[NSString stringWithFormat:@"%d",whatNum]] intValue];
}

-(void)reMoveTable
{
    for (int i = 0 ; i < arrayN.count; i ++) {
        
        if (i+1 != whatNum &&i != whatNum &&i-1 != whatNum) {
            UITableView *tableView = (UITableView*)[self.view viewWithTag:tableTag+i];
            [tableView removeFromSuperview];
            tableView = nil;
        }
        
    }
    
}
-(void)isShow
{
    NSMutableArray *myArray1 = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    NSMutableArray *ImageA = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < myArray1.count; i++)
    {
        NSMutableDictionary *dictionary = [myArray1 objectAtIndex:i];
        if ([[dictionary objectForKey:@"IsScroll"] intValue] == 1) {
            [ImageA addObject:dictionary];
        }
    }
    
    //排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"PublishDate" ascending:NO]];
    [ImageA sortUsingDescriptors:sortDescriptors];
    
    [ImageArray setValue:ImageA forKey:[NSString stringWithFormat:@"%d",whatNum]];
    IsScroll = 0;
    if ([[ImageArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]] count] > 0) {
        IsScroll = 1;
    }
}
- (void)valueChanged:(id)sender
{
    CCSegmentedControl* segmentedControl1 = sender;
    
    whatNum = (unsigned int)segmentedControl1.selectedSegmentIndex;
    [self reMoveTable];
    [self goScrollViewMove];
    [self isShow];
    [gScrollView setContentOffset:CGPointMake(screenMySize.size.width*whatNum, 0) animated:YES];
    [self tableShow];
}

-(void)goScrollViewMove
{
    if (scrollViewWidth <= screenMySize.size.width+20) {
        return;
    }
    NSString *arrayString = nil;
    for (int i = 0; i <whatNum; i ++)
    {
        NSMutableDictionary *dic = [arrayN objectAtIndex:i];
        arrayString = [NSString stringWithFormat:@"%@ %@",arrayString,[dic objectForKey:@"ClassName"]];
    }
    int scrollViewWidth1 =  [ToolCache setString:arrayString setSize:labelSize setWight:5];
    
    if (whatNum == 0)
    {
        scrollViewWidth1 = screenMySize.size.width/2;
    }
    [tScrollView setContentOffset:CGPointMake(scrollViewWidth1-screenMySize.size.width/2, 0) animated:YES];
}

#pragma mark -
#pragma mark Scroll View Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    if (aScrollView == gScrollView)
    {
        int page = floor((gScrollView.contentOffset.x - screenMySize.size.width / 2) / screenMySize.size.width)  + 1;
        whatNum = page;
        segmentedControl.selectedSegmentIndex = whatNum;
        [self goScrollViewMove];
        [self reMoveTable];
        [self isShow];
        [self performSelector:@selector(tableShow) withObject:nil afterDelay:.1];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)ReloadThe
{
    UITableView *tableView = (UITableView*)[self.view viewWithTag:tableTag+whatNum];
    [tableView.header beginRefreshing];
}

- (void)loadNewData
{
    pageForNumber = 1;
    //    fListArray = [[NSMutableArray alloc] init];
    [self upDateTableView];
}

- (void)loadMoreData
{
    pageForNumber = [[pageNumber objectForKey:[NSString stringWithFormat:@"%d",whatNum]] intValue];
    pageForNumber++;
    
    [self upDateTableView];
}

-(void)upDateTableView
{
    NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    [pageNumber setObject:[NSString stringWithFormat:@"%d",pageForNumber] forKey:[NSString stringWithFormat:@"%d",whatNum]];
    if ((pageForNumber-1)*itemLabel <= [fListArray count]||pageForNumber ==1)
    {
        NSMutableDictionary *dicN = [arrayN objectAtIndex:whatNum];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[ToolCache userKey:kDeviceToken] forKey:@"IMEINO"];
        [dic setValue:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
        [dic setValue:dicN[@"RowID"] forKey:@"classID"];
        [dic setValue:@"" forKey:@"lastTime"];
        
        [dic setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
        [dic setValue:[NSString stringWithFormat:@"%d",itemLabel] forKey:@"PageSize"];
        
        if ([self.title isEqualToString:[menuArray objectAtIndex:6]]) {
            [serive PostFromURL:AGetVideosList params:dic mHttp:httpUrl isLoading:NO];
        }
        else if ([self.title isEqualToString:@"工作手册"]||[self.title isEqualToString:@"责任清单"]||[self.title isEqualToString:@"廉政参考"]||[self.title isEqualToString:@"机制体制"])
        {
            [dic setValue:@"" forKey:@"TabClass"];
            if ([self.title isEqualToString:@"责任清单"]||[self.title isEqualToString:@"廉政参考"]||[self.title isEqualToString:@"机制体制"]) {
                [dic setValue:RowID forKey:@"classID"];
            }
            
            [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
        }else if ([self.title isEqualToString:@"视频新闻"]){
            [serive PostFromURL:AGetVideosList params:dic mHttp:httpUrl isLoading:NO];
            
        }else
            [serive PostFromURL:AGetNewsList params:dic mHttp:httpUrl isLoading:NO];
        
    }
    else
    {
        UITableView *tableView = (UITableView*)[self.view viewWithTag:tableTag+whatNum];
        [tableView.footer endRefreshingWithNoMoreData];
        [tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *myArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    if (notImage) {
        return myArray.count%8+((int)(myArray.count/8))*6+IsScroll;
    }
    return myArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!notImage)
    {
        if ([self.title isEqualToString:@"政策采编"]||isChild_Page) {
            return sizeHight+10;
        }
        return 40;
    }
    if (IsScroll == 1 &&indexPath.row == 0) {
        return imageHieght;
    }
    return sizeHight+10;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    if (notImage)
    {
        NSMutableDictionary *dic = [arrayN objectAtIndex:whatNum];
        if ([[NSString stringWithFormat:@"%@",dic[@"Type"]] isEqualToString:@"<null>"]) {
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
            NSMutableArray *imageFArray = [ImageArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
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
        }else{
            //#warning 此处修改（type＝1时显示“效能通报”形式的列表）
            NewsTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell2"];
            
            if (cell==nil)
            {
                cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"NewsTableViewCell2"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                cell.backgroundColor = bgColor;
                aTableView.showsVerticalScrollIndicator = NO;
            }
            if (fListArray.count != 0)
                [cell setEntity:[[NewsModel alloc] initWithDictionary:fListArray[indexPath.row]] setSource:YES];
            return cell;
        }
    }
    else if ([self.title isEqualToString:@"政策采编"]||isChild_Page) {
        NewsTableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell2"];
        
        if (cell==nil)
        {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:@"NewsTableViewCell2"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            cell.backgroundColor = bgColor;
            aTableView.showsVerticalScrollIndicator = NO;
        }
        if (fListArray.count != 0)
            [cell setEntity:[[NewsModel alloc] initWithDictionary:fListArray[indexPath.row]] setSource:YES];
        return cell;
    }
    else
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
        cell.backgroundColor = [UIColor whiteColor];
        if (((int)indexPath.row)%2 != 0) {
            cell.backgroundColor = [UIColor colorWithRed:241/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        }
        
        NewsModel *entity = [[NewsModel alloc] initWithDictionary:fListArray[indexPath.row]];
        //#warning 此处修改（显示类别）
        NSString *arrayString;
        for (NSDictionary *d in arrayN) {
            if ([d[@"RowID"] intValue]==[entity.ClassId intValue]) {
                arrayString = [NSString stringWithFormat:@"%@",d[@"ClassName"]];
                break;
            }
        }
        
        UILabel *Label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, screenMySize.size.width-105, 40)];
        Label.textAlignment = 0;
        Label.font = [UIFont fontWithName:@"Arial" size:labelSize];
        Label.textColor = [UIColor blackColor];
        [cell.contentView addSubview:Label];
        
        UILabel *Label1 = [[UILabel alloc] initWithFrame:CGRectMake(screenMySize.size.width-100, 0, 95, 40)];
        Label1.font = [UIFont fontWithName:@"Arial" size:labelSize-3];
        Label1.textColor = [UIColor grayColor];
        [cell.contentView addSubview:Label1];
        if (isOther_Page) {
            Label.text = [NSString stringWithFormat:@"%@",entity.title];
        }else{
            Label.text = [NSString stringWithFormat:@"%@:%@",arrayString,entity.title];
        }
        
        Label1.text = [NSString stringWithFormat:@"(%@)",[entity.time substringToIndex:10]];
        
        return cell;
    }
    
}

-(int)setType:(int)taype
{
    int indexT = (int)(taype%6+(taype/6)*8);
    NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    if (indexT >= fListArray.count) {
        indexT = indexT -2;
    }
    return indexT;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
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
    NSMutableArray *fListArray = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    NSMutableArray *imageFArray = [ImageArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    if ([self.title isEqualToString:@"视频新闻"] || [self.title isEqualToString:[menuArray objectAtIndex:6]])
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

-(void)isShow1
{
    
    NSMutableArray *myArray1 = [allArray objectForKey:[NSString stringWithFormat:@"%d",whatNum]];
    NSMutableArray *ImageA = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < myArray1.count; i++)
    {
        NSMutableDictionary *dictionary = [myArray1 objectAtIndex:i];
        if ([[dictionary objectForKey:@"IsScroll"] intValue] == 1) {
            [ImageA addObject:dictionary];
        }
    }
    
    //排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"PublishDate" ascending:NO]];
    [ImageA sortUsingDescriptors:sortDescriptors];
    
    [ImageArray setValue:ImageA forKey:[NSString stringWithFormat:@"%d",whatNum]];
    
    IsScroll = 0;
    if (ImageA.count > 0 && NewsViews == nil) {
        NewsViews = [[NewsView alloc] initWithFrame:CGRectMake(0,0, screenMySize.size.width, imageHieght)];
        NewsViews.delegate = self;
        IsScroll = 1;
    }
    if (ImageA.count > 0) {
        IsScroll = 1;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

