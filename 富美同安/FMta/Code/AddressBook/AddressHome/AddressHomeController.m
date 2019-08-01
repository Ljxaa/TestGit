//
//  AddressHomeController.m
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "AddressHomeController.h"
#import "SelectedViewController.h"
#import "InfoUserController.h"
#import "OAGetGroupUsers.h"
#import "OAGetGroupsMenu.h"
#import "ToolCache.h"
#import "Global.h"
#import "RequestSerive.h"
#import "GroupUsersMenu.h"

#define summaryHeight 20
#define summary1 @"由各部门自行在oa上维护"
#define summary2 @"由区委办、区组织部、区信息中心维护"

@interface AddressHomeController (){
    NSInteger selectGroupID;
    UISearchBar *mSearchBar;
    
    NSDictionary *verson_dic,*new_verson_dic;
//    NSMutableArray *ssArray,*mSearchResults;
}

@end


#define tableViewTag 100
#define LabelHight 40*(iPadOrIphone)
#define contactButtonWight 80*(iPadOrIphone)
#define mViewColor [UIColor colorWithRed:0/255.0 green:94/255.0 blue:159/255.0 alpha:1]
@implementation AddressHomeController
@synthesize isMultChoose,mSelectionUsers,delegate,groupBy;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"通讯录";
//        _isShowUnit = YES;
        isMultChoose = YES;
        mGroupArray = [[NSMutableArray alloc] init];
        mContactArray = [[NSMutableArray alloc] init];
        mSelectionUsers = [[NSMutableArray alloc] init];
        mCurrentGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectGroupID = 1;//选部门时纪录用
    
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
    

    segmentedControl = [[CCSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"单位",@"部门",@"公共",@"个人",@"搜索", nil]];
    if ((iPadOrIphone) == 2) {
        segmentedControl.frame = CGRectMake(0, LabelHight/8, self.view.bounds.size.width*1.6, LabelHight*3/4);
    }
    else
        segmentedControl.frame = CGRectMake(0, LabelHight/8, self.view.bounds.size.width, LabelHight*3/4);
    segmentedControl.selectedStainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"inner_tab_bg1.png"]];
    segmentedControl.selectedSegmentTextColor = mViewColor;
    segmentedControl.segmentTextColor = [UIColor whiteColor];
    segmentedControl.backgroundColor = [UIColor clearColor];
    [segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    //介绍
    summaryView = [[UIView alloc]initWithFrame:CGRectMake(0, LabelHight, screenMySize.size.width, summaryHeight)];
    [summaryView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:summaryView];
    summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, summaryView.frame.size.width, summaryView.frame.size.height)];
    summaryLabel.font = [UIFont fontWithName:@"Arial" size:13];
    summaryLabel.textAlignment = 0;
    [summaryLabel setText:summary1];
    summaryLabel.backgroundColor = [UIColor clearColor];
    summaryLabel.textColor = [UIColor blackColor];
    [summaryView addSubview:summaryLabel];
    //点击返回
    mHeaderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mHeaderButton setFrame:CGRectMake(0, LabelHight + summaryHeight, screenMySize.size.width, LabelHight)];
    [mHeaderButton setBackgroundColor:[UIColor grayColor]];
    [mHeaderButton addTarget:self action:@selector(mBackGroupButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mHeaderButton];
    mHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, LabelHight)];
    mHeaderLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
    mHeaderLabel.textAlignment = 0;
    mHeaderLabel.backgroundColor = [UIColor clearColor];
    mHeaderLabel.textColor = [UIColor blackColor];
    [mHeaderButton addSubview:mHeaderLabel];
    
    gzBuuton = [UIButton buttonWithType:UIButtonTypeCustom];
    [gzBuuton setFrame:CGRectMake(screenMySize.size.width-50*(iPadOrIphone), 0 ,40*(iPadOrIphone), LabelHight)];
    [gzBuuton setBackgroundColor:[UIColor grayColor]];
    //    [gzBuuton setTitle:@"刷新" forState:UIControlStateNormal];
    [gzBuuton setBackgroundImage:[UIImage imageNamed:@"xuanzhuan.png.png"] forState:UIControlStateNormal];
    gzBuuton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [gzBuuton addTarget:self action:@selector(gotoShua) forControlEvents:UIControlEventTouchUpInside];
    [mHeaderButton addSubview:gzBuuton];
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
    
    aTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mHeaderButton.frame), screenMySize.size.width, self.view.bounds.size.height-CGRectGetMaxY(mHeaderButton.frame))];
    aTableView.delegate = self;
    aTableView.dataSource = self;
    aTableView.backgroundColor = bgColor;
    [self.view addSubview:aTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [aTableView setTableFooterView:v];
    
    [self queryGroupUsers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(treatedATask) name:@"tongxunlu" object:nil];
    //有新版本时，需要更新
    verson_dic = [ToolCache userKeyForDictionary:KGroupVerson];
    new_verson_dic = [ToolCache userKeyForDictionary:KNewGroupVerson];
    if (![verson_dic[@"Version"] isEqualToString:new_verson_dic[@"Version"]]&&new_verson_dic!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:new_verson_dic[@"UpdateLog"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag = 200;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            [self goToTXL];
        }
    }else if (alertView.tag == 200){
        if (buttonIndex == 1)
        {
            [self goToTXL];
        }
    }
}
#pragma mark 搜索同步
//-(void)upDateSous
//{
//    if (mSearchResults.count != 0)
//    {
//        [aTableView reloadData];
//        return;
//    }
//    [ssArray removeAllObjects];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *path=[paths  objectAtIndex:0];
//    NSString *filename=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@1.plist",[ToolCache userKey:kAccount]]];
//    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
//    if (remData.count > 0)
//    {
//        [ssArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
//        
//        for (int i = (int)remData.count-1; i >= 0; i --)
//        {
//            NSMutableDictionary *dic = [remData objectForKey:[NSString stringWithFormat:@"%d",i]];
//            if ([self containsUser:dic] != nil)
//            {
//                [dic setObject:@"1" forKey:@"check"];
//            }
//            else
//            {
//                [dic setObject:@"0" forKey:@"check"];
//            }
//            [ssArray addObject:dic];
//        }
//    }
//    [aTableView reloadData];
//}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AOAGetGroupUsers])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
//        NSLog(@"arrayarrayarray:%@",array);
        NSMutableArray *mSarray = [[NSMutableArray alloc] init];

        for (NSDictionary*  ct in array)
        {
            if ([ct[@"OrderNo"] allKeys].count == 0) {
                continue;
            }
            NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
            
            for(NSString *key in [ct allKeys])
            {
//                if ([key isEqualToString:@"OrderNo"]) {
//                    if ([ct[key] allKeys].count == 0) {
//                        isClipOne = true;
//                        continue;
//                    }
//                }
                [aCt setValue:ct[key][@"text"] forKey:key];
            }
            [mSarray addObject:aCt];
        }
        [mSarray archiveWithKey:@"OAGetGroupUsers"];
        if (mSarray.count > 0) {
            [serive GetFromURL:AOAGetGroupsForUnit params:nil mHttp:httpUrl isLoading:YES];
        }else{
            [RequestSerive alerViewMessage:mAddressFailure];
        }
    }
    else if ([urlName isEqualToString:AOAGetGroups])
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
        [mSarray archiveWithKey:@"OAGetGroupsMenu"];
        [RequestSerive alerViewMessage:mAddressSuccessful];
        [ToolCache setUserStrForDictionary:new_verson_dic forKey:KGroupVerson];
        [self loadGroupsDB];
        //部门判断权限
        if (ccsType == 1 && !_isShowUnit) {
            [mGroupArray removeAllObjects];
            [mCurrentGroups removeAllObjects];
            [aTableView reloadData];
        }
    }
    else if ([urlName isEqualToString:AOAGetGroupsForUnit])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
        //        NSLog(@"arrayarrayarray:%@",array);
        NSMutableArray *mSarray = [[NSMutableArray alloc] init];
        
        for (NSDictionary*  ct in array)
        {
//            if ([ct[@"orderNO"] allKeys].count == 0) {
//                continue;
//            }
            NSMutableDictionary *aCt = [[NSMutableDictionary alloc] init];
            
            for(NSString *key in [ct allKeys])
            {
                //                if ([key isEqualToString:@"OrderNo"]) {
                //                    if ([ct[key] allKeys].count == 0) {
                //                        isClipOne = true;
                //                        continue;
                //                    }
                //                }
                NSString *value;
                value = ct[key][@"text"];
                [aCt setValue:value forKey:key];
            }
            [mSarray addObject:aCt];
        }
        [mSarray archiveWithKey:@"OAGetGroupUsersForUnit"];
        if (mSarray.count > 0) {
            [serive GetFromURL:AOAGetGroups params:nil mHttp:httpUrl isLoading:YES];
        }else{
            [RequestSerive alerViewMessage:mAddressFailure];
        }
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
    [serive GetFromURL:AOAGetGroupUsers params:nil mHttp:httpUrl isLoading:YES];
}
#pragma mark - 去掉数字前面的0
-(NSString*) getTheCorrectNum:(NSString*)tempString

{
    
    while ([tempString hasPrefix:@"0"])
        
    {
        
        tempString = [tempString substringFromIndex:1];
        
        NSLog(@"压缩之后的tempString:%@",tempString);
        
    }
    
    return tempString;
    
}

#pragma mark 获取常用数据
-(void)gotoShua
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:mGATo delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = 100;
    [alert show];
    
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
    [mSearchBar resignFirstResponder];
    CCSegmentedControl* segmentedControl1 = sender;
    ccsType = (unsigned int)segmentedControl1.selectedSegmentIndex;
    mHeaderLabel.text = TXLText;
    [mGroupArray removeAllObjects];
    [mCurrentGroups removeAllObjects];
    
    
    mSearchBar.alpha = 0;
    gzBuuton.alpha = 1;
    
    if (ccsType == 3) {
        [mHeaderButton setHidden:YES];
        [mHeaderButton setFrame:CGRectMake(0, 0, screenMySize.size.width, LabelHight)];
    }else if (ccsType == 4){
        [mHeaderButton setHidden:NO];
        [mHeaderButton setFrame:CGRectMake(0, LabelHight, screenMySize.size.width, LabelHight)];
    }else{
        if (ccsType == 1 && !_isShowUnit) {
            [aTableView reloadData];
            return;
        }
        [mHeaderButton setHidden:NO];
        if (ccsType == 2) {
            [summaryLabel setText:summary2];
        }else{
            [summaryLabel setText:summary1];
        }
        [mHeaderButton setFrame:CGRectMake(0, LabelHight + summaryHeight, screenMySize.size.width, LabelHight)];
    }
    
    aTableView.frame = CGRectMake(0, CGRectGetMaxY(mHeaderButton.frame), screenMySize.size.width, self.view.bounds.size.height - CGRectGetMaxY(mHeaderButton.frame));
    
    if (ccsType == 4) {
        //搜索
        mSearchBar.alpha = 1;
        gzBuuton.alpha = 0;
//        [self upDateSous];
        [self loadSearchData:mSearchBar.text];
    }else{
        [self loadGroupsDB];
    }
    
}

#pragma mark 同步通讯录
- (void)queryGroupUsers
{
    if ([[OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupsMenu"] count] == 0)
    {
        [self goToTXL];
    }
    else
    {
        [self loadGroupsDB];
    }
}
#pragma mark 通讯录搜索加载过滤
- (void)loadSearchData:(NSString *)searchText{
    [self getGroups];
    NSString *groupId = @"253";
    
    [mGroupArray removeAllObjects];
    [mContactArray removeAllObjects];
    
    if (searchText != nil) {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    if (searchText == nil||searchText.length == 0) {
        [aTableView reloadData];
        return;
    }
#pragma mark 显示人问题
    //加载子分组
    NSArray *arrayGroup = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupsMenu"];
    //加载分组人员
    NSArray *array = [OAGetGroupUsers unarchiveWithKey:@"OAGetGroupUsers"];
    //公共通讯录判断包含列表
    NSArray *typeArray = nil;
    if ([ToolCache userKey:KType_no1_Ids] != nil) {
        typeArray = [[ToolCache userKey:KType_no1_Ids] componentsSeparatedByString:@","];
    }
//    NSLog(@"typeArray:%@",typeArray);
    //过滤
    NSString *groupLabel = @"";//搜索前置单位显示
    BOOL isSkip = false;
    
    for (NSMutableDictionary *temp in arrayGroup)
    {
        NSLog(@"temptemptemp::%@",temp[@"Type"]);
        if ([temp[@"Type"] isEqualToString:@"单位通讯录"]&&(_isShowUnit?1:[temp[@"GroupId"] isEqualToString:[ToolCache userKey:kUserGoupID]])&&[temp[@"IsShow"] isEqualToString:@"1"]) {
//            if ([temp[@"IsShow"] isEqualToString:@"1"]) {
//                [mGroupArray addObject:temp];
//            }
        }else if([temp[@"Type"] isEqualToString:@"公共通讯录"]&&[temp[@"IsShow"] isEqualToString:@"1"]){
            //遍历判断typeid包含，不包含则不显示
            for (NSString *typeId in typeArray) {
                if ([typeId intValue] == [temp[@"Id"] intValue]) {
                    isSkip = false;
                    break;
                }
                isSkip = true;
            }
            if (isSkip) {
                continue;
            }
        }else{
            continue;
        }
        groupId = temp[@"Id"];
        NSString *tempType = @"";
        if ([temp[@"Type"] isEqualToString:@"单位通讯录"]) {
            if (_isShowUnit) {
                tempType = @"部门通讯录";
            }else{
                tempType = @"单位通讯录";
            }
        }else{
            tempType = temp[@"Type"];
        }
        groupLabel = [NSString stringWithFormat:@"%@->%@",tempType,temp[@"Name"]];
//        NSLog(@"=====%@",groupLabel);
        for (NSMutableDictionary *dic in array)
        {
            if([dic[@"DspName"] rangeOfString:searchText].location == NSNotFound)//_roaldSearchText
            {
                continue;
            }
//            dic[@"Job"]
            BOOL isGoing = NO;
            if ([dic[@"ContactId"] isEqualToString:groupId])
                isGoing = YES;
            if (ccsType == 2 && !isGoing)
            {
                NSArray *controls = [dic[@"A_Type1Ids"] componentsSeparatedByString:@","];
                for (int i = 0; i < controls.count; i ++)
                {
                    if ([[controls objectAtIndex:i] isEqualToString:groupId]) {
                        isGoing = YES;
                        break;
                    }
                }
            }
            
            if (isGoing)
            {
                BOOL isPermissions = NO;
                if (ccsType == 2)
                {
                    NSString *urStr = [ToolCache userKey:kPermissions];
                    NSArray *controls1 = [urStr componentsSeparatedByString:@","];
                    for (int i = 0; i < controls1.count; i ++)
                    {
                        if ([[controls1 objectAtIndex:i] isEqualToString:groupId]) {
                            isPermissions = YES;
                            break;
                        }
                    }
                    if ([dic[@"IsLinkMan"] isEqualToString:@"1"])
                    {
                        isPermissions = YES;
                    }
                }
                else
                    isPermissions = YES;
                
                if (!isPermissions) {
                    continue;
                }
                
                if (mContactArray.count == 0)
                {
                    [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"DspName", nil]];
                }
                if ([self containsUser:dic] != nil)
                {
                    [dic setObject:@"1" forKey:@"check"];
                }
                else
                {
                    [dic setObject:@"0" forKey:@"check"];
                }
                [dic setObject:[NSString stringWithFormat:@"%@->%@",groupLabel,dic[@"Job"]] forKey:@"Job"];
                [mContactArray addObject:dic];
                
            }
        }
    }
    
    [self aTableViewData];
}
#pragma mark 通讯录加载过滤
- (void)loadGroupsDB
{
    [self getGroups];
    
    NSString *groupId = @"";
    
    mHeaderLabel.text = TXLText;
    
    if (mCurrentGroups.count <= 0)
    {
        if (ccsType == 0)
            groupId = [ToolCache userKey:kUserGoupID];
    }
    else
    {
        groupId = [[mCurrentGroups lastObject] objectForKey:@"Id"];
        for (NSMutableDictionary *dic in mCurrentGroups)
        {
            mHeaderLabel.text = [NSString stringWithFormat:@"%@->%@", mHeaderLabel.text, [[dic objectForKey:@"Name"] stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
    [mGroupArray removeAllObjects];
    
    if (ccsType == 3)//个人通讯录更改
    {
        [mContactArray removeAllObjects];
        
        NSMutableDictionary *remData= [ToolCache addgzRemData];
        
        for (int i = 0; i < remData.count; i ++) {
            NSMutableDictionary*dic = [remData objectForKey:[NSString stringWithFormat:@"%d",i]];
            if (mContactArray.count == 0)
            {
                [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"DspName", nil]];
            }
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            
            [mContactArray addObject:dic];
        }
        [self aTableViewData];
        return;
    }
//    else if (ccsType == 1){//部门通讯录
//        NSArray *array = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupUsersForUnit"];
//        [mGroupArray addObjectsFromArray:array];
//        [self aTableViewData];
//    }
    //加载子分组
    NSString *PidKey;
    NSArray *array;
    if (ccsType == 1) {//部门通讯录
        PidKey = @"pid";
        array = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupUsersForUnit"];
    }else{
        PidKey = @"PId";
        array = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupsMenu"];
    }
    for (NSMutableDictionary *temp in array)
    {
        if (([temp[PidKey] isEqualToString:groupId] && ![mHeaderLabel.text isEqualToString:TXLText]) ||([mHeaderLabel.text isEqualToString:TXLText]&&(([temp[PidKey] isEqualToString:@"0"]&&ccsType != 2)||(ccsType == 2&&[temp[PidKey] isEqualToString:@"1"])))) {
            if (ccsType == 0)//"单位通讯录",@"公共通讯录",@"个人通讯录"
            {
                if ([temp[@"Type"] isEqualToString:@"单位通讯录"]&&[temp[@"GroupId"] isEqualToString:[ToolCache userKey:kUserGoupID]]) {
                    if ([temp[@"IsShow"] isEqualToString:@"1"]) {
                        [mGroupArray addObject:temp];
                    }
                }
            }
            else if (ccsType == 1)
            {
                [mGroupArray addObject:temp];
            }
            else if (ccsType == 2)
            {
                if ([temp[@"Type"] isEqualToString:@"公共通讯录"]) {
                    if ([temp[@"IsShow"] isEqualToString:@"1"]) {
                        [mGroupArray addObject:temp];
                    }
                }
            }
            else if (ccsType == 3)
            {
                if ([temp[@"Type"] isEqualToString:@"个人通讯录"]&&[temp[@"UserAccount"] isEqualToString:[ToolCache userKey:kAccount]]) {
                    if ([temp[@"IsShow"] isEqualToString:@"1"]) {
                        [mGroupArray addObject:temp];
                    }
                }
            }
        }

    }
    
    if ([mHeaderLabel.text isEqualToString:TXLText])
    {
        [mContactArray removeAllObjects];
        [self aTableViewData];
        return;

    }
#pragma mark 显示人问题
//    BOOL isTreeLevel = YES;
//    if (mCurrentGroups.count >0) {
//        if ([[mCurrentGroups lastObject][@"TreeLevel"] isEqualToString:@"1"]) {
//            isTreeLevel = NO;
//        }
//       
//    }
    [mContactArray removeAllObjects];
//    if (!isTreeLevel) {
//        [self aTableViewData];
//        return;
//    }
#pragma mark 显示人问题
    //加载分组人员
    array = [OAGetGroupUsers unarchiveWithKey:@"OAGetGroupUsers"];
    NSLog(@"arrayarray%@",array);
    for (NSMutableDictionary *dic in array)
    {
        BOOL isGoing = NO;
        if ([dic[@"ContactId"] isEqualToString:groupId])
            isGoing = YES;
        if (ccsType == 2 && !isGoing)
        {
            NSArray *controls = [dic[@"A_Type1Ids"] componentsSeparatedByString:@","];
            for (int i = 0; i < controls.count; i ++)
            {
                if ([[controls objectAtIndex:i] isEqualToString:groupId]) {
                    isGoing = YES;
                    break;
                }
            }
        }
        
        if (isGoing)
        {
            BOOL isPermissions = NO;
            if (ccsType == 2)
            {
                NSString *urStr = [ToolCache userKey:kPermissions];
                NSArray *controls1 = [urStr componentsSeparatedByString:@","];
                for (int i = 0; i < controls1.count; i ++)
                {
                    if ([[controls1 objectAtIndex:i] isEqualToString:groupId]) {
                        isPermissions = YES;
                        break;
                    }
                }
                if ([dic[@"IsLinkMan"] isEqualToString:@"1"])
                {
                    isPermissions = YES;
                }
            }
            else
                isPermissions = YES;
            
            if (!isPermissions) {
                continue;
            }
            
            
            if (mContactArray.count == 0)
            {
                [mContactArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"DspName", nil]];
            }
            if ([self containsUser:dic] != nil)
            {
                [dic setObject:@"1" forKey:@"check"];
            }
            else
            {
                [dic setObject:@"0" forKey:@"check"];
            }
            
            [mContactArray addObject:dic];
            
        }
    }
    
    [self aTableViewData];
    
}

#pragma mark 获取本人所在部门ID
- (NSMutableArray *)getDetpartments
{
    NSMutableArray *dpts = [[NSMutableArray alloc] init];
    
    NSArray *array = [OAGetGroupUsers unarchiveWithKey:@"OAGetGroupUsers"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"Account"] isEqualToString:[ToolCache userKey:kAccount]])
        {
            [dpts addObject:[dic objectForKey:@"ContactId"]];
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
    NSArray *array = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupsMenu"];
    for (NSMutableDictionary *dic in array)
    {
        if ([dic[@"PId"] isEqualToString:dspId]&&[dic[@"IsShow"] isEqualToString:@"1"])
        {
            NSString *Group_ParentID = [[array objectAtIndex:0] objectForKey:@"PId"];
            [mDeptments addObject:Group_ParentID];
            if (![Group_ParentID isEqualToString:@"1"])
            {
                return [self getGroup:Group_ParentID];
            }
            NSString *groupId = [[array objectAtIndex:0] objectForKey:@"Id"];
            [mDeptments addObject:groupId];
            return groupId;
        }
    }
    
    return nil;
}


#pragma mark TableView排序刷新
-(void)aTableViewData
{
    NSString *orderNo;
    if (ccsType == 1) {
        orderNo = @"orderNO";
    }else{
        orderNo = @"OrderNo";
    }
    [mGroupArray sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:orderNo ascending:YES]]];
//    [mGroupArray sortUsingComparator:^NSComparisonResult(NSDictionary*  _Nonnull obj1, NSDictionary*  _Nonnull obj2) {
//        NSString* order1 = obj1[orderNo];
//        NSString* order2 = obj2[orderNo];
//        NSLog(@"%@,%@,%ld",order1,order2,(long)[order1 compare:order2]);
//        return [order1 compare:order2];
//    }];

    NSArray *sortedArray = [mContactArray sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
//        NSLog(@"==%d==%d==",[obj1[orderNo] intValue],[obj2[orderNo] intValue]);
        if ([obj1[@"OrderNo"] intValue] > [obj2[@"OrderNo"] intValue])
        {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    [mContactArray removeAllObjects];
    [mContactArray addObjectsFromArray:sortedArray];
    
    
//    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"OrderNo" ascending:YES];
//    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"Id" ascending:NO];
//    [mContactArray sortUsingDescriptors:[NSArray arrayWithObjects:sort1, sort2, nil]];
    
    [aTableView reloadData];
    [aTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark 判断已选是否存在 不存在check赋值0 存在check赋值1
- (NSMutableDictionary *)containsUser:(NSMutableDictionary *)dic
{
    for (NSMutableDictionary *temp in mSelectionUsers)
    {
        if ([[temp objectForKey:@"DspName"] isEqualToString:[dic objectForKey:@"DspName"]])
        {
            return temp;
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
    if (mCurrentGroups.count <= 0)
    {
        return;
    }
    [mCurrentGroups removeLastObject];
    [self loadGroupsDB];
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
//    if (ccsType == 3) {
//        if (mSearchResults.count != 0)
//            return mSearchResults.count;
//        return ssArray.count;
//    }
    return mContactArray.count + mGroupArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (ccsType == 3)
//    {
//        if (mSearchResults.count != 0)
//            return LabelHight;
//        NSMutableArray *array = [self getUserAllJobName:[ssArray objectAtIndex:indexPath.row]];
//        if (array.count == 0) {
//            return LabelHight;
//        }
//        return LabelHight/2 + array.count*LabelHight/2;
//    }
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
    
//    if (ccsType == 3)
//    {
//        return [self mCTableView:tableView cellForRowAtIndexPath:indexPath];
//    }
    
    if (indexPath.row < mContactArray.count)
    {
        return [self mCTableView:tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        return [self mGTableView:tableView cellForRowAtIndexPath:indexPath];
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
    
    cell.textLabel.text = [[mGroupArray objectAtIndex:indexPath.row-mContactArray.count] objectForKey:@"Name"];
    
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
    
    NSMutableDictionary *dic = [mContactArray objectAtIndex:indexPath.row];
    int  labelJobHight = LabelHight/2;
//    if (ccsType == 3)
//    {
//        if (mSearchResults.count != 0)
//            dic = [mSearchResults objectAtIndex:indexPath.row];
//        else
//            dic = [ssArray objectAtIndex:indexPath.row];
//    }else{
//        dic
//    }
//    if (ccsType == 3&&mSearchResults.count == 0)
//    {
//        NSMutableArray *array = [self getUserAllJobName:dic];
//        if (array.count != 0) {
//            labelJobHight =  (int)array.count*LabelHight/2;
//        }
//    }
    
    if ([[dic objectForKey:@"DspName"] isEqualToString:@"全选"])
    {
        UILabel *t1Label = [[UILabel alloc] init];
        t1Label.frame = CGRectMake(40*(iPadOrIphone), 0, screenMySize.size.width-50*(iPadOrIphone), LabelHight);
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
        [cell.contentView addSubview:myButton];
        
        
        UILabel *t1Label = [[UILabel alloc] init];
        t1Label.frame = CGRectMake(40*(iPadOrIphone), 0, screenMySize.size.width-50*(iPadOrIphone), LabelHight/2) ;
        [t1Label setTextColor:[UIColor blackColor]];
            t1Label.text = [self setUserPhone:dic];
        [t1Label setFont:[UIFont fontWithName:@"Arial" size:labelSize+1]];
        [t1Label setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:t1Label];
        
        UILabel *t2Label = [[UILabel alloc] init];
        t2Label.numberOfLines = 0;
        t2Label.frame = CGRectMake(40*(iPadOrIphone), LabelHight/2, screenMySize.size.width-50*(iPadOrIphone),labelJobHight) ;
        [t2Label setTextColor:[UIColor grayColor]];
        t2Label.text = [self setUserJob:dic];
        [t2Label setFont:[UIFont fontWithName:@"Arial" size:labelSize-3]];
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
    if ([[dic objectForKey:@"DspName"] isEqualToString:@"全选"])
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < mContactArray.count)
    {
        NSDictionary *temp = [mContactArray objectAtIndex:indexPath.row];
        if ([[temp objectForKey:@"DspName"] isEqualToString:@"全选"])
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

- (BOOL)isAllCheck
{
    NSMutableArray * addRemoveArray = [[NSMutableArray alloc] init];
    addRemoveArray = [self gatArray];
    
    for (NSMutableDictionary *temp in addRemoveArray)
    {
        if ([[temp objectForKey:@"DspName"] isEqualToString:@"全选"])
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
//    if (ccsType == 3) {
//        if (mSearchResults.count != 0)
//            return mSearchResults;
//        return ssArray;
//    }
    return mContactArray;
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
        
        if ([[dic objectForKey:@"DspName"] isEqualToString:@"全选"] )
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
            if (!isCheck)
            {
                [self removeUser:dic];
            }
            else
            {
                [self addSelectUser:dic];
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
    [aTableView reloadData];
}
-(BOOL)haveAllMail:(NSMutableArray*)userSet Hidden:(BOOL)HMoon
{
    NSString *aNameString = nil;
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
        BOOL  isEephone = NO;
        if ([d[@"Phone"] hash] && (id)d[@"Phone"] != [NSNull null])
            isEephone = YES;
        if ([d[@"DspName"] isEqualToString:@"全选"]) {
            isEephone = YES;
        }
        
//        else if ([d[@"Tel"] hash] && (id)d[@"Tel"] != [NSNull null])
//            isEephone = YES;
//        else if ([d[@"HomeTel"] hash] && (id)d[@"HomeTel"] != [NSNull null])
//            isEephone = YES;
        if (!isEephone)
        {
            
            if (aNameString.length == 0)
            {
                aNameString = [NSString stringWithFormat:@"%@",d[@"DspName"]];
            }
            else
            {
                aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[NSString stringWithFormat:@"%@",d[@"DspName"]]];
                
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
    
    BOOL  isEephone = NO;
    if ([d[@"Phone"] hash] && (id)d[@"Phone"] != [NSNull null])
        isEephone = YES;
    if ([d[@"DspName"] isEqualToString:@"全选"]) {
        isEephone = YES;
    }
    //        else if ([d[@"Tel"] hash] && (id)d[@"Tel"] != [NSNull null])
    //            isEephone = YES;
    //        else if ([d[@"HomeTel"] hash] && (id)d[@"HomeTel"] != [NSNull null])
    //            isEephone = YES;
    if (!isEephone)
    {
        
        if (aNameString.length == 0)
        {
            aNameString = [NSString stringWithFormat:@"%@",d[@"DspName"]];
        }
        else
        {
            aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,[NSString stringWithFormat:@"%@",d[@"DspName"]]];
            
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
//    if (ccsType == 3) {
//        NSInteger type = ((UIButton*)sender).tag -100;
//        NSDictionary *temp = [[self gatArray] objectAtIndex:type];
//        [self ContactInfo:temp];
//        
//        return;
//    }
    NSInteger type = ((UIButton*)sender).tag -100;
    if (type < mContactArray.count  && type > -1)
    {
        NSDictionary *temp = [mContactArray objectAtIndex:type];
        [self ContactInfo:temp];
    }
}

#pragma mark 用户详细信息进入
-(void)ContactInfo:(NSDictionary*)temp
{
    if (groupBy == 2) {
        return;
    }
    if ([[temp objectForKey:@"DspName"] isEqualToString:@"全选"])
    {
        return;
    }
    
//    InfoUserController *vc = [[InfoUserController alloc] initWithNibName:nil bundle:nil];
    InfoUserController *vc = [[InfoUserController alloc]init];
    
    NSArray *chunks10 = [mHeaderLabel.text componentsSeparatedByString:@">"];
    NSString *myString = [temp objectForKey:@"Job"];
    if (chunks10.count>1)
    {
        if (myString.length == 0) {
            vc.nameSString = [chunks10 objectAtIndex:chunks10.count-1];
        }
        else
            vc.nameSString = [NSString stringWithFormat:@"%@->%@",[chunks10 objectAtIndex:chunks10.count-1],myString];
    }
    else
        vc.nameSString = myString;
    vc.contactInfoDic = temp;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获取用户电话号码
-(NSString*)setPhone:(NSDictionary*)dic
{
    NSString *phone = @"";
    
    if ([dic[@"Phone"] hash] && (id)dic[@"Phone"] != [NSNull null])
        phone = dic[@"Phone"];
    else if ([dic[@"Tel"] hash] && (id)dic[@"Tel"] != [NSNull null])
        phone = dic[@"Tel"];
    else if ([dic[@"HomeTel"] hash] && (id)dic[@"HomeTel"] != [NSNull null])
        phone = dic[@"HomeTel"];
    
    return phone;
    
}

#pragma mark 获取用户电话号码 和名字
-(NSString*)setUserPhone:(NSDictionary*)dic
{
    NSString *phone = @"";
    
    if ([dic[@"Phone"] hash] && (id)dic[@"Phone"] != [NSNull null])
        phone = dic[@"Phone"];
    else if ([dic[@"Tel"] hash] && (id)dic[@"Tel"] != [NSNull null])
        phone = dic[@"Tel"];
    else if ([dic[@"HomeTel"] hash] && (id)dic[@"HomeTel"] != [NSNull null])
        phone = dic[@"HomeTel"];
    
    phone = [NSString stringWithFormat:@"%@    %@",dic[@"DspName"],phone];
    
    return phone;
    
}

#pragma mark 获取用户首要职位
-(NSString*)setUserJob:(NSDictionary*)dic
{
    NSString *jobTitle = @"";
    if ([dic[@"Job"] hash] && (id)dic[@"Job"] != [NSNull null])
        jobTitle = dic[@"Job"];
    
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
    NSArray *array = [OAGetGroupUsers unarchiveWithKey:@"OAGetGroupUsers"];
    for (NSMutableDictionary *temp in array)
    {
        if ([temp[@"Job"] isEqualToString:[MyArray objectForKey:@"Job"]])
        {
            NSArray *array1 = [OAGetGroupsMenu unarchiveWithKey:@"OAGetGroupsMenu"];
            for (NSMutableDictionary *temp1 in array1)
            {
                if ([temp1[@"Id"] isEqualToString:temp[@"ContactId"]]&&[temp1[@"IsShow"]  isEqualToString:@"1"])//判断没加
                {
                    NSString *string = @"";
                     if ([temp[@"Job"] hash] && (id)temp[@"Job"] != [NSNull null])
                        string = [NSString stringWithFormat:@"%@>%@",temp1[@"Name"],temp[@"Job"]];
                    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
                    [dpts addObject:string];
                }
            }
        }
    }
    
    return dpts;
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
#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *msg = searchBar.text;
    NSLog(@"%@",msg);
    [self loadSearchData:msg];
//    [mSearchResults removeAllObjects];
//    
//    if ([msg isEqualToString:@""])
//    {
//        [self upDateSous];
//        [aTableView reloadData];
//        return;
//    }
//    
//    NSArray *array = [GroupUsersMenu unarchiveWithKey:@"GroupUsersMenu"];
//    for (NSMutableDictionary *dic in array)
//    {
//        NSString * tempStr = dic[@"GPLD_UserDspName"];
//        NSRange range = [tempStr rangeOfString:msg];
//        if (range.length >0)
//        {
//            if ([self containsUser:dic] != nil)
//            {
//                [dic setObject:@"1" forKey:@"check"];
//            }
//            else
//            {
//                [dic setObject:@"0" forKey:@"check"];
//            }
//            [mSearchResults addObject:dic];
//        }
//        
//    }
//    
//    if (mSearchResults.count != 0) {
//        
//        [mSearchResults addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"check", @"0", @"全选", @"GPLD_UserDspName", nil]];
//        
//        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"GPLD_Ord" ascending:YES]];
//        [mSearchResults sortUsingDescriptors:sortDescriptors];
//    }
//    [aTableView reloadData];
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
@end


