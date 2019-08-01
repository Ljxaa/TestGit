//
//  GroupUserViewController.m
//  厦门信息集团
//
//  Created by _ADY on 15-3-30.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import "GroupUserViewController.h"
#import "SelectedViewController.h"
#import "ContactInfoViewController.h"
#import "UsedItem.h"
#import "GroupsMenu.h"
#import "GroupUsersMenu.h"
#import "UsersMenu.h"
#import "ToolCache.h"
#import "Global.h"
#import "RequestSerive.h"

@interface GroupUserViewController (){
    NSInteger selectGroupID;
}

@end


#define tableViewTag 100
#define LabelHight 40*(iPadOrIphone)
#define contactButtonWight 80*(iPadOrIphone)
#define mViewColor [UIColor colorWithRed:0/255.0 green:94/255.0 blue:159/255.0 alpha:1]
@implementation GroupUserViewController
@synthesize isMultChoose,mSelectionUsers,delegate,ChooseUserFilter, ChooseUserFilterKey,groupBy;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"通讯录";
        isMultChoose = YES;
        mGroupArray = [[NSMutableArray alloc] init];
        mContactArray = [[NSMutableArray alloc] init];
        mSelectionUsers = [[NSMutableArray alloc] init];
        mCurrentGroups = [[NSMutableArray alloc] init];
        ccGroupArray = [[NSMutableArray alloc] init];
        ccArray = [[NSMutableArray alloc] init];
        gzArray = [[NSMutableArray alloc] init];
        ssArray = [[NSMutableArray alloc] init];
        mSearchResults = [[NSMutableArray alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectGroupID=1;//选部门时纪录用
    
    [ToolCache customViewDidLoad];
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if (self.delegate != nil)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneSelection)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查看已选" style:UIBarButtonItemStyleBordered target:self action:@selector(viewSelected)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"短信群发" style:UIBarButtonItemStyleBordered target:self action:@selector(qunfaPressed:)];
        
    }
    
    ccsType = 0;
    
    UIView *mHeaderView  = [[UIView alloc] init];
    [mHeaderView setFrame:CGRectMake(0, 0, self.view.bounds.size.width, LabelHight)];
    mHeaderView.backgroundColor = mViewColor;
    [self.view addSubview:mHeaderView];
    
    if (groupBy == 3) {
            segmentedControl = [[CCSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" 通讯录 ", nil]];
    }
    else
        segmentedControl = [[CCSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@" 通讯录 ",@"  关注  ",@"  搜索  ", nil]];
    if ((iPadOrIphone) == 2) {
        segmentedControl.frame = CGRectMake(10, LabelHight/8, self.view.bounds.size.width*1.6, LabelHight*3/4);
    }
    else
        segmentedControl.frame = CGRectMake(10, LabelHight/8, self.view.bounds.size.width, LabelHight*3/4);
    segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inner_tab_bg1.png"]];
    segmentedControl.selectedSegmentTextColor = mViewColor;
    segmentedControl.segmentTextColor = [UIColor whiteColor];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    mHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mHeaderButton setFrame:CGRectMake(0, LabelHight, screenMySize.size.width, LabelHight)];
    [mHeaderButton setBackgroundColor:[UIColor grayColor]];
    [mHeaderButton addTarget:self action:@selector(mBackGroupButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mHeaderButton];
    
    mHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, LabelHight)];
    mHeaderLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
    mHeaderLabel.textAlignment = 0;
    mHeaderLabel.backgroundColor = [UIColor clearColor];
    mHeaderLabel.textColor = [UIColor blackColor];
    [mHeaderButton addSubview:mHeaderLabel];
    
    cLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, LabelHight)];
    cLabel.backgroundColor = [UIColor clearColor];
    [cLabel setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
    cLabel.text = TXLText;
    cLabel.alpha = 0;
    cLabel.textAlignment = 0;
    cLabel.textColor= [UIColor blackColor];
    [mHeaderButton addSubview:cLabel];
    
    
    
    gzBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gzBuuton setFrame:CGRectMake(screenMySize.size.width-50*(iPadOrIphone), LabelHight,40*(iPadOrIphone), LabelHight)];
    [gzBuuton setBackgroundColor:[UIColor grayColor]];
//    [gzBuuton setTitle:@"刷新" forState:UIControlStateNormal];
    [gzBuuton setBackgroundImage:[UIImage imageNamed:@"xuanzhuan.png.png"] forState:UIControlStateNormal];
    gzBuuton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [gzBuuton addTarget:self action:@selector(gotoShua) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gzBuuton];
    gzBuuton.alpha = 1;
    
    mSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, LabelHight)];
    mSearchBar.delegate = self;
    mSearchBar.barStyle = UIBarStyleDefault;
    mSearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    mSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    mSearchBar.placeholder = (@"搜索联系人");
    mSearchBar.keyboardType =  UIKeyboardTypeDefault;
    [mHeaderButton addSubview:mSearchBar];
    mSearchBar.alpha = 0;
    
    
    aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, LabelHight*2, screenMySize.size.width, self.view.bounds.size.height-LabelHight*2-64)];
    aTableView.delegate = self;
    aTableView.dataSource = self;
    aTableView.backgroundColor = bgColor;
    [self.view addSubview:aTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [aTableView setTableFooterView:v];
    
    [self queryGroupUsers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treatedATask) name:@"tongxunlu" object:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            if (ccsType == 0)
            {
                [self goToTXL];
            }
            else
                [self AttachInt];
        }
    }
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetGroups])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
        NSMutableArray *mSarray = [[NSMutableArray alloc] init];
        for (NSDictionary*  ct in array)
        {
            NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
            for(NSString *key in [ct allKeys])
            {
                [aCt setValue:ct[key][@"text"] forKey:key];
            }
            [mSarray addObject:aCt];
        }
        [mSarray archiveWithKey:@"GroupsMenu"];
    }
   else if ([urlName isEqualToString:AGetUsers])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
        NSMutableArray *mSarray = [[NSMutableArray alloc] init];
        for (NSDictionary*  ct in array)
        {
            NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
            for(NSString *key in [ct allKeys])
            {
               [aCt setValue:ct[key][@"text"] forKey:key];
            }
            [mSarray addObject:aCt];
        }
        [mSarray archiveWithKey:@"UsersMenu"];
    }
    else if ([urlName isEqualToString:AGetGroupUsers])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
        NSMutableArray *mSarray = [[NSMutableArray alloc] init];
        for (NSDictionary*  ct in array)
        {
            NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
            for(NSString *key in [ct allKeys])
            {
                [aCt setValue:ct[key][@"text"] forKey:key];
            }
            [mSarray addObject:aCt];
        }
        [mSarray archiveWithKey:@"GroupUsersMenu"];
        [RequestSerive alerViewMessage:mAddressSuccessful];
        [self loadGroupsDB];
    }
    else
    {
        [RequestSerive alerViewMessage:mAddressFailure];
    }
}

-(void)goToTXL
{
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    [serive GetFromURL:AGetGroups params:nil mHttp:OA_URL isLoading:YES];
    [serive GetFromURL:AGetUsers params:nil mHttp:OA_URL isLoading:NO];
    [serive GetFromURL:AGetGroupUsers params:nil mHttp:OA_URL isLoading:NO];

}

-(void)AttachInt
{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSDictionary *dic = [SendService getPersonalContacts:[SendService userAccount]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (dic != nil)
//            {
//                NSArray *array = [dic objectForKey:@"Togetherwork"];
//                
//                NSMutableArray *mSarray = [[NSMutableArray alloc] init];
//                for (NSDictionary*  ct in array)
//                {
//                    NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
//                    [aCt setValue:[[ct objectForKey:@"SetName"] objectForKey:@"text"] forKey:@"SetName"];
//                    [aCt setValue:[[ct objectForKey:@"SelectText"] objectForKey:@"text"] forKey:@"GPLD_UserDspName"];
//                    [aCt setValue:[[ct objectForKey:@"SelectValue"] objectForKey:@"text"] forKey:@"GPLD_User"];
//                    [aCt setValue:[[ct objectForKey:@"UserTitle"] objectForKey:@"text"] forKey:@"USER_Title"];
//                    [mSarray addObject:aCt];
//                }
//                [mSarray archiveWithKey:[NSString stringWithFormat:@"%@usedItem",[SendService userAccount]]];
//
//                [self setCCGroup];
//            }
//        });
//    });
}

#pragma mark 获取常用数据
-(void)gotoShua
{
    if (ccsType == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mGATo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 100;
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mGTo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 100;
        [alert show];
    }
}
#pragma mark 同步已选列表数据
-(void)treatedATask
{
    [mSelectionUsers removeAllObjects];
    [mSelectionUsers addObjectsFromArray:saveArray];
    [self checkMove];
}
#pragma mark 列表切换
-(void)valueChanged:(id)sender
{
    CCSegmentedControl* segmentedControl1 = sender;
    ccsType = (unsigned int)segmentedControl1.selectedSegmentIndex;
    if (ccsType >=1) {//屏蔽 常用功能
        ccsType++;
    }
    cLabel.alpha = 0;
    mSearchBar.alpha = 0;
    gzBuuton.alpha = 0;
    mHeaderLabel.alpha = 0;
    aTableView.frame = CGRectMake(0, LabelHight*2, screenMySize.size.width, self.view.bounds.size.height-LabelHight*2);
    if (ccsType == 0)
    {
        gzBuuton.alpha = 1;
        mHeaderLabel.alpha = 1;
        [aTableView reloadData];
    }
    else if (ccsType == 1) {
        cLabel.alpha = 1;
        gzBuuton.alpha = 1;
        [aTableView reloadData];
        
        if ([UsedItem unarchiveWithKey:[NSString stringWithFormat:@"%@usedItem",[ToolCache userKey:kAccount]]])
        {
            [self setCCGroup];

        }
        [self AttachInt];

    }
    else if (ccsType == 2)
    {
        aTableView.frame = CGRectMake(0, LabelHight, screenMySize.size.width, self.view.bounds.size.height-LabelHight);
        [self upDateGz];
    }
    else if (ccsType == 3)
    {
        mSearchBar.alpha = 1;
        [self upDateSous];
    }
}
#pragma mark 关注同步
-(void)upDateGz
{
    [gzArray removeAllObjects];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[ToolCache userKey:kAccount]]];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if (remData.count > 0)
    {
        [gzArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
        
        for (int i = 0; i < remData.count; i ++)
        {
            NSMutableDictionary *dic = [remData objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            [gzArray addObject:dic];
        }
    }
    [aTableView reloadData];
}

#pragma mark 搜索同步
-(void)upDateSous
{
    if (mSearchResults.count != 0)
    {
        [aTableView reloadData];
        return;
    }
    [ssArray removeAllObjects];
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1.plist",[ToolCache userKey:kAccount]]];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if (remData.count > 0)
    {
        [ssArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
        
        for (int i = (int)remData.count-1; i >= 0; i --)
        {
            NSMutableDictionary *dic = [remData objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            [ssArray addObject:dic];
        }
    }
    [aTableView reloadData];
}
#pragma mark 常用同步
-(void)setCCGroup
{
    for (NSDictionary *a in [UsedItem unarchiveWithKey:[NSString stringWithFormat:@"%@usedItem",[ToolCache userKey:kAccount]]])
    {
        if (ccGroupArray.count == 0) {
            [ccGroupArray addObject:a];
        }
        else
        {
            BOOL ab = YES;
            for (NSDictionary *b in ccGroupArray)
            {
                if ([[a objectForKey:@"SetName"] isEqualToString:[b objectForKey:@"SetName"]])
                {
                    ab = NO;
                    break;
                }
            }
            if (ab) {
                [ccGroupArray addObject:a];
            }
        }
    }
    [aTableView reloadData];
    
    return;
}
#pragma mark 同步通讯录
- (void)queryGroupUsers
{
    if ([[GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"] count] == 0)
    {
        [self goToTXL];
    }
    else
    {
        [self loadGroupsDB];
    }
}

#pragma mark 通讯录公司返回
-(void)goTomRetun
{
    if (mContactArray.count == 1)
    {
        return;
    }
    NSDictionary *temp = [mContactArray objectAtIndex:1];
    NSString *tString = [temp objectForKey:@"Group_ParentID"];
    if ([tString isEqualToString:@"0"])
    {
        return;
    }
    NSArray *chunks = [mHeaderLabel.text  componentsSeparatedByString:@"->"];
    if (chunks.count >= 2) {
        NSString *string = [chunks objectAtIndex:chunks.count-1];
        
        NSString *b = [mHeaderLabel.text substringToIndex:mHeaderLabel.text.length -string.length-2];
        
        mHeaderLabel.text = [NSString stringWithFormat:@"%@",b];
        
        mHeaderLabel.text = [mHeaderLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    
        NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
        NSDictionary *mTem = nil;
        for (NSDictionary *temp in array)
        {
            if ([temp[@"Group_Level"] isEqualToString:@"1"] &&[temp[@"Group_IsShow"] isEqualToString:@"1"]&&[temp[@"Group_ID"] isEqualToString:tString])
            {
                    mTem  = temp;
                    break;
            }
        }

    if (mTem)
    {
        [mGroupArray removeAllObjects];
        [mContactArray removeAllObjects];
//        if (array.count > 0)
//        {
//            [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
//        }
        for (NSMutableDictionary *temp1 in array)
        {
            if ([[temp1 objectForKey:@"Group_IsShow"] isEqualToString:@"1"] && [[temp1 objectForKey:@"Group_ParentID"] isEqualToString:[mTem objectForKey:@"Group_ParentID"]])
            {
                if ([self containsUser:temp1] != nil)
                {
                    [temp1 setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [temp1 setObject:@"0" forKey:@"check"];
                }
                [mContactArray addObject:temp1];
            }
        }
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Group_Code" ascending:YES]];
        [mContactArray sortUsingDescriptors:sortDescriptors];
        
        [aTableView reloadData];
        [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }

    
}
#pragma mark 通讯录加载公司分组判断
-(void)goToTheGS:(NSInteger)type
{
    
    NSDictionary *temp = [mContactArray objectAtIndex:type];
    
    if ([[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
    {
        [self checkIndex:0];
        return;
    }
    NSString *tString = [temp objectForKey:@"Group_ID"];
    BOOL NYES = NO;
    NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
    for (NSDictionary *temp in array)
    {
        if ([temp[@"Group_Level"] isEqualToString:@"1"] &&[temp[@"Group_IsShow"] isEqualToString:@"1"]&&[temp[@"Group_ParentID"] isEqualToString:tString])
        {
            NYES = YES;
            break;
        }
    }
    
    if (NYES)
    {
        if ([[temp objectForKey:@"Group_ParentID"] isEqualToString:@"0"])
            mHeaderLabel.text = [NSString stringWithFormat:@"%@",[temp objectForKey:@"Group_Name"]];
        else
            mHeaderLabel.text = [NSString stringWithFormat:@"%@->%@",mHeaderLabel.text,[temp objectForKey:@"Group_Name"]];
        mHeaderLabel.text = [mHeaderLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [mGroupArray removeAllObjects];
        [mContactArray removeAllObjects];
//        if (array.count > 0)
//        {
//            [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
//        }
        for (NSMutableDictionary *temp1 in array)
        {
            if ([[temp1 objectForKey:@"Group_IsShow"] isEqualToString:@"1"] && [[temp1 objectForKey:@"Group_ParentID"] isEqualToString:tString])
            {
                if ([self containsUser:temp1] != nil)
                {
                    [temp1 setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [temp1 setObject:@"0" forKey:@"check"];
                }

                [mContactArray addObject:temp1];
            }
        }
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Group_Code" ascending:YES]];
        [mContactArray sortUsingDescriptors:sortDescriptors];
        
        [aTableView reloadData];
        [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else
    {
//        [self checkIndex:type];
    }
}
#pragma mark 通讯录加载部门
-(void)getGroupBM:(int)parentID{

    [mGroupArray removeAllObjects];
    [mContactArray removeAllObjects];
    //    if (array.count > 0)
    //    {
    //        [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
    //    }

    NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
    for (NSMutableDictionary *temp in array)
    {
        if ([temp[@"Group_ParentID"] isEqualToString:[NSString stringWithFormat:@"%d",parentID]] &&[temp[@"Group_IsShow"] isEqualToString:@"1"])
        {
            if ([self containsUser:temp] != nil)
            {
                [temp setObject:@"1" forKey:@"check"];
            }
            else
            {
                [temp setObject:@"0" forKey:@"check"];
            }
            [mContactArray addObject:temp];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Group_Code" ascending:YES]];
    [mContactArray sortUsingDescriptors:sortDescriptors];
    
    [aTableView reloadData];
    [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark 通讯录加载公司
-(void)getGroupGS
{

    [mGroupArray removeAllObjects];
    [mContactArray removeAllObjects];
//    if (array.count > 0)
//    {
//        [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
//    }
    NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
    for (NSMutableDictionary *temp in array)
    {
        if ([temp[@"Group_Level"] isEqualToString:@"1"] &&[temp[@"Group_IsShow"] isEqualToString:@"1"]&&[temp[@"Group_ParentID"] isEqualToString:@"0"])
        {
            
            if ([self containsUser:temp] != nil)
            {
                [temp setObject:@"1" forKey:@"check"];
            }
            else
            {
                [temp setObject:@"0" forKey:@"check"];
            }
            [mContactArray addObject:temp];
        }
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Group_Code" ascending:YES]];
    [mContactArray sortUsingDescriptors:sortDescriptors];
    
    [aTableView reloadData];
    [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
#pragma mark 通讯录加载过滤
- (void)loadGroupsDB
{
    if (groupBy == 3)
    {
        
        [self getGroupBM:1];
        
//        NSString *groupId = nil;
        mHeaderLabel.text = TXLText;
        return;
    }
    [self getGroups];
    
    NSString *groupId = nil;

    mHeaderLabel.text = TXLText;

    if (mCurrentGroups.count <= 0)
    {
        groupId = groupID;
        if (self.ChooseUserFilterKey)
        {
            groupId = self.ChooseUserFilterKey;
        }
    }
    else
    {
        groupId = [[mCurrentGroups lastObject] objectForKey:@"Group_ID"];
        for (NSMutableDictionary *dic in mCurrentGroups)
        {
            mHeaderLabel.text = [NSString stringWithFormat:@"%@->%@", mHeaderLabel.text, [[dic objectForKey:@"Group_Name"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
    
     [mGroupArray removeAllObjects];
    
    //加载子分组
    NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
    for (NSMutableDictionary *temp in array)
    {
        if ([temp[@"Group_ParentID"] isEqualToString:groupId] &&[temp[@"Group_IsShow"] isEqualToString:@"1"])
        {
            if ([[temp objectForKey:@"Group_IsShow"] isEqualToString:@"1"])
            {
                if ([self.ChooseUserFilter isEqualToString:@"BMME"] || [self.ChooseUserFilter isEqualToString:@"CURBMLD"])
                {
                    BOOL ret = [mDeptments containsObject:[temp objectForKey:@"Group_ID"]];
                    if (ret)
                    {
                        [mGroupArray addObject:temp];
                    }
                }
                else if (([self.ChooseUserFilter isEqualToString:@"BMLD"] || [self.ChooseUserFilter isEqualToString:@"ABCD"]) && [groupId isEqualToString:@"1"])
                {
                    BOOL ret = [mDeptments containsObject:[temp objectForKey:@"Group_ID"]];
                    if (ret)
                    {
                        [mGroupArray addObject:temp];
                    }
                }
                else
                {
                    [mGroupArray addObject:temp];
                }
            }

        }
    }
    
    if (([[[mCurrentGroups lastObject] objectForKey:@"Group_Level"] isEqualToString:@"1"]&&mGroupArray.count!=0))
    {
        [mContactArray removeAllObjects];
        [self aTableViewData];
//        return;
    }
    
    if ([self.ChooseUserFilter isEqualToString:@"BMME"])
    {
        
    }
    else if ([self.ChooseUserFilter isEqualToString:@"CURBMLD"])
    {
        
    }
    else if ([self.ChooseUserFilter isEqualToString:@"BMLD"])
    {
        
    }
     if (self.ChooseUserFilter == nil)
     {
         if ([mHeaderLabel.text isEqualToString:TXLText]) {
             [mContactArray removeAllObjects];
             [self aTableViewData];
//             return;
         }
     }

    //加载分组人员
    [mContactArray removeAllObjects];
    array = [GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"GPLD_GroupID"] isEqualToString:groupId])
        {

            NSRange range = [dic[@"GPLD_UserDspName"] rangeOfString:@"管理"];//判断字符串是否包含

            if (range.length >0)
            {
                continue;
            }
            if (mContactArray.count == 0)
            {
                [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
            }
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            if ([self.ChooseUserFilter isEqualToString:@"CURBMLD"] || [self.ChooseUserFilter isEqualToString:@"JTLD"] || [self.ChooseUserFilter isEqualToString:@"BMLD"])
            {
                if ([[dic objectForKey:@"IsLeader"] boolValue])
                {
                    [mContactArray addObject:dic];
                }
            }
            else
            {
                [mContactArray addObject:dic];
            }
        }
    }

    [self aTableViewData];

}

#pragma mark 获取本人所在部门ID
- (NSMutableArray *)getDetpartments
{
    NSMutableArray *dpts = [[NSMutableArray alloc] init];
    
    NSArray *array = [GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"GPLD_User"] isEqualToString:[ToolCache userKey:kAccount]])
        {
            [dpts addObject:[dic objectForKey:@"GPLD_GroupID"]];
        }
    }

    return dpts;
}

#pragma mark 获取本人所在公司ID
- (NSMutableArray *)getGroups
{
    mDeptments = [[NSMutableSet alloc] init];
    
    NSMutableArray *goups = [[NSMutableArray alloc] init];
    NSMutableArray *array = [self getDetpartments];
    [mDeptments addObjectsFromArray:array];
    
    for (NSString *groupid in array)
    {
        NSString *temp = [self getGroup:groupid];
        if (temp !=nil)
            [goups addObject:temp];
    }
    return goups;
}

#pragma mark 递归获取部门所在的公司
- (NSString *)getGroup:(NSString *)dspId
{
    NSArray *array = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"Group_ID"] isEqualToString:dspId]&&[dic[@"Group_IsShow"] isEqualToString:@"1"])
        {
            NSString *Group_ParentID = [[array objectAtIndex:0] objectForKey:@"Group_ParentID"];
            [mDeptments addObject:Group_ParentID];
            if (![Group_ParentID isEqualToString:@"1"])
            {
                return [self getGroup:Group_ParentID];
            }
            NSString *groupId = [[array objectAtIndex:0] objectForKey:@"Group_ID"];
            [mDeptments addObject:groupId];
            return groupId;
        }
    }

    return nil;
}
#pragma mark TableView排序刷新
-(void)aTableViewData
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"Group_Code" ascending:YES]];
    [mGroupArray sortUsingDescriptors:sortDescriptors];

    [aTableView reloadData];
    [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark 判断已选是否存在 不存在check赋值0 存在check赋值1
- (NSMutableDictionary *)containsUser:(NSMutableDictionary *)dic
{
    for (NSMutableDictionary *temp in mSelectionUsers)
    {
        if (groupBy == 3) {
            if ([[temp objectForKey:@"Group_Name"] isEqualToString:[dic objectForKey:@"Group_Name"]])
            {
                return temp;
            }
        }
        else
        {
            if ([[temp objectForKey:@"GPLD_User"] isEqualToString:[dic objectForKey:@"GPLD_User"]])
            {
                return temp;
            }
        }
    }
    return nil;
}

#pragma mark 判断已选是否存在 不存在添加
- (void)addSelectUser:(NSMutableDictionary *)dic
{
    if (![self containsUser:dic])
    {
        [mSelectionUsers addObject:dic];
    }
}

#pragma mark 判断已选是否存在 已存在删除
- (void)removeUser:(NSMutableDictionary *)dic
{
    NSMutableDictionary *temp = [self containsUser:dic];
    if (temp != nil)
    {
        [mSelectionUsers removeObject:temp];
    }
}

#pragma mark 返回上级菜单响应事件
- (void)mBackGroupButton
{
    if (ccsType == 0)
    {
        if (groupBy == 3) {
            [self getGroupBM:1];
            selectGroupID=1;
            [mHeaderLabel setText:TXLText];
//            [self goTomRetun];
            return;
        }
        if (mCurrentGroups.count <= 0)
        {
            return;
        }
        [mCurrentGroups removeLastObject];
        [self loadGroupsDB];
    }
    else if (ccsType == 1)
    {
        [ccArray removeAllObjects];
        cLabel.text = TXLText;
        [aTableView reloadData];
    }

}

#pragma mark 完成返回
-(void)doneSelection
{
    if ([delegate respondsToSelector:@selector(doneSelection:)])
    {
        [delegate doneSelection:mSelectionUsers];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 查看已选
-(void)viewSelected
{
    SelectedViewController *vc = [[SelectedViewController alloc] init];
    vc.selectedSet = mSelectionUsers;
    vc.selectedGroupBy = groupBy;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 数据显示
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ccsType == 0)
        return mContactArray.count + mGroupArray.count;
    else if (ccsType == 1)
    {
        if (ccArray.count == 0)
            return ccGroupArray.count;
        else
            return ccArray.count;
    }
    else if (ccsType == 2)
        return gzArray.count;
    else if (ccsType == 3)
    {
        if (mSearchResults.count != 0)
            return mSearchResults.count;
        return ssArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ccsType == 2)
    {
        NSMutableArray *array = [self getUserAllJobName:[gzArray objectAtIndex:indexPath.row]];
        if (array.count == 0) {
            return LabelHight;
        }
        return LabelHight/2 + array.count*LabelHight/2;
    }
    else if (ccsType == 3)
    {
        if (mSearchResults.count != 0)
            return LabelHight;
        NSMutableArray *array = [self getUserAllJobName:[ssArray objectAtIndex:indexPath.row]];
        if (array.count == 0) {
            return LabelHight;
        }
        return LabelHight/2 + array.count*LabelHight/2;
    }
    return LabelHight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.showsVerticalScrollIndicator = YES;
    
    if (ccsType == 0)
    {
        if (indexPath.row < mContactArray.count)
        {
            return [self mCTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        else
        {
            return [self mGTableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    else if (ccsType == 1)
    {
        if (ccArray.count == 0)
            return [self mGTableView:tableView cellForRowAtIndexPath:indexPath];
        else
            return [self mCTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else if (ccsType == 2||ccsType == 3)
    {
        return [self mCTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark 组别
- (UITableViewCell *)mGTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font =[UIFont fontWithName:@"Arial" size:labelSize+1];
    
    if (ccsType == 0)
    {
        cell.textLabel.text = [[mGroupArray objectAtIndex:indexPath.row-mContactArray.count] objectForKey:@"Group_Name"];
    }
    else if (ccsType == 1)
    {
        cell.textLabel.text  = [[ccGroupArray objectAtIndex:indexPath.row] objectForKey:@"SetName"];
    }
    
    
    return cell;
}

#pragma mark 组别内容
- (UITableViewCell *)mCTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }

    NSMutableDictionary *dic = nil;
    
     if (ccsType == 0)
         dic = [mContactArray objectAtIndex:indexPath.row];
     else if (ccsType == 1)
        dic = [ccArray objectAtIndex:indexPath.row];
     else if (ccsType == 2)
         dic = [gzArray objectAtIndex:indexPath.row];
    else if (ccsType == 3)
    {
        if (mSearchResults.count != 0)
            dic = [mSearchResults objectAtIndex:indexPath.row];
        else
            dic = [ssArray objectAtIndex:indexPath.row];
    }
    
    int  labelJobHight = LabelHight/2;
    if (ccsType == 2 || (ccsType == 3&&mSearchResults.count == 0))
    {
        NSMutableArray *array = [self getUserAllJobName:dic];
        if (array.count != 0) {
            labelJobHight =  (int)array.count*LabelHight/2;
        }
    }
    
    if ([[dic objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
    {
        UILabel *t1Label = [[UILabel alloc] init];
        t1Label.frame = CGRectMake(40*(iPadOrIphone), 0, screenMySize.size.width-50*(iPadOrIphone), LabelHight) ;
        [t1Label setTextColor:[UIColor blackColor]];
        t1Label.text = @"全选";
        t1Label.textAlignment = 0;
        [t1Label setFont:[UIFont fontWithName:@"Arial" size:labelSize+1]];
        [t1Label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:t1Label];

    }
    else
    {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.backgroundColor = [UIColor clearColor];
        myButton.frame = CGRectMake(contactButtonWight, 0, screenMySize.size.width-contactButtonWight, LabelHight/2+labelJobHight);
        myButton.tag =indexPath.row+100;
        [myButton addTarget:self action:@selector(goInfo:) forControlEvents:UIControlEventTouchUpInside];
        if (groupBy!=3) {
            [cell.contentView addSubview:myButton];
        }
        
        UILabel *t1Label = [[UILabel alloc] init];
        t1Label.frame = CGRectMake(40*(iPadOrIphone), 0, screenMySize.size.width-50*(iPadOrIphone), LabelHight/2) ;
        [t1Label setTextColor:[UIColor blackColor]];
        if (groupBy == 3)
             t1Label.text = [dic objectForKey:@"Group_Name"];
        else
            t1Label.text = [self setUserPhone:dic];
        [t1Label setFont:[UIFont fontWithName:@"Arial" size:labelSize+1]];
        [t1Label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:t1Label];
        
        UILabel *t2Label = [[UILabel alloc] init];
        t2Label.numberOfLines = 0;
        t2Label.frame = CGRectMake(40*(iPadOrIphone), LabelHight/2, screenMySize.size.width-50*(iPadOrIphone),labelJobHight) ;
        [t2Label setTextColor:[UIColor grayColor]];
        if (ccsType == 2 ||(ccsType == 3&&mSearchResults.count == 0))
           t2Label.text = [self setUserAllJob:dic];
        else if (ccsType == 1)
            t2Label.text = [dic objectForKey:@"USER_Title"];
        else
            t2Label.text = [self setUserJob:dic];
        [t2Label setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        [t2Label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:t2Label];
        
        if (t2Label.text.length == 0) {
            t1Label.frame = CGRectMake(40*(iPadOrIphone), LabelHight/4, screenMySize.size.width-50*(iPadOrIphone), LabelHight/2) ;
        }
    }
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 0, contactButtonWight, LabelHight/2+labelJobHight);
    checkButton.tag = indexPath.row;
    [checkButton addTarget:self action:@selector(checkPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:checkButton];
    
    UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(13.5*(iPadOrIphone), (LabelHight/2+labelJobHight-22*(iPadOrIphone))/2, 22*(iPadOrIphone), 22*(iPadOrIphone))];
    [cell.contentView addSubview:bgImage];
    
    
    
    BOOL isCheck = [[dic objectForKey:@"check"] boolValue];
    if ([[dic objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
    {
        isCheck = [self isAllCheck];
    }
    if (isCheck)
    {
         if (!self.isMultChoose)
             bgImage.image = [UIImage imageNamed:@"dxk_press"];
         else
             bgImage.image = [UIImage imageNamed:@"btn_fxk2"];
        
    }
    else
    {
        if (!self.isMultChoose)
            bgImage.image = [UIImage imageNamed:@"dxk"];
        else
            bgImage.image = [UIImage imageNamed:@"btn_fxk1"];
    }
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (ccsType == 2)
        [self upDateGz];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (ccsType == 0)
    {
        if (groupBy==3) {
            NSDictionary *temp = [mContactArray objectAtIndex:indexPath.row];
            if (selectGroupID!=1) {
                return;
            }
            [self getGroupBM:[[temp objectForKey:@"Group_ID"] intValue]];
            selectGroupID=[[temp objectForKey:@"Group_ID"] intValue];
            
            mHeaderLabel.text = [NSString stringWithFormat:@"%@->%@", mHeaderLabel.text, [[temp objectForKey:@"Group_Name"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
            return;
        }
        if (indexPath.row < mContactArray.count)
        {
            NSDictionary *temp = [mContactArray objectAtIndex:indexPath.row];
            if ([[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
            {
                [self checkIndex:0];
                return;
            }
            
            [self checkIndex:indexPath.row];
            return;
        }
        else
        {
            NSMutableDictionary *dic = [mGroupArray objectAtIndex:indexPath.row-mContactArray.count];
            [mCurrentGroups addObject:dic];
            [self loadGroupsDB];
            return;
            

        }
    }
    else if (ccsType == 1)
    {
        if (ccArray.count == 0)
        {
            NSMutableArray *ct = [[NSMutableArray alloc] init];
            
            for (NSDictionary *a in [UsedItem unarchiveWithKey:[NSString stringWithFormat:@"%@usedItem",[ToolCache userKey:kAccount]]])
            {
                if ([[a objectForKey:@"SetName"] isEqualToString:[[ccGroupArray objectAtIndex:indexPath.row] objectForKey:@"SetName"] ] )
                {
                    
                    [ct addObject:a];
                }
            }
            if (ct.count > 0)
            {
                [ccArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
            }
            
            for (NSMutableDictionary *dic in ct)
            {
                if ([self containsUser:dic] != nil)
                {
                    [dic setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [dic setObject:@"0" forKey:@"check"];
                }
                [ccArray addObject:dic];
            }
            cLabel.text = [NSString stringWithFormat:@"%@->%@",TXLText,[[ccGroupArray objectAtIndex:indexPath.row] objectForKey:@"SetName"]];
            
            [tableView reloadData];
        }
        else
        {
            [self checkIndex:indexPath.row];
        }
    }
    else if (ccsType == 2|| ccsType == 3)
    {
        [self checkIndex:indexPath.row];
    }
    
    
}

- (BOOL)isAllCheck
{
    NSMutableArray * addRemoveArray = [[NSMutableArray alloc] init];
    addRemoveArray = [self gatArray];
    
    for (NSMutableDictionary *temp in addRemoveArray)
    {
        if ([[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
        {
            continue;
        }
        
        BOOL check = [[temp objectForKey:@"check"] boolValue];
        if (!check)
        {
            return NO;
        }
    }
    return YES;
}
#pragma mark 内容返回
-(NSMutableArray*)gatArray
{
    if (ccsType == 0) {
        return mContactArray;
    }
    else if (ccsType == 1)
       return ccArray;
    else if (ccsType == 2)
        return gzArray;
    else if (ccsType == 3)
    {
        if (mSearchResults.count != 0)
            return mSearchResults;
        return ssArray;
    }
    return nil;
}
- (void)checkPressed:(UIButton *)button
{
    NSInteger index = button.tag;
    [self checkIndex:index];
}

- (void)checkIndex:(NSInteger)index
{
    NSMutableArray * addRemoveArray = [[NSMutableArray alloc] init];
    addRemoveArray = [self gatArray];

    if (index >= 0 && index < addRemoveArray.count)
    {
        NSMutableDictionary *dic = [addRemoveArray objectAtIndex:index];
        
        BOOL isCheck = [[dic objectForKey:@"check"] boolValue];
        
        isCheck = !isCheck;
        if (isCheck &&groupBy ==1) {
            if ([self haveMail:dic Hidden:1])
            {
                return;
            }
        }
        if (isCheck && groupBy ==0) {
            if ([self havePhone:dic Hidden:1])
            {
                return;
            }
        }
        [dic setObject:[NSString stringWithFormat:@"%d", isCheck] forKey:@"check"];
        
        if ([[dic objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"] && self.isMultChoose)
        {
            isCheck = ![self isAllCheck];
            
            if (isCheck && groupBy ==1) {
                [self haveAllMail:addRemoveArray Hidden:1];
            }
            if (isCheck && groupBy ==0) {
                [self haveAllPhone:addRemoveArray Hidden:1];
            }
            
            for (NSMutableDictionary *temp in addRemoveArray)
            {
                if ([[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
                {
                    continue;
                }
                
                if (isCheck && groupBy ==1) {
                    if ([self haveMail:temp Hidden:0])
                    {
                        
                        continue;
                    }
                }
                if (isCheck && groupBy ==0) {
                    if ([self havePhone:temp Hidden:0])
                    {
                        continue;
                    }
                }
                [temp setObject:[NSString stringWithFormat:@"%d", isCheck] forKey:@"check"];
                if (!isCheck)
                {
                    [self removeUser:temp];
                }
                else
                {
                    [self addSelectUser:temp];
                }
            }
        }
        else
        {
            if (isCheck)
            {
                //单选的情况
                if (!self.isMultChoose)
                {
                    [mSelectionUsers removeAllObjects];
                    for (NSMutableDictionary *temp in addRemoveArray)
                    {
                        [temp setObject:@"0" forKey:@"check"];
                    }
                    [dic setObject:@"1" forKey:@"check"];
                }
                [self addSelectUser:dic];
            }
            else
            {
                [self removeUser:dic];
            }
        }
        [self checkMove];
    }
}


-(void)checkMove
{
    for (NSMutableDictionary *dic in mContactArray)
    {
        if ([self containsUser:dic] != nil)
        {
            [dic setObject:@"1" forKey:@"check"];
        }
        else
        {
            [dic setObject:@"0" forKey:@"check"];
        }
    }
    for (NSMutableDictionary *dic in ccArray)
    {
        if ([self containsUser:dic] != nil)
        {
            [dic setObject:@"1" forKey:@"check"];
        }
        else
        {
            [dic setObject:@"0" forKey:@"check"];
        }
    }
    if (ccsType == 3)
    {
        if (mSearchResults.count != 0)
        {
            for (NSMutableDictionary *dic in mSearchResults)
            {
                if ([self containsUser:dic] != nil)
                {
                    [dic setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [dic setObject:@"0" forKey:@"check"];
                }
            }
        }
        else
        {
            for (NSMutableDictionary *dic in ssArray)
            {
                if ([self containsUser:dic] != nil)
                {
                    [dic setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [dic setObject:@"0" forKey:@"check"];
                }
            }
        }
    }
    if (ccsType == 2)
    {
        for (NSMutableDictionary *dic in gzArray)
        {
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
        }
    }
    [aTableView reloadData];
}
-(BOOL)haveAllMail:(NSMutableArray*)userSet Hidden:(BOOL)HMoon
{
    NSString *aNameString = nil;
    for (NSMutableDictionary *d in userSet)
    {
        NSString *user = [d objectForKey:@"GPLD_User"];
        
        NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
        for (NSMutableDictionary *dic in array)
        {
            if ([dic[@"User_Account"] isEqualToString:user])
            {
                NSString *email = [[array objectAtIndex:0] objectForKey:@"User_Email"];
                
                if ( email == nil || [email isEqualToString:@"(null)"] || [email isEqualToString:@""])
                {
                    if (aNameString.length == 0) {
                        aNameString = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                    }
                    else
                    {
                        aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                        
                    }
                }
            }
        }
    }
    if (aNameString.length != 0&&HMoon)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@邮箱为空!",aNameString]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return NO;
}

-(BOOL)haveMail:(NSMutableDictionary*)d Hidden:(BOOL)HMoon
{
    NSString *aNameString = nil;
    NSString *user = [d objectForKey:@"GPLD_User"];
    NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"User_Account"] isEqualToString:user])
        {
            NSString *email = [[array objectAtIndex:0] objectForKey:@"User_Email"];
            
            if ( email == nil || [email isEqualToString:@"(null)"] || [email isEqualToString:@""])
            {
                if (aNameString.length == 0) {
                    aNameString = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                }
                else
                {
                    aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                }
            }
        }
    }

    if (aNameString.length != 0&&HMoon)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@邮箱为空!",aNameString]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    if (aNameString.length != 0)
        return YES;
    return NO;
}

-(BOOL)haveAllPhone:(NSMutableArray*)userSet Hidden:(BOOL)HMoon
{
    NSString *aNameString = nil;
    for (NSMutableDictionary *d in userSet)
    {
        NSString *user = [d objectForKey:@"GPLD_User"];
        
        NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
        for (NSMutableDictionary *dic in array)
        {
            if ([dic[@"User_Account"] isEqualToString:user])
            {
                NSString *email = [[array objectAtIndex:0] objectForKey:@"User_Mb"];
                
                if ( email == nil || [email isEqualToString:@"(null)"] || [email isEqualToString:@""])
                {
                    if (aNameString.length == 0) {
                        aNameString = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                    }
                    else
                    {
                        aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                        
                    }
                }
            }
        }

    }
    if (aNameString.length != 0&&HMoon)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@电话号码为空!",aNameString]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return NO;
}

-(BOOL)havePhone:(NSMutableDictionary*)d Hidden:(BOOL)HMoon
{
    NSString *aNameString = nil;
    
    NSString *user = [d objectForKey:@"GPLD_User"];
    
    NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"User_Account"] isEqualToString:user])
        {
            NSString *email = [[array objectAtIndex:0] objectForKey:@"User_Mb"];
            
            if ( email == nil || [email isEqualToString:@"(null)"] || [email isEqualToString:@""])
            {
                if (aNameString.length == 0) {
                    aNameString = [NSString stringWithFormat:@"%@",[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                }
                else
                {
                    aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[[array objectAtIndex:0] objectForKey:@"User_DspName"]];
                }
            }
        }
    }
    
    if (aNameString.length != 0 && HMoon)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@电话号码为空!",aNameString]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    if (aNameString.length != 0)
        return YES;
    return NO;
}

#pragma mark 用户详细信息处理
-(void)goInfo:(id)sender
{
    if (ccsType == 0)
    {
        NSInteger type = ((UIButton*)sender).tag -100;
        if (groupBy == 3) {
            [self goToTheGS:type];
            return;
        }
        if (type < mContactArray.count  && type > -1)
        {
            NSDictionary *temp = [mContactArray objectAtIndex:type];
            [self ContactInfo:temp];
        }
    }
    else if (ccsType == 1 ||ccsType == 2||ccsType == 3)
    {
        NSInteger type = ((UIButton*)sender).tag -100;
        NSDictionary *temp = [[self gatArray] objectAtIndex:type];
        [self ContactInfo:temp];

    }
    
}

#pragma mark 用户详细信息进入
-(void)ContactInfo:(NSDictionary*)temp
{
    if (groupBy == 2) {
        return;
    }
    if ([[temp objectForKey:@"GPLD_UserDspName"] isEqualToString:@"全选"])
    {
        return;
    }
    
    ContactInfoViewController *vc = [[ContactInfoViewController alloc] initWithNibName:nil bundle:nil];
    
    NSArray *chunks10 = nil;
    if (ccsType == 0)
        chunks10 = [mHeaderLabel.text componentsSeparatedByString:@">"];
    else if (ccsType == 1)
    {
        chunks10 = [cLabel.text componentsSeparatedByString:@">"];
    }
    else if (ccsType == 2 || (ccsType == 3&&mSearchResults.count == 0))
        vc.nameSString = [self setUserAllJob:temp];
    else
        vc.nameSString = [self setUserJob:temp];
    if (chunks10.count>1)
    {
        NSString *myString = nil;
        if (ccsType == 1)
            myString = [temp objectForKey:@"USER_Title"];
        else
            myString = [self setUserJob:temp];
        if (myString.length == 0) {
                vc.nameSString = [chunks10 objectAtIndex:chunks10.count-1];
        }
        else
            vc.nameSString = [NSString stringWithFormat:@"%@->%@",[chunks10 objectAtIndex:chunks10.count-1],myString];
    }
    vc.contactInfoDic = temp;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获取用户电话号码
-(NSString*)setPhone:(NSDictionary*)dic
{
    NSString *phone = [dic objectForKey:@"User_Mb"];;
    
    if ([phone isEqualToString:@"(null)"] || phone == nil || [phone isEqualToString:@""])
    {
        
        NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
        for (NSMutableDictionary *tem in array)
        {
            if ([tem[@"User_Account"] isEqualToString:[dic objectForKey:@"GPLD_User"]])
            {
                phone = [tem objectForKey:@"User_Mb"];
                break;
            }
        }

    }
    
    if ([phone isEqualToString:@"(null)"] || phone == nil || [phone isEqualToString:@""])
        return phone;
    else
        phone = [NSString stringWithFormat:@"%@",phone];
    
    return phone;
    
}

#pragma mark 获取用户电话号码 和名字
-(NSString*)setUserPhone:(NSDictionary*)dic
{
    NSString *phone = [dic objectForKey:@"User_Mb"];;
    
    if ([phone isEqualToString:@"(null)"] || phone == nil || [phone isEqualToString:@""])
    {
        NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
        for (NSMutableDictionary *tem in array)
        {
            if ([tem[@"User_Account"] isEqualToString:[dic objectForKey:@"GPLD_User"]])
            {
                phone = [tem objectForKey:@"User_Mb"];
                break;
            }
        }
    }

    if ([phone isEqualToString:@"(null)"] || phone == nil || [phone isEqualToString:@""])
        phone = [NSString stringWithFormat:@"%@", [dic objectForKey:@"GPLD_UserDspName"]];
    else
        phone = [NSString stringWithFormat:@"%@    %@", [dic objectForKey:@"GPLD_UserDspName"],phone];
    
    return phone;
    
}

#pragma mark 获取用户首要职位
-(NSString*)setUserJob:(NSDictionary*)dic
{
    NSString *jobTitle = [dic objectForKey:@"GPLD_JobTitle"];
    
    if ([jobTitle isEqualToString:@"(null)"] || jobTitle == nil || [jobTitle isEqualToString:@""])
    {
        NSArray *array = [UsersMenu unarchiveWithKey:@"UsersMenu"];
        for (NSMutableDictionary *tem in array)
        {
            if ([tem[@"User_Account"] isEqualToString:[dic objectForKey:@"GPLD_User"]])
            {
                jobTitle = [tem objectForKey:@"USER_Title"];
                break;
            }
        }
    }
    
    if ([jobTitle isEqualToString:@"(null)"] || jobTitle == nil || [jobTitle isEqualToString:@""])
        jobTitle = @"";
    if  (ccsType == 3&&mSearchResults.count != 0)
    {
        if (jobTitle.length == 0) {
            jobTitle = [NSString stringWithFormat:@"%@->%@",[dic objectForKey:@"GroupName"],[dic objectForKey:@"GPLD_Group"]];
        }
        else
            jobTitle = [NSString stringWithFormat:@"%@->%@->%@",[dic objectForKey:@"GroupName"],[dic objectForKey:@"GPLD_Group"],jobTitle];
        
        jobTitle = [jobTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    
    return jobTitle;
}

#pragma mark 获取用户所有职位
-(NSString*)setUserAllJob:(NSDictionary*)MyArray
{
    NSString *mTstring = nil;
    NSMutableArray *array = [self getUserAllJobName:MyArray];
    for (int i = 0; i < [array count]; i ++)
    {
        
        if ([[NSString stringWithFormat:@"%@",[array objectAtIndex:i]] isEqualToString:@"(null)"])
        {
            mTstring = mTstring;
        }
        else
        {
            mTstring = [mTstring stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if (mTstring.length == 0) {
                mTstring = [NSString stringWithFormat:@"%@",[array objectAtIndex:i]];
            }
            else
            mTstring = [NSString stringWithFormat:@"%@\n%@",mTstring,[array objectAtIndex:i]];
        }
        
    }
    mTstring = [mTstring stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    return mTstring;
}

-(NSMutableArray*)getUserAllJobName:(NSDictionary*)MyArray
{
    NSMutableArray *dpts = [[NSMutableArray alloc] init];
    NSArray *array = [GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"];
    for (NSMutableDictionary *temp in array)
    {
        if ([temp[@"GPLD_User"] isEqualToString:[MyArray objectForKey:@"GPLD_User"]])
        {
            NSArray *array1 = [GroupsMenu unarchiveWithKey:@"GroupsMenu"];
            for (NSMutableDictionary *temp1 in array1)
            {
                if ([temp1[@"Group_ID"] isEqualToString:[temp objectForKey:@"GPLD_GroupID"]]&&[[temp objectForKey:@"GPLD_GroupID"] isEqualToString:[temp1 objectForKey:@"Group_ID"]]&&[[temp1 objectForKey:@"Group_IsShow"] isEqualToString:@"1"])
                {
                    NSString *string = nil;
                    if ([[temp objectForKey:@"GPLD_JobTitle"] isEqualToString:@"(null)"]) {
                        string = [NSString stringWithFormat:@"%@>%@",[temp objectForKey:@"GroupName"],[temp objectForKey:@"GPLD_Group"]];
                    }
                    else
                        string = [NSString stringWithFormat:@"%@>%@>%@",[temp objectForKey:@"GroupName"],[temp objectForKey:@"GPLD_Group"],[temp objectForKey:@"GPLD_JobTitle"]];
                    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [dpts addObject:string];
                }
            }
        }
    }

    return dpts;
}


#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *msg = searchBar.text;
    [mSearchResults removeAllObjects];

    if ([msg isEqualToString:@""])
    {
        [self upDateSous];
        [aTableView reloadData];
        return;
    }
    
    NSArray *array = [GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"];
    for (NSMutableDictionary *dic in array)
    {
        NSString * tempStr = dic[@"GPLD_UserDspName"];
        NSRange range = [tempStr rangeOfString:msg];
        if (range.length >0)
        {
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            [mSearchResults addObject:dic];
        }

    }
    
    if (mSearchResults.count != 0) {
        
        [mSearchResults addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"GPLD_Ord" ascending:YES]];
        [mSearchResults sortUsingDescriptors:sortDescriptors];
    }
    [aTableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    return YES;
}
#pragma mark  UISearchBar 响应事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 短信群发
- (void)qunfaPressed:(id)sender
{
    if (mSelectionUsers.count < 1)
    {
        [RequestSerive alerViewMessage:@"未选择人员!"];
        return;
    }
    if (![MFMessageComposeViewController canSendText])
    {
        return;
    }
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    picker.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    
    NSMutableArray *recipients = [[NSMutableArray alloc] init];
    for (NSDictionary *temp in mSelectionUsers)
    {
        [recipients addObject:[self setPhone:temp]];
    }
    picker.recipients = recipients;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

#pragma mark -
#pragma mark MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
//    NSString*msg = nil;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    switch (result)
    {
        case MessageComposeResultCancelled:
//            msg = @"您取消了发送短信!";
//            [SendService alerViewMessage:msg];
            break;
        case MessageComposeResultSent:
//            msg = @"短信发送成功!";
//            self.isMultChoose = NO;
//            [self checkIndex:0];
//            self.isMultChoose = YES;
//            [mSelectionUsers removeAllObjects];
//            [SendService alerViewMessage:msg];
            break;
        case MessageComposeResultFailed:
//            msg = mMailFailure;
//            [SendService alerViewMessage:msg];
            break;
        default:
            break;
    }
}
-(void)dealloc{
    [serive cancelRequest];
}
@end
