//
//  HomeViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "HomeViewController.h"
#import "Global.h"
#import "GroupsMenu.h"
#import "BDSynthesizeSingleton.h"
#import "AddressHomeController.h"
#import "GroupUserViewController.h"
#import "LDHDViewController.h"
#import "DetialsViewController.h"
#import "NewsViewController.h"
#import "NemuViewController.h"
#import "VideoViewController.h"
#import "TSViewController.h"
#import "LeftSySViewController.h"
#import "NewsNmeuController.h"
#import "ToolCache.h"
#import "JSONKit.h"
#import "UIButton+CustomBadge.h"
#import "MapViewController.h"
//model
#import "ChildDataModel.h"
//model_end
#import "SRMModalViewController.h"
#import "ChildHomeView.h"
#import "MessageView.h"

#import "OAMessageView.h"
#import "ChildEasyListViewController.h"
#import "MonitorViewController.h"

@interface HomeViewController()<SRMModalViewControllerDelegate,ChildHomeViewDelegate,MessageViewDelegate>{
    NSMutableArray *otherArray,*otherArray2,*otherArray3;//文明内部数组,产业内部数组,银城清风
    int childCount;//子数组加载长度
    NSInteger selectChild;//记录点击的是产业还是文明
    
    NSDictionary *numberDic;//未读数量的dic
    NSArray *wmcjKeyArr,*cyfzKeyArr,*ycqfArr;//文明创建和产业发展,银城清风的key的数组
    NSString *messageRowID;//通知的RowID
    
    BOOL isTouchChild;//记录是否是点击了子列表
    NSInteger touchBtnTag;//记录点击了哪个按钮
    
    BOOL addressShowUnit;//通讯录是否显示部门通讯录
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"touchDate"];
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    
    //    UIImage *titleImage = [UIImage imageNamed:@"title"];
    //    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, titleImage.size.width*2, titleImage.size.height*2)];
    //    titleImageView.center = CGPointMake(screenMySize.size.width/2, 50);
    //    [titleImageView setImage:titleImage];
    //    [self.view addSubview:titleImageView];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    [self initFrame];
    
    [self loadOtherData:@"309"];
    //    [serive GetFromURL:AGetGroups params:nil mHttp:OA_URL isLoading:NO];
    self.navigationController.navigationBarHidden = YES;
    
    wmcjKeyArr = @[@"cjhd",@"wmdc",@"qktb"];
    cyfzKeyArr = @[@"zsyz",@"cytz",@"qyfw"];
//    ycqfArr = @[@"zrqd",@"lzck"];
    ycqfArr = @[@"qjbz",@"qjw",@"jcdw",@"jcjw"];
    [self pushCount];
    
    //获取通讯录更新
    [serive GetFromURL:ACheckCommunication params:nil mHttp:httpUrl isLoading:NO];
    //获取通知
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"" forKey:@"IMEINO"];
    [dic setValue:@"" forKey:@"OAUserID"];
    [dic setValue:@"336" forKey:@"classID"];
    [dic setValue:@"" forKey:@"lastTime"];
    [dic setValue:@"1" forKey:@"PageIndex"];
    [dic setValue:@"1" forKey:@"PageSize"];
    [serive PostFromURL:AGetNewsList params:dic mHttp:httpUrl isLoading:NO];
}
- (void)pushCount{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:[ToolCache userKey:KPhoneNumber] forKey:@"userAccount"];
    [dic setValue:@"" forKey:@"wfSubCode"];
    [dic setValue:@"" forKey:@"userGroupid"];
    [serive PostFromURL:AgetOACount params:dic mHttp:httpUrl isLoading:NO];
}
- (void)loadOtherData:(NSString *)rowID{//读取文明创建等内部数据
#warning aaa
    //文明创建
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:rowID  forKey:@"ParentID"];
    [serive PostFromURL:AGetDepartmentClassList params:postDic mHttp:httpUrl isLoading:NO];
    childCount ++;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        //        NSString* selDateString = [dateFormatter stringFromDate:[NSDate new]];
        
        NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
        //        NSLog(@"点击时间:::%@",dic);
//        NSArray *keyArray = [NSArray arrayWithObjects:@"ldhd", @"hytz",@"hyjs",@"jrtt",@"spxw",@"bmdt",@"zcdt",@"zdgc",@"lyzl",@"wmcj",@"cgzf",@"gysq",@"cyfz",@"spaq",@"xshs",@"xntb",@"gpdb",@"jjzb",@"dgdt",@"xxyd",@"zccb",@"oaxx",@"fmqc",@"",@"", nil];
        for (NSString *key in [keyDic allKeys]) {
            if ([key isEqualToString:@"文明创建"]) {
                for (int j=0; j<wmcjKeyArr.count; j++) {
                    NSString *str = [dic objectForKey:[wmcjKeyArr objectAtIndex:j]];
                    if (str==nil) {
                        str = @"";
                    }
                    [postDic setObject:str forKey:[wmcjKeyArr objectAtIndex:j]];
                }
            }else if ([key isEqualToString:@"产业发展"]){
                for (int j=0; j<cyfzKeyArr.count; j++) {
                    NSString *str = [dic objectForKey:[cyfzKeyArr objectAtIndex:j]];
                    if (str==nil) {
                        str = @"";
                    }
                    [postDic setObject:str forKey:[cyfzKeyArr objectAtIndex:j]];
                }
            }
//            else if ([key isEqualToString:@"银城清风"]){
//                for (int j=0; j<ycqfArr.count; j++) {
//                    NSString *str = [dic objectForKey:[ycqfArr objectAtIndex:j]];
//                    if (str==nil) {
//                        str = @"";
//                    }
//                    [postDic setObject:str forKey:[ycqfArr objectAtIndex:j]];
//                }
//            }
            else{
                NSString *str = [dic objectForKey:[keyDic objectForKey:key]];
                if (str==nil) {
                    str = @"";
                }
                [postDic setObject:str forKey:[keyDic objectForKey:key]];
            }
        }
        
        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
        [postDicc setObject:postDic.JSONString  forKey:@"msgNoticeTime"];
        [postDicc setObject:[ToolCache userKey:kAccount] forKey:@"UserID"];
        NSLog(@"=====%@\n%@",[ToolCache userKey:kAccount],postDicc);
        [serive PostFromURL:ACheckIfHasMsgNotice params:postDicc mHttp:httpUrl isLoading:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    
}
#pragma mark - 设置点击时间
-(void)setTouchDate:(NSInteger)btntag{
    
    //@"重点工程",@"流域治理",@"城管执法",@"工业社区",@"效能通报",@"协税护税",@"多规地图",@"经济指标",@"学习园地",@"政策采编",@"系统设置",@"通讯录"
//    NSArray *keyArray = [NSArray arrayWithObjects:@"ldhd",@"hytz",@"jrtt",@"zqdt",@"",@"bmdt",@"spxw",@"zdgc",@"lyzl",@"cgzf",@"gysq",@"",@"xshs",@"spaq",@"",@"",@"",@"",@"gpdb", @"",@"",@"", nil];
//    NSArray *keyArray = [NSArray arrayWithObjects:@"ldhd", @"hytz",@"hyjs",@"jrtt",@"spxw",@"bmdt",@"zcdt",@"zdgc",@"lyzl",@"wmcj",@"cgzf",@"gysq",@"cyfz",@"spaq",@"xshs",@"xntb",@"gpdb",@"jjzb",@"dgdt",@"xxyd",@"zccb",@"oaxx",@"fmqc",@"",@"", nil];
    isTouchChild = false;
    touchBtnTag = btntag;
    //获取服务器时间
    [serive GetFromURL:AgetServiceDateTime params:nil mHttp:httpUrl isLoading:NO];
    
#if 0
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* selDateString = [dateFormatter stringFromDate:[NSDate new]];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
    
    NSMutableDictionary *dic2;
    if (dic==nil||dic.count==0) {
        dic = [[NSMutableDictionary alloc]init];
    }
    dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (![[keyDic objectForKey:[menuArray objectAtIndex:btntag]] isEqualToString:@""]) {
        [dic2 setValue:selDateString forKey:[keyDic objectForKey:[menuArray objectAtIndex:btntag]]];
        [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"touchDate"];
    }
#endif
}
#pragma mark - 设置子列表点击时间
-(void)setChildTouchDate:(NSInteger)btntag{
    if(![[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"] && ![[menuArray objectAtIndex:selectChild] isEqualToString:@"4+X"]){
        isTouchChild = true;
        touchBtnTag = btntag;
        //获取服务器时间
        [serive GetFromURL:AgetServiceDateTime params:nil mHttp:httpUrl isLoading:NO];
    }
    
#if 0
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* selDateString = [dateFormatter stringFromDate:[NSDate new]];
    
    NSArray *keyArray;
    if ([[menuArray objectAtIndex:selectChild] isEqualToString:@"文明创建"]) {
        keyArray = wmcjKeyArr;
    }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"]){//清风
        keyArray = ycqfArr;
    }else{//招商引资
        keyArray = cyfzKeyArr;
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
    
    NSMutableDictionary *dic2;
    if (dic==nil||dic.count==0) {
        dic = [[NSMutableDictionary alloc]init];
    }
    dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (keyArray.count>btntag&&![[keyArray objectAtIndex:btntag] isEqualToString:@""]) {
        [dic2 setValue:selDateString forKey:[keyArray objectAtIndex:btntag]];
        [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"touchDate"];
    }
#endif
}
- (void)setTouchDate{
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if([urlName isEqualToString:AgetServiceDateTime]){
        NSLog(@"系统时间%@",dic);
//        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        NSString* selDateString = [dateFormatter stringFromDate:[NSDate new]];
        NSString* selDateString = dic[@"NewDataSet"][@"Table"][@"msg"][@"text"];
        if (isTouchChild) {
            NSArray *keyArray;
            if ([[menuArray objectAtIndex:selectChild] isEqualToString:@"文明创建"]) {
                keyArray = wmcjKeyArr;
            }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"]){//清风
                keyArray = ycqfArr;
            }else{//招商引资
                keyArray = cyfzKeyArr;
            }
            
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
            
            NSMutableDictionary *dic2;
            if (dic==nil||dic.count==0) {
                dic = [[NSMutableDictionary alloc]init];
            }
            dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            if (keyArray.count>touchBtnTag&&![[keyArray objectAtIndex:touchBtnTag] isEqualToString:@""]) {
                [dic2 setValue:selDateString forKey:[keyArray objectAtIndex:touchBtnTag]];
                [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"touchDate"];
            }
        }else{
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
            
            NSMutableDictionary *dic2;
            if (dic==nil||dic.count==0) {
                dic = [[NSMutableDictionary alloc]init];
            }
            dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            if (![[keyDic objectForKey:[menuArray objectAtIndex:touchBtnTag]] isEqualToString:@""]) {
                //16-12-2修改
//                if ([[menuArray objectAtIndex:touchBtnTag] isEqualToString:@"区级领导活动"]) {
//                    [dic2 setValue:selDateString forKey:[keyDic objectForKey:@"镇级和部门领导"]];
//                }
                [dic2 setValue:selDateString forKey:[keyDic objectForKey:[menuArray objectAtIndex:touchBtnTag]]];
                [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"touchDate"];
            }
        }
        
    }else if ([urlName isEqualToString:ACheckCommunication]) {
//        NSLog(@"通讯录更新:%@",dic);
        if (dic != nil) {
            if ([ToolCache userKey:KGroupVerson] == nil) {
                [ToolCache setUserStrForDictionary:dic forKey:KGroupVerson];
            }else{
                [ToolCache setUserStrForDictionary:dic forKey:KNewGroupVerson];
            }
        }
//        NSLog(@"通讯录更新:%@",[ToolCache userKeyForDictionary:KNewGroupVerson]);
    }else if ([urlName isEqualToString:AGetNewsList]){
        NSLog(@"获取通知:%@",dic);
        if (dic != nil) {
            NSArray *arr = dic[@"DataList"];
            if (arr!= nil && arr.count > 0) {
                NSDictionary *dic = [arr objectAtIndex:0];
                messageRowID = dic[@"RowID"];
                NSString *rowID = [ToolCache userKey:KMessageVerson];
//                NSString *userAccount = [NSString stringWithFormat:@"%@",[ToolCache userKey:KMessageUser]];
//                NSString *loginUser = [NSString stringWithFormat:@"%@",[ToolCache userKey:kAccount]];
                if (rowID == nil || [rowID intValue] != [messageRowID intValue]) {
                    [SRMModalViewController sharedInstance].delegate = self;
                    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
                    //    [SRMModalViewController sharedInstance].shouldRotate = NO;
                    [SRMModalViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
                    MessageView *messageView = [[MessageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, self.view.frame.size.height-100)];
                    [messageView setListData:dic];
                    [messageView setDelegate:self];
                    [[SRMModalViewController sharedInstance] showView:messageView];
                }
            }
        }
    }
    else if ([urlName isEqualToString:AGetGroups])
    {
        NSArray *array = dic[@"NewDataSet"][@"ds"];
        [array archiveWithKey:@"GroupsMenu"];
    }else if ([urlName isEqualToString:ACheckIfHasMsgNotice]){
        if (dic) {
            numberDic = dic;
//            NSArray *keyArray = [NSArray arrayWithObjects:@"ldhd", @"hytz",@"hyjs",@"jrtt",@"spxw",@"bmdt",@"zcdt",@"zdgc",@"lyzl",@"wmcj",@"cgzf",@"gysq",@"cyfz",@"spaq",@"xshs",@"xntb",@"gpdb",@"jjzb",@"dgdt",@"xxyd",@"zccb",@"oaxx",@"fmqc",@"",@"", nil];
            for (int i = 0 ; i < menuArray.count; i++)
            {
                if ([[keyDic objectForKey:[menuArray objectAtIndex:i]] length] != 0)
                {
                    UIButton* btn = (UIButton*)[self.view viewWithTag:100+i];
                    if ([[menuArray objectAtIndex:i] isEqualToString:@"文明创建"]) {//文明创建
                        [btn setBadgeWithNumber:[NSNumber numberWithInt:[[dic objectForKey:@"cjhd"] intValue]]];
                    }else if ([[menuArray objectAtIndex:i] isEqualToString:@"产业发展"]){//产业发展
                        NSArray *arr = cyfzKeyArr;
                        int num = 0;
                        for (NSString *key in arr) {
                            num += [[dic objectForKey:key] intValue];
                        }
                        [btn setBadgeWithNumber:[NSNumber numberWithInt:num]];
                    }
//                    else if ([[menuArray objectAtIndex:i] isEqualToString:@"银城清风"]){//产业发展
//                        NSArray *arr = ycqfArr;
//                        int num = 0;
//                        for (NSString *key in arr) {
//                            num += [[dic objectForKey:key] intValue];
//                        }
//                        [btn setBadgeWithNumber:[NSNumber numberWithInt:num]];
//                    }
                    //16-12-2修改,去掉原来合并
//                    else if ([[menuArray objectAtIndex:i] isEqualToString:@"区级领导活动"]){
//                        [btn setBadgeWithNumber:[NSNumber numberWithInt:[[dic objectForKey:[keyDic objectForKey:@"区级领导活动"]] intValue]+[[dic objectForKey:[keyDic objectForKey:@"镇级和部门领导"]] intValue]]];
//                    }
                    else{
                        [btn setBadgeWithNumber:[NSNumber numberWithInt:[[dic objectForKey:[keyDic objectForKey:[menuArray objectAtIndex:i]]] intValue]]];
                    }
                }
            }
        }
        
    }else if([urlName isEqualToString:AgetOACount]){
        NSArray *keyArr = @[@"TaskCount",@"SignHYTZCount",@"SignGWJHCount"];
        NSString *count;
        int num = 0;
        for (int i=0; i<keyArr.count; i++) {
            count = dic[@"NewDataSet"][@"Table"][[keyArr objectAtIndex:i]][@"text"];
            num += [count intValue];
        }
        UIButton* btn = (UIButton*)[self.view viewWithTag:121];
        [btn setBadgeWithNumber:[NSNumber numberWithInt:num]];
    }else if ([urlName isEqualToString:AGetDepartmentClassList]){
        //
        if (dic != nil) {
            NSArray *arr = (NSArray *)dic;
            if (childCount == 1) {//文明
                NSLog(@"文明：%@",dic);
                otherArray = [NSMutableArray arrayWithCapacity:arr.count];
                ChildDataModel *model;
                for (NSDictionary *d in arr) {
                    model = [[ChildDataModel alloc]initWithDictionary:d];
                    [otherArray addObject:model];
                }
                [self loadOtherData:@"310"];//读取产业数组
            }else if(childCount == 2){//产业
                NSLog(@"产业：%@",dic);
                otherArray2 = [NSMutableArray arrayWithCapacity:arr.count];
                ChildDataModel *model;
                for (NSDictionary *d in arr) {
                    model = [[ChildDataModel alloc]initWithDictionary:d];
                    [otherArray2 addObject:model];
                }
                [self loadOtherData:@"362"];//读取清风数组
            }else{
                NSLog(@"清风：%@",dic);
                otherArray3 = [NSMutableArray arrayWithCapacity:arr.count];
                ChildDataModel *model;
                for (NSDictionary *d in arr) {
                    model = [[ChildDataModel alloc]initWithDictionary:d];
                    [otherArray3 addObject:model];
                }
            }
            //            NSArray *arr2 = [arr objectAtIndex:0];
            
            //            NSLog(@"otherArray:%d",otherArray.count);
        }
    }
    
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page =scrollView.bounds.origin.x/self.view.bounds.size.width;
    ePageControl.currentPage = page;
    
}

-(void)initFrame
{
    int buttonW = screenMySize.size.width/3-30;
    int labW = 30*(iPadOrIphone);
    
    int count = 0;
    if (menuArray.count%12 != 0) {
        count = 1;
    }
    //    UIImage *titleImage = [UIImage imageNamed:@"title"];
    UIScrollView *gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-49)];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    gScrollView.pagingEnabled = YES;
    gScrollView.delegate = self;
    [self.view addSubview:gScrollView];
    [gScrollView setContentSize:CGSizeMake(((int)(menuArray.count/12)+count)*self.view.bounds.size.width,0)];
    
    ePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-49-30, screenMySize.size.width, 30)];
    [ePageControl setUserInteractionEnabled:NO];
    ePageControl.backgroundColor = [UIColor clearColor];
    ePageControl.numberOfPages = (int)(menuArray.count/12)+count;
    ePageControl.currentPage = 0;
    //    ePageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:.3 alpha:1];
    //    ePageControl.pageIndicatorTintColor = [UIColor colorWithWhite:.7 alpha:1];
    [self.view addSubview:ePageControl];
    
    CGFloat labelS = 18;
    if ([ToolCache GetPhoneDevice] <= iPhone5) {
        labelS = 16;
    }else if ([ToolCache GetPhoneDevice] >= iPhone6p){
        labelS = 21;
    }
    
    NSString *roStr = [ToolCache userKey:KAppRoleID];
    NSLog(@"roleIDArr:%@",roStr);
    for (int i = 0; i < menuArray.count; i++)
    {
        NSString *btnName = [menuArray objectAtIndex:i];//按钮的名称
        if (i == menuArray.count - 1) {
            NSLog(@"aaa");
        }
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 100;
        //        NSString *nameI = [NSString stringWithFormat:@"icon0%d.png",i+1];
        //        if (i >= 9) {
        //            nameI = [NSString stringWithFormat:@"icon%d.png",i+1];
        //        }
        [btn setBackgroundImage:[UIImage imageNamed:[menuArray objectAtIndex:i]] forState:UIControlStateNormal];
        
        [btn setBackgroundColor:[UIColor clearColor]];
        [gScrollView addSubview:btn];
        
        UILabel* label = [[UILabel alloc] init];
        label.textAlignment = 1;
        label.font = [UIFont boldSystemFontOfSize:labelS];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.text = [menuArray objectAtIndex:i];
        [gScrollView addSubview:label];
        
        [btn setFrame:CGRectMake(0, 0, buttonW, buttonW)];
        [label setFrame:CGRectMake(0, 0, screenMySize.size.width/3, labW)];
        
        int wight = screenMySize.size.width*((int)i%3)/3+screenMySize.size.width/6;
        int hight = (screenMySize.size.height-49-20)*((int)(i/3))/4;
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            hight =hight-30;
        }
        
        if (i >= 12 && i<24) {
            wight = wight + screenMySize.size.width;
            hight = hight - (screenMySize.size.height-49-20);
        }else if (i >= 24 && i<36){
            wight = wight + screenMySize.size.width*2;
            hight = hight - (screenMySize.size.height-49-20)*2;
        }else if (i >= 36 && i<48){
            wight = wight + screenMySize.size.width*3;
            hight = hight - (screenMySize.size.height-49-20)*3;
        }
        btn.center = CGPointMake(wight, hight+80);
        label.center = CGPointMake(wight, hight+80+buttonW/2);

        BOOL isGoing = NO;//no  判断权限
//        if (i == 9||i == 12||i == 17||i == 20||i == 21||i == 23||i == 24)
        if ([btnName isEqualToString:@"文明创建"]||[btnName isEqualToString:@"产业发展"]||[btnName isEqualToString:@"经济指标"]||[btnName isEqualToString:@"政策采编"]||[btnName isEqualToString:@"OA消息"]||[btnName isEqualToString:@"系统设置"]||[btnName isEqualToString:@"防讯动态"]||[btnName isEqualToString:@"公众上报"]||[btnName isEqualToString:@"防讯视频"])
        {
                isGoing = YES;
        }
        else
        {

            NSArray *controls = [roStr componentsSeparatedByString:@","];
            for (int j = 0; j < controls.count; j ++)
            {
                if ([[controls objectAtIndex:j] isEqualToString:[roleIDDic objectForKey:btnName]] || [roleIDDic[btnName] isEqualToString:@""]) {
                    
                    isGoing = YES;
                    break;
                }
            }
//            if ([[roleIDDic objectForKey:btnName] isEqualToString:@"领导活动"]) {
//                NSLog(@"领导活动领导活动领导活动领导活动领导活动,%d",isGoing);
//            }
            //如果领导活动没权限判断是否有镇级和部门领导的权限,16-12-2修改
//            if ([[roleIDDic objectForKey:btnName] isEqualToString:@"领导活动"]&&!isGoing) {
//            if ([btnName isEqualToString:@"区级领导活动"]&&!isGoing) {
//                for (int j = 0; j < controls.count; j ++)
//                {
//                    if ([[controls objectAtIndex:j] isEqualToString:[roleIDDic objectForKey:@"镇级和部门领导"]]) {
//                        isGoing = YES;
//                        break;
//                    }
//                }
//            }
            if ([btnName isEqualToString:@"通讯录"]) {
                addressShowUnit = NO;
                for (int j = 0; j < controls.count; j ++)
                {
                    //通讯录判断是否显示部门
                    if ([[controls objectAtIndex:j] isEqualToString:@"279"]) {
                        addressShowUnit = YES;
                        break;
                    }
                }
            }
        }
        
        
        if (!isGoing) {
//            if ([btnName isEqualToString:@"通讯录"]){
//                addressShowUnit = NO;
//                [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            }else{
                label.enabled = NO;
//            }
        }
        else{
//            if ([btnName isEqualToString:@"通讯录"]){
//                addressShowUnit = YES;
//            }
            [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
}

-(void)btnPressed
{
    LeftSySViewController *vc = [[LeftSySViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 跳转
-(void)btnPressed:(UIButton *)sender
{
    NSInteger tag = sender.tag - 100;
    NSString *btnName = [menuArray objectAtIndex:tag];
    
    if ([btnName isEqualToString:@"文明创建"] || [btnName isEqualToString:@"产业发展"]||[btnName isEqualToString:@"防讯动态"]||[btnName isEqualToString:@"防讯视频"])
    {
        
    }
    else
    {
        [self setTouchDate:tag];
    }
    if ([btnName isEqualToString:@"通讯录"]) {
        AddressHomeController *vc = [[AddressHomeController alloc] initWithNibName:nil bundle:nil];
        vc.groupBy = 0;
        vc.isShowUnit = addressShowUnit;
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"视频新闻"]||[btnName isEqualToString:@"今日头条"])
    {
        NewsNmeuController *vc = [[NewsNmeuController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"挂牌督办"])
    {
        NemuViewController *vc = [[NemuViewController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"效能通报"])
    {
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        [self.navigationController pushViewController:vc animated:YES];
        //        VideoViewController *vc = [[VideoViewController alloc] init];
        //        vc.title = [menuArray objectAtIndex:tag];
        //        vc.hidesBottomBarWhenPushed = YES;
        //        vc.RowID = [wfSubCodeArray objectAtIndex:tag];
        //        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (tag == 5)
//    {
//        DetialsViewController *vc = [[DetialsViewController alloc] init];
//        vc.title = [menuArray objectAtIndex:tag];
//        vc.RowID = [wfSubCodeArray objectAtIndex:tag];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    else if ([btnName isEqualToString:@"经济指标"])
    {
        TSViewController *vc = [[TSViewController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"工作手册"])
    {
        NewsNmeuController *vc = [[NewsNmeuController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"政策采编"])
    {
        //        [RequestSerive alerViewMessage:@"管委办正在开发中，敬请期待"];
        NewsNmeuController *vc = [[NewsNmeuController alloc] init];
        vc.title = [menuArray objectAtIndex:tag];
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([btnName isEqualToString:@"系统设置"])
    {
        [self btnPressed];
    }
    else if ([btnName isEqualToString:@"多规地图"])//地图
    {
        MapViewController *pushView = [[MapViewController alloc]init];
        [pushView setHidesBottomBarWhenPushed:YES];
        pushView.title = [menuArray objectAtIndex:tag];
        [self.navigationController pushViewController:pushView animated:YES];
    }
    else if ([btnName isEqualToString:@"文明创建"]||[btnName isEqualToString:@"产业发展"]||[btnName isEqualToString:@"防讯动态"]){//文明创建,产业发展,银城清风
        [self showModalView:sender];
    }
    else if ([btnName isEqualToString:@"OA消息"]){//oa消息
//        kAlertShow(@"oa消息正在开发中。");
        OAMessageView *pushView = [[OAMessageView alloc]init];
        [pushView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:pushView animated:YES];
    }
    else if ([btnName isEqualToString:@"防讯视频"]){
        MonitorViewController *pushView = [[MonitorViewController alloc]init];
        [pushView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:pushView animated:YES];
    }
    else{
//         if (tag == 0||tag == 1||tag == 3||tag ==5 ||tag == 10||tag == 9||tag == 7||tag == 8||tag == 12||tag == 13) 
        /*RowID":77,"ClassName":"领导活动
         RowID":78,"ClassName":"征拆动态
         RowID":79,"ClassName":"会议管理
         RowID":43,"ClassName":"同安今日头条
         RowID":75,"ClassName":"视频新闻
         RowID":64,"ClassName":"挂牌督办
         RowID":65,"ClassName":"效能通报*/
        LDHDViewController *vc = [[LDHDViewController alloc] init];
        if ([btnName isEqualToString:@"银城清风"]) {
            vc.title = @"责任落实";
            vc.RowID = [wfSubCodeDic objectForKey:@"责任落实"];
        }else if([btnName isEqualToString:@"4+X"]){
            //4+x
            vc.title = @"4+X";
            vc.RowID = [wfSubCodeDic objectForKey:@"清单落实"];
        }else{
            vc.title = [menuArray objectAtIndex:tag];
            vc.RowID = [wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]];
        }
        vc.hidesBottomBarWhenPushed = YES;
//        NSLog(@"===qqq,%@,%@",[wfSubCodeDic objectForKey:[menuArray objectAtIndex:tag]],[menuArray objectAtIndex:tag]);
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 子视图显示
- (void)showModalView:(UIButton *)sender {
    selectChild = sender.tag - 100;
    
    NSArray *childArray;
    NSArray *keyArr;
    if ([[menuArray objectAtIndex:selectChild] isEqualToString:@"文明创建"]) {
        if (otherArray == nil||otherArray.count == 0) {
            return;
        }
        keyArr = wmcjKeyArr;
        childArray = otherArray;
    }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"]){//清风
        if (otherArray3 == nil||otherArray3.count == 0) {
            return;
        }
        keyArr = ycqfArr;
        childArray = otherArray3;
    }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"防讯动态"]){//清风
        if (otherArray3 == nil||otherArray3.count == 0) {
            return;
        }
        keyArr = @[@"dwsb",@"",@"gzsb"];
        ChildDataModel *model = [[ChildDataModel alloc]init];
        [model setRowID:[wfSubCodeDic objectForKey:@""]];
        childArray = @[@"单位上报",@"防讯视频",@"公众上报"];
    }else{//招商引资
        if (otherArray2 == nil||otherArray2.count == 0) {
            return;
        }
        keyArr = cyfzKeyArr;
        childArray = otherArray2;
    }
    
    [SRMModalViewController sharedInstance].delegate = self;
    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
    //    [SRMModalViewController sharedInstance].shouldRotate = NO;
    [SRMModalViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    ChildHomeView *childView = [[ChildHomeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-60, 0)];
    childView.Title = [menuArray objectAtIndex:sender.tag-100];
    if([[menuArray objectAtIndex:selectChild] isEqualToString:@"防讯动态"]){
        [childView setListDataWithFix:childArray NumberDic:numberDic numberKeyArr:keyArr];
    }else{
        [childView setListData:childArray NumberDic:numberDic numberKeyArr:keyArr];
    }
    [childView setDelegate:self];
    [[SRMModalViewController sharedInstance] showView:childView];
    //    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    //    viewController.view.frame = CGRectMake(0, 0, 200, 200);
    //    [[SRMModalViewController sharedInstance] showViewWithController:viewController];
}

- (void)modalViewWillShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewWillHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)disposeModalViewControllerNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.name);
}
#pragma mark - 子视图代理
-(void)touchListByRow:(NSInteger)row{
    //    NSLog(@"点击了：%ld",row);
    NSArray *childArray;
    if ([[menuArray objectAtIndex:selectChild] isEqualToString:@"文明创建"]) {
        childArray = otherArray;
    }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"]){//清风已修改，此处暂时没有作用
        childArray = otherArray3;
    }else if([[menuArray objectAtIndex:selectChild] isEqualToString:@"防讯动态"]){//防讯动态
        [[SRMModalViewController sharedInstance] hide];
        if (row == 1){
            MonitorViewController *pushView = [[MonitorViewController alloc]init];
            [pushView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:pushView animated:YES];
        }else if (row == 0 || row == 2){
            LDHDViewController *vc = [[LDHDViewController alloc] init];
            if (row == 0) {
                vc.RowID = [wfSubCodeDic objectForKey:@"单位上报"];
                vc.title = @"单位上报";
            }else{
                vc.RowID = [wfSubCodeDic objectForKey:@"公众上报"];
                vc.title = @"公众上报";
            }
            vc.noAdd = NO;
            vc.isChild = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        return;
    }else{
        childArray = otherArray2;
    }
    [self setChildTouchDate:row];
    
    ChildDataModel *model = [childArray objectAtIndex:row];
    [[SRMModalViewController sharedInstance] hide];
    
    if (![[menuArray objectAtIndex:selectChild] isEqualToString:@"银城清风"]) {
        if ([@"web" isEqualToString:[NSString stringWithFormat:@"%@",model.IsAdd]]) {
            NSString *url = [NSString stringWithFormat:@"%@",model.Url];
            if (url.length == 0||[url isEqualToString:@"<null>"]) {
                kAlertShow(@"该功能正在开发中。");
            }else{
                MapViewController *pushView = [[MapViewController alloc]init];
                [pushView setHidesBottomBarWhenPushed:YES];
                pushView.title = model.ClassName;
                pushView.type = @"web";
                pushView.url = [NSString stringWithFormat:@"%@",model.Url];
                [self.navigationController pushViewController:pushView animated:YES];
            }
            
        }else if ([@"true" isEqualToString:[NSString stringWithFormat:@"%@",model.IsAdd]]){
            LDHDViewController *vc = [[LDHDViewController alloc] init];
            vc.title = model.ClassName;
            vc.noAdd = NO;
            vc.isChild = YES;
            vc.hidesBottomBarWhenPushed = YES;
            vc.RowID = model.RowID;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            LDHDViewController *vc = [[LDHDViewController alloc] init];
            vc.title = model.ClassName;
            vc.isChild = YES;
            vc.noAdd = YES;
            vc.hidesBottomBarWhenPushed = YES;
            vc.RowID = model.RowID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if ([@"List" isEqualToString:[NSString stringWithFormat:@"%@",model.Type]]) {
            ChildEasyListViewController *pushView = [[ChildEasyListViewController alloc]init];
            [pushView setHidesBottomBarWhenPushed:YES];
            pushView.RowID = model.RowID;
            pushView.title = model.ClassName;
            [self.navigationController pushViewController:pushView animated:YES];
        }else{//type = Page
            NewsNmeuController *vc = [[NewsNmeuController alloc] init];
            vc.title = model.ClassName;
            vc.hidesBottomBarWhenPushed = YES;
            vc.RowID = model.RowID;
            vc.isChild_Page = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)touchBody{
    [[SRMModalViewController sharedInstance] hide];
}
#pragma mark - 通知代理
-(void)touchZhiDaoLe:(BOOL)isZhiDaoLe{
    [[SRMModalViewController sharedInstance] hide];
    if (isZhiDaoLe) {
//        [ToolCache setUserStrForDictionary:messageDic forKey:KMessageVerson];
        [ToolCache setUserStr:messageRowID forKey:KMessageVerson];
//        [ToolCache setUserStr:[ToolCache userKey:kAccount] forKey:KMessageUser];
    }
}
#pragma mark - 获取oa的数量
- (void)getOaCount{
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setValue:@"gwgly" forKey:@"userAccount"];
//    [dic setValue:[NSNumber numberWithInteger:page] forKey:@"nCurPage"];
//    [dic setValue:[NSNumber numberWithInt:pageSize] forKey:@"nPageItems"];
//    
//    if ([requestUrl isEqualToString:AgetTask]) {
//        [dic setValue:@"sw|zfbfw|zffw" forKey:@"wfSubCode"];
//        [dic setValue:@"41" forKey:@"userGroupid"];
//    }
//    
//    [request PostFromURL:requestUrl params:dic mHttp:OA_URL isLoading:NO];
}
//销毁
-(void)dealloc{
    [serive cancelRequest];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
