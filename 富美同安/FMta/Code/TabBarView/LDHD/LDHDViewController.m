//
//  LDHDViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "LDHDViewController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "ToolCache.h"
#import "DetialsViewController.h"
#import "SendViewController.h"
#import "FullCutModel.h"
#import "FullCutTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NewsTableViewCell.h"
#import "NewsNmeuController.h"
#import "UIView+FrameMethods.h"
#import "UIButton+Layout.h"

//#define k4xZRCode @"552"
@interface LDHDViewController(){
    BOOL isShowComment,isCanComment;//是否可以查看评论，是否可以发表评论
    BOOL isReflash;//是否在刷新中
    
    BOOL meetting_jinshen;//新闻线索点击
    NSInteger touchRow;
    
    UIButton *ZeRenButton,*LianZhengButton;
    NSInteger selectYCQFTop;//银城顶选择
    BOOL isShowSecond,isShowThird;
    BOOL is4XLeftTouch,is4XRightTouch;//4+x责任清单点击,4+x机制体制点击
    NSMutableArray *arr4xZR,*arr4xJZ;//4+x责任清单,4+x机制体制
    NSString *leftRowID;
    NSMutableArray *ldMneuArrayOther;//修改存另一个tab集合
    NSMutableArray *ldMneuArraySeconed,*ldMneuArrayThird;
    UIButton *rightAddBtn;
    NSString *secondAllText,*thirdAllText;
    UIButton *backBtn;//后退按钮
    UIButton *otherRightTextButton;//其他种类的顶部右边按钮，如领导活动里的镇级和部门领导
    UIButton *otherLeftTextButton;//其他种类的顶部左边按钮
    NSMutableArray *OtherMenuArray,*OtherMenuSecondArray;//顶部有其他课选择的时候
    BOOL isLoadOtherMenu;
    
    BOOL isGoingLeft,isGoingRight;//领导活动这种类型的判断权限
    
    NSString *orderByString;//排序
    
    BOOL isShowReplyCompany;//是否在回复里显示部门
}
@property(nonatomic,retain) UIScrollView *otherBodyScrollView;//责任落实用
@property(nonatomic,retain) NewsNmeuController *otherNewsLeft,*otherNewsRight;
@property(nonatomic,retain) LDHDViewController *otherNewsLeft_4x;//4+x左边
@end

@implementation LDHDViewController
@synthesize mTableView,fListArray,RowID,SecondRowID,ldMneuArray,isChild,noAdd,isOther,ThirdRowID;
#define sizeHight screenMySize.size.width*.25
#define aTimeHight 20
#define oneLine 1//1=一行图片 其他为三行
- (void)viewDidLoad {
    [super viewDidLoad];
    orderByString = @"";
    _DeleteRowIDArr = [[NSMutableArray alloc]init];//删除id列表
    if ([self.title isEqualToString:@"4+X"]||[self.title isEqualToString:@"银城清风"]||[self.title isEqualToString:@"请假出差报告"]) {
        selectYCQFTop = 1;
    }else{
        selectYCQFTop = 0;
    }
    
//    bumenMenuArr = @[@"全部",@"区直部门",@"镇街场"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    menuInt = -1;
    
    if (!isChild) {
        for (int i = 0; i < menuLDArray.count; i ++) {
            if ([self.title isEqualToString:[menuLDArray objectAtIndex:i]])
            {
                menuInt = i;
                break;
            }
        }
    }else{
        menuInt = 7;//这里随便乱取，isChild=true时不需要选择下拉
    }
    if (menuInt == 28) {//区委抄告单在回复显示部门
        isShowReplyCompany = YES;
    }
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.frame.size.height-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    
    mTableView.estimatedRowHeight = 0;
    mTableView.estimatedSectionHeaderHeight = 0;
    mTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:mTableView];
    
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    scrollPanel = [[UIView alloc] initWithFrame:screenMySize];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:screenMySize];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    mTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];
    numHightArray = [[NSMutableArray alloc] init];
    //@"领导活动", @"会议管理",@"征拆动态",@"部门动态",@"城管执法",@"工业社区",@"重点工程",@"流域治理"
    if (menuInt == 1||menuInt == 5)
        [mTableView.header beginRefreshing];
    
//    if (menuInt == 0 || menuInt == 28||menuInt == 18||menuInt == 19||menuInt == 1||menuInt == 2)
    UIBarButtonItem *barItem2;
    UIBarButtonItem *rightAddItem;
    if (!noAdd)
    {
//        barItem1 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_add"] style:UIBarButtonItemStyleBordered target:self action:@selector(addSend)];
        rightAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightAddBtn setBackgroundImage:[UIImage imageNamed:@"menu_add"] forState:UIControlStateNormal];
        [rightAddBtn addTarget:self action:@selector(addSend) forControlEvents:UIControlEventTouchUpInside];
        [rightAddBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
        rightAddItem = [[UIBarButtonItem alloc]initWithCustomView:rightAddBtn];
        self.navigationItem.rightBarButtonItems = @[rightAddItem];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeader) name:KsendSuccess object:nil];
    if (menuInt == 1)
    {
        barItem2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_day"] style:UIBarButtonItemStyleBordered target:self action:@selector(bInBction)];
        self.navigationItem.rightBarButtonItems = @[rightAddItem];
//        NSString *title = self.title;
//        inButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGRect frame = CGRectMake(0,0, 100, 40);
//        [inButton setFrame:frame];
//        [inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        inButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-1];
//        [inButton addTarget:self action:@selector(showActionList) forControlEvents:UIControlEventTouchUpInside];
//        [self.navigationItem setTitleView:inButton];
//        UIImage *imageD = [UIImage imageNamed:@"bottom_arrow"];
//        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:labelSize-1]}];
//        [inButton setImage:imageD forState:UIControlStateNormal];
//        [inButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
//        [inButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
//        [inButton setTitle:title forState:UIControlStateNormal];
    }
//    else if(!noAdd){
//        self.navigationItem.rightBarButtonItems = @[rightAddItem];
//    }
    
    if ([self.title isEqualToString:@"责任落实"] ||[self.title isEqualToString:@"4+X"]){
        //两个按钮
        rightAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightAddBtn setBackgroundImage:[UIImage imageNamed:@"menu_add"] forState:UIControlStateNormal];
        [rightAddBtn addTarget:self action:@selector(addSend) forControlEvents:UIControlEventTouchUpInside];
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
        //左右列表
        ZeRenButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [ZeRenButton setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [ZeRenButton.layer setCornerRadius:4.0];
        [ZeRenButton setClipsToBounds:YES];
        [ZeRenButton setTitle:@"责任清单" forState:0];
        [ZeRenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [ZeRenButton setTitleColor:blueFontColor forState:UIControlStateSelected];
        [ZeRenButton setBackgroundImage:nil forState:UIControlStateNormal];
        [ZeRenButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [ZeRenButton addTarget:self action:@selector(ZeRenAction) forControlEvents:UIControlEventTouchUpInside];
        /*廉政*/
        LianZhengButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [LianZhengButton setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [LianZhengButton.layer setCornerRadius:4.0];
        [LianZhengButton setClipsToBounds:YES];
        if ([self.title isEqualToString:@"4+X"]) {
            [ZeRenButton setTitle:@"\"x\"机制" forState:0];
            [LianZhengButton setTitle:@"机制体制" forState:0];
        }else{
            [LianZhengButton setTitle:@"廉政参考" forState:0];
        }
        [LianZhengButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [LianZhengButton setTitleColor:blueFontColor forState:UIControlStateSelected];
        [LianZhengButton setBackgroundImage:nil forState:UIControlStateNormal];
        [LianZhengButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [LianZhengButton addTarget:self action:@selector(LianZhengAction) forControlEvents:UIControlEventTouchUpInside];
//        NSLog(@"phoneDevice==%ld",[ToolCache GetPhoneDevice]);
        if ([ToolCache GetPhoneDevice] <= iPhone5) {
            if ([self.title isEqualToString:@"4+X"]){
                [rightAddBtn setFrame:CGRectMake(0, 0, 30*.5, 34*.5)];
                [backBtn setFrame:CGRectMake(0, 0, 30*.5, 34*.5)];
                [ZeRenButton setFrame:CGRectMake(0, 0, 75, 35)];
                [LianZhengButton setFrame:CGRectMake(0, 0, 75, 35)];
                //            LianZhengButton.titleLabel
                ZeRenButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-5];
                LianZhengButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-5];
                
                UIImage *imageD = [UIImage imageNamed:@"bottom_arrow"];
                UIImage *imageD_press = [UIImage imageNamed:@"bottom_arrow_press"];
                
                [ZeRenButton setImage:imageD forState:UIControlStateNormal];
                [ZeRenButton setImage:imageD_press forState:UIControlStateSelected];
                [ZeRenButton layoutButtonForTitle:@"\"x\"机制" titleFont:[UIFont systemFontOfSize:labelSize-5] image:imageD gapBetween:3 layType:0];
                
                [LianZhengButton setImage:imageD forState:UIControlStateNormal];
                [LianZhengButton setImage:imageD_press forState:UIControlStateSelected];
                [LianZhengButton layoutButtonForTitle:@"体制机制" titleFont:[UIFont systemFontOfSize:labelSize-5] image:imageD gapBetween:3 layType:0];
            }else{
                [rightAddBtn setFrame:CGRectMake(0, 0, 37*.5, 34*.5)];
                [backBtn setFrame:CGRectMake(0, 0, 37*.5, 34*.5)];
                [ZeRenButton setFrame:CGRectMake(0, 0, 60, 35)];
                [LianZhengButton setFrame:CGRectMake(0, 0, 60, 35)];
                //            LianZhengButton.titleLabel
                ZeRenButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-4];
                LianZhengButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-4];
            }
            
        }else{
            [rightAddBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
            [backBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
            if ([ToolCache GetPhoneDevice] == iPhone6p) {
                [ZeRenButton setFrame:CGRectMake(0, 0, 100, 35)];
                [LianZhengButton setFrame:CGRectMake(0, 0, 100, 35)];
            }else{
                [ZeRenButton setFrame:CGRectMake(0, 0, 80, 35)];
                [LianZhengButton setFrame:CGRectMake(0, 0, 80, 35)];
            }
            ZeRenButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-2];
            LianZhengButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-2];
        }
        //
        UIBarButtonItem *barItem3 = [[UIBarButtonItem alloc]initWithCustomView:rightAddBtn];
        UIBarButtonItem *LianZhengBarItem = [[UIBarButtonItem alloc]initWithCustomView:LianZhengButton];
        
        self.navigationItem.rightBarButtonItems = @[barItem3,LianZhengBarItem];
        //
        UIBarButtonItem *leftBarItem1 = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        UIBarButtonItem *ZeRenBarItem = [[UIBarButtonItem alloc]initWithCustomView:ZeRenButton];
        self.navigationItem.leftBarButtonItems = @[leftBarItem1,ZeRenBarItem];
        
        [mTableView removeFromSuperview];
        //滚动视图
        self.otherBodyScrollView = [[UIScrollView alloc]initWithFrame:mTableView.frame];
        [self.otherBodyScrollView setDelegate:self];
        [self.otherBodyScrollView setPagingEnabled:YES];
        [self.otherBodyScrollView setContentSize:CGSizeMake(self.view.frame.size.width*3, self.otherBodyScrollView.frame.size.height)];
        [self.view addSubview:self.otherBodyScrollView];
        //mTableView ＝ 责任落实列表
        [mTableView setFrame:CGRectMake(screenMySize.size.width, 0, screenMySize.size.width, self.otherBodyScrollView.frame.size.height)];
        [self.otherBodyScrollView addSubview:mTableView];
        //
        if ([self.title isEqualToString:@"4+X"]) {
            self.otherNewsLeft_4x = [[LDHDViewController alloc]init];
            self.otherNewsLeft_4x.title = @"\"x\"机制";
            self.otherNewsLeft_4x.RowID = [wfSubCodeDic objectForKey:@"\"x\"机制"];//4+x的责任清单和银城清风的责任清单同名
            self.otherNewsLeft_4x.isOther = YES;
            [self addChildViewController:self.otherNewsLeft_4x];
            [self.otherBodyScrollView addSubview:self.otherNewsLeft_4x.view];
        }else{
            self.otherNewsLeft = [[NewsNmeuController alloc] init];
            [self.otherNewsLeft.view setFrame:CGRectMake(0, 0, screenMySize.size.width, self.otherBodyScrollView.frame.size.height)];
            self.otherNewsLeft.isOther_Page = YES;
            self.otherNewsLeft.RowID = [wfSubCodeDic objectForKey:@"责任清单"];
            self.otherNewsLeft.title = @"责任清单";
            [self addChildViewController:self.otherNewsLeft];
            [self.otherBodyScrollView addSubview:self.otherNewsLeft.view];
        }
        
        //
        self.otherNewsRight = [[NewsNmeuController alloc] init];
        self.otherNewsRight.isOther_Page = YES;
        [self.otherNewsRight.view setFrame:CGRectMake(screenMySize.size.width*2, 0, screenMySize.size.width, self.otherBodyScrollView.frame.size.height)];
        if ([self.title isEqualToString:@"4+X"]) {
            self.otherNewsRight.title = @"机制体制";
            self.otherNewsRight.RowID = [wfSubCodeDic objectForKey:@"机制体制"];
        }else{
            self.otherNewsRight.title = @"廉政参考";
            self.otherNewsRight.RowID = [wfSubCodeDic objectForKey:@"廉政参考"];
        }
        
        [self addChildViewController:self.otherNewsRight];
        [self.otherBodyScrollView addSubview:self.otherNewsRight.view];
        
        [self.otherBodyScrollView setContentOffset:CGPointMake(screenMySize.size.width, 0) animated:NO];
        //4+x责任清单添加点击图片
        if ([self.title isEqualToString:@"4+X"] && [ToolCache GetPhoneDevice] > iPhone5) {
            UIImage *imageD = [UIImage imageNamed:@"bottom_arrow"];
            UIImage *imageD_press = [UIImage imageNamed:@"bottom_arrow_press"];
            
            CGSize titleSize = [@"体制机制" sizeWithAttributes:@{NSFontAttributeName: ZeRenButton.titleLabel.font}];
            [ZeRenButton setFrame:CGRectMake(ZeRenButton.frame.origin.x, ZeRenButton.frame.origin.y, titleSize.width+20, ZeRenButton.frame.size.height)];
            [ZeRenButton setImage:imageD forState:UIControlStateNormal];
            [ZeRenButton setImage:imageD_press forState:UIControlStateSelected];
            [ZeRenButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
            [ZeRenButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
            
            [LianZhengButton setFrame:CGRectMake(ZeRenButton.frame.origin.x, ZeRenButton.frame.origin.y, titleSize.width+20, ZeRenButton.frame.size.height)];
            [LianZhengButton setImage:imageD forState:UIControlStateNormal];
            [LianZhengButton setImage:imageD_press forState:UIControlStateSelected];
            [LianZhengButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
            [LianZhengButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
        }
//        self.otherTableLeft = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.otherBodyScrollView.frame.size.height)];
//        self.otherTableLeft.delegate = self;
//        self.otherTableLeft.dataSource = self;
//        self.otherTableLeft.backgroundColor = [UIColor clearColor];
//        [self.otherTableLeft setTableFooterView:[[UIView alloc] init]];
//        [self.otherBodyScrollView addSubview:self.otherTableLeft];
//        //
//        self.otherTableRight = [[UITableView alloc] initWithFrame:CGRectMake(screenMySize.size.width*2, 0, screenMySize.size.width, self.otherBodyScrollView.frame.size.height)];
//        self.otherTableRight.delegate = self;
//        self.otherTableRight.dataSource = self;
//        self.otherTableRight.backgroundColor = [UIColor clearColor];
//        [self.otherTableRight setTableFooterView:[[UIView alloc] init]];
//        [self.otherBodyScrollView addSubview:self.otherTableRight];
    }
    else if ([self.title rangeOfString:@"领导活动"].location != NSNotFound||[self.title rangeOfString:@"请假出差报告"].location != NSNotFound || [self.title isEqualToString:@"区委抄告单"]||[self.title rangeOfString:@"流域治理"].location != NSNotFound){
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        UIBarButtonItem *titleBarItem = nil;
        if ([self.title isEqualToString:@"请假出差报告"]) {
            otherLeftTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [LianZhengButton setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
            [otherLeftTextButton.layer setCornerRadius:4.0];
            [otherLeftTextButton setClipsToBounds:YES];
            [otherLeftTextButton setTitle:@"区级领导" forState:0];
            [otherLeftTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [otherLeftTextButton setBackgroundImage:nil forState:UIControlStateNormal];
            [otherLeftTextButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
            [otherLeftTextButton setTitleColor:blueFontColor forState:UIControlStateSelected];
            [otherLeftTextButton addTarget:self action:@selector(GetFirstMenu:) forControlEvents:UIControlEventTouchUpInside];
            titleBarItem = [[UIBarButtonItem alloc]initWithCustomView:otherLeftTextButton];
            
            inButton = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect frame = CGRectMake(0,0, 200, 35);
            [inButton setFrame:frame];
            [inButton.layer setCornerRadius:4.0];
            [inButton setClipsToBounds:YES];
            
            [inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [inButton setTitleColor:blueFontColor forState:UIControlStateSelected];
            [inButton setBackgroundImage:nil forState:UIControlStateNormal];
            [inButton addTarget:self action:@selector(GetFirstMenu:) forControlEvents:UIControlEventTouchUpInside];
            [inButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
            [inButton setSelected:YES];
            [self.navigationItem setTitleView:inButton];
            inButton.titleLabel.font = [UIFont systemFontOfSize:labelSize - 5];
            [self setIntPath:0];
            
        }else if ([self.title isEqualToString:@"区委抄告单"]){
            [self.navigationItem setTitleView:[[UIView alloc] init]];
            titleBarItem = [[UIBarButtonItem alloc] initWithTitle:@"抄告单下达" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }else if ([self.title isEqualToString:@"流域治理"]){
            [self.navigationItem setTitleView:[[UIView alloc] init]];
            titleBarItem = [[UIBarButtonItem alloc] initWithTitle:@"流域治理" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }else{
            [self.navigationItem setTitleView:[[UIView alloc] init]];
            titleBarItem = [[UIBarButtonItem alloc] initWithTitle:@"治理督导" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }
        //判断权限 16-12-2修改去掉原来合并的权限
//        NSString *roStr = [ToolCache userKey:KAppRoleID];
//        NSArray *controls = [roStr componentsSeparatedByString:@","];
//        for (int j = 0; j < controls.count; j ++)
//        {
//            //NSLog(@"----=====%@",controls);
//            if ([[controls objectAtIndex:j] isEqualToString:[roleIDDic objectForKey:@"领导活动"]]) {
//                isGoingLeft = YES;
//            }
//            if ([[controls objectAtIndex:j] isEqualToString:[roleIDDic objectForKey:@"镇级和部门领导"]]) {
//                isGoingRight = YES;
//            }
//        }
        //16-12-2修改
        isGoingLeft = YES;
        isGoingRight = YES;
        //如果领导活动没权限判断是否有镇级和部门领导的权限
        if (isGoingRight) {
            otherRightTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [LianZhengButton setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
            [otherRightTextButton.layer setCornerRadius:4.0];
            [otherRightTextButton setClipsToBounds:YES];
            
            [otherRightTextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [otherRightTextButton setBackgroundImage:nil forState:UIControlStateNormal];
            
            if (isGoingLeft) {
                [otherRightTextButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
                [otherRightTextButton setTitleColor:blueFontColor forState:UIControlStateSelected];
            }
            if ([self.title isEqualToString:@"请假出差报告"]){
                [otherRightTextButton setTitle:@"镇级领导" forState:0];
                [otherRightTextButton addTarget:self action:@selector(GetFirstMenu:) forControlEvents:UIControlEventTouchUpInside];
            }else if([self.title isEqualToString:@"区委抄告单"]){
                [otherRightTextButton setTitle:@"抄告单反馈" forState:0];
                [otherRightTextButton addTarget:self action:@selector(aInBction:) forControlEvents:UIControlEventTouchUpInside];
            }else if([self.title isEqualToString:@"流域治理"]){
                [otherRightTextButton setTitle:@"治理督导" forState:0];
                [otherRightTextButton addTarget:self action:@selector(aInBction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                [otherRightTextButton setTitle:@"定期工作计划" forState:0];
                [otherRightTextButton addTarget:self action:@selector(aInBction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //        NSLog(@"phoneDevice==%ld",[ToolCache GetPhoneDevice]);
//            [otherRightTextButton setFrame:CGRectMake(0, 0, 130, 35)];
            //        [otherRightTextButton.titleLabel setFont:[UIFont systemFontOfSize:labelSize]];
            
//            otherRightTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-1];
            
            if (!isGoingLeft) {
                selectYCQFTop = 1;
                [self.navigationItem setTitleView:otherRightTextButton];
                self.navigationItem.rightBarButtonItems = @[rightAddItem];
            }else{
                UIBarButtonItem *LianZhengBarItem = [[UIBarButtonItem alloc]initWithCustomView:otherRightTextButton];
                self.navigationItem.rightBarButtonItems = @[rightAddItem,LianZhengBarItem];
                
                [self.navigationItem setLeftBarButtonItems:@[backBarItem,titleBarItem]];
            }
            if ([ToolCache GetPhoneDevice] <= iPhone5||[self.title isEqualToString:@"请假出差报告"]) {
                if ([self.title isEqualToString:@"请假出差报告"]&&[ToolCache GetPhoneDevice] <= iPhone5)
                {
                    [rightAddBtn setFrame:CGRectMake(0, 0, 37*.4, 34*.4)];
                    [backBtn setFrame:CGRectMake(0, 0, 37*.4, 34*.4)];
                    [otherRightTextButton setFrame:CGRectMake(0, 0, 110, 35)];
                    
                    if (otherLeftTextButton != nil) {//左边的按钮，请假出差报告用
                        [otherLeftTextButton setFrame:CGRectMake(0, 0, 110, 35)];
                        otherLeftTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-5];
                    }
                    otherRightTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-5];
                }else{
                    [rightAddBtn setFrame:CGRectMake(0, 0, 37*.5, 34*.5)];
                    [backBtn setFrame:CGRectMake(0, 0, 37*.5, 34*.5)];
                    [otherRightTextButton setFrame:CGRectMake(0, 0, 110, 35)];
                    
                    if (otherLeftTextButton != nil) {//左边的按钮，请假出差报告用
                        [otherLeftTextButton setFrame:CGRectMake(0, 0, 110, 35)];
                        otherLeftTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-4];
                    }
                    otherRightTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-4];
                }
                
            }else{
                [rightAddBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
                [backBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
                [otherRightTextButton setFrame:CGRectMake(0, 0, 130, 35)];
                
                if (otherLeftTextButton != nil) {//左边的按钮，请假出差报告用
                    [otherLeftTextButton setFrame:CGRectMake(0, 0, 130, 35)];
                    otherLeftTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-2];
                }
                otherRightTextButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-2];
            }
            [self setButtonTitleWithOther];
            
        }else{
            
            [self.navigationItem setLeftBarButtonItems:@[backBarItem]];
        }
    }
    
    LDStr = @"";
    if (isOther||[self.title isEqualToString:@"新闻线索"]||[self.title isEqualToString:@"招商引资"]||[self.title isEqualToString:@"企业服务"]||[self.title rangeOfString:@"请假出差报告"].location != NSNotFound) {
        [mTableView.header beginRefreshing];
    }else{
        if ([self.title isEqualToString:@"领导活动"]&&!isGoingLeft) {//16-12-2修改此判断暂时无用
            self.title = @"镇级和部门领导";
            RowID = [wfSubCodeDic objectForKey:@"镇级和部门领导"];
            [self ReloadThe];
        }else{
            if (ldMneuArray.count == 0) {
                ldMneuArray = [[NSMutableArray alloc] init];
                if (menuInt == 2) {
                    [serive PostFromURL:AGetZengCaiList params:nil mHttp:httpUrl isLoading:NO];
                }
                if (menuInt == 0 ||  menuInt == 28) {
                    [serive GetFromURL:AOAGetDept params:nil mHttp:httpUrl isLoading:NO];
                }else if (menuInt == 1||menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ||menuInt == 4||menuInt == 6 || menuInt == 31 ||menuInt == 33 || menuInt == 34 || menuInt == 32 ||menuInt == 27 || menuInt == 22||menuInt == 23|| menuInt == 17||menuInt == 7||menuInt == 8 || menuInt == 9|| menuInt == 10 || menuInt == 11|| menuInt == 12|| menuInt == 13|| menuInt == 15|| menuInt == 16 || menuInt == 24||menuInt == 18||menuInt == 19||menuInt == 20||menuInt == 21)
                {
                    if (isChild) {
                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                        [postDicc setObject:RowID  forKey:@"ParentID"];
                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                    }else{
                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                        if (menuInt ==7) {
                            ldMneuArrayOther = [NSMutableArray array];
                            [postDicc setObject:[wfSubCodeDic objectForKey:@"治理督导"]  forKey:@"ParentID"];
                            RowID = @"824";
                            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                        }
                        [postDicc setObject:[wfSubCodeLDArray objectAtIndex:menuInt]  forKey:@"ParentID"];
                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];

                    }
                }
            }
            else
            {
                [self setZengCaiList];
            }
        }
        
    }
    
    //下载按钮
    downBtn = [[UIButton alloc]initWithFrame:CGRectMake(scrollPanel.frame.size.width - 90, scrollPanel.frame.size.height - 90, 60, 60)];
    [downBtn addTarget:self action:@selector(touchDownLoad) forControlEvents:UIControlEventTouchUpInside];
    [downBtn.layer setCornerRadius:30];
    [downBtn setClipsToBounds:YES];
    [downBtn setBackgroundColor:[UIColor whiteColor]];
    [downBtn setTitleColor:[UIColor blackColor] forState:0];
    [downBtn setTitle:@"下载" forState:0];
    [scrollPanel addSubview:downBtn];
    [self pdRole];
}

-(void)LianZhengAction{
    if (LianZhengButton.selected) {
        is4XRightTouch = YES;
        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
        [postDicc setObject:[wfSubCodeDic objectForKey:@"机制体制"] forKey:@"ParentID"];
        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
    }
    [self changeTopColor:2];
    [self.otherBodyScrollView setContentOffset:CGPointMake(screenMySize.size.width*2, 0) animated:YES];
}

//- (void)DuChaAction {
//    if (selectYCQFTop == 1) {
////        [OtherMenuSecondArray removeAllObjects];
////        OtherMenuSecondArray = nil;//置空，用于判断
//        if (OtherMenuArray == nil) {
//            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//            [postDicc setObject:RowID  forKey:@"ParentID"];
//            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
//    }
//        [self changeTopColor:0];
//}
//}

-(void)ZeRenAction{
    if (ZeRenButton.selected) {
        is4XLeftTouch = YES;
        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
        [postDicc setObject:[wfSubCodeDic objectForKey:@"\"x\"机制"]  forKey:@"ParentID"];
        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
    }
    [self changeTopColor:0];
    [self.otherBodyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)otherTopSelectAction{
    
    //暂留，现在仅仅领导活动存在这个方式,16-12-2已经分开
    RowID = wfSubCodeDic[self.title];
    [inButton setTitle:@"每日工作安排" forState:0];
    if (selectYCQFTop == 1) {
        [OtherMenuSecondArray removeAllObjects];
        OtherMenuSecondArray = nil;//置空，用于判断
        //读取顶部其他的列表
        if (OtherMenuArray == nil) {
            isLoadOtherMenu = true;
            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
            [postDicc setObject:RowID  forKey:@"ParentID"];
            [postDicc setObject:@"regular" forKey:@"TabClass"];
            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
        }else{
            [self showOtherMenuAction:OtherMenuArray];
        }
        //顺序问题，放两个
        [self changeTopColorForTwo:1];
    }else{
        [self changeTopColorForTwo:1];
        [self ReloadThe];
    }
}
#pragma mark - 顶部选择，两个的情况，领导活动用
- (void)changeTopColorForTwo:(int)ChangeIndex{
    selectYCQFTop = ChangeIndex;
    switch (ChangeIndex) {
        case 0:
            [inButton setSelected:YES];
            [otherRightTextButton setSelected:NO];
            break;
        case 1:
            [inButton setSelected:NO];
            [otherRightTextButton setSelected:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark - 顶部选择，三个的情况，请假出差报告用
- (void)changeTopColorForThree:(NSInteger)ChangeIndex{
    switch (ChangeIndex) {
        case 0:
            [otherLeftTextButton setSelected:YES];
            [inButton setSelected:NO];
            [otherRightTextButton setSelected:NO];
            break;
        case 1:
            [otherLeftTextButton setSelected:NO];
            [inButton setSelected:YES];
            [otherRightTextButton setSelected:NO];
            break;
        case 2:
            [otherLeftTextButton setSelected:NO];
            [inButton setSelected:NO];
            [otherRightTextButton setSelected:YES];
            break;
            
        default:
            break;
    }
}
#pragma mark - 顶部选择，银城清风用
-(void)changeTopColor:(int)ChangeIndex{
    selectYCQFTop = ChangeIndex;
    switch (ChangeIndex) {
        case 0:
            if ([self.title isEqualToString:@"4+X"]) {
                [rightAddBtn setHidden:NO];//右边添加按钮
            }else{
                [rightAddBtn setHidden:YES];//右边添加按钮
            }
            [ZeRenButton setSelected:YES];
            [inButton setSelected:NO];
            [LianZhengButton setSelected:NO];
            break;
        case 1:
            [rightAddBtn setHidden:NO];
            [ZeRenButton setSelected:NO];
            [inButton setSelected:YES];
            [LianZhengButton setSelected:NO];
            break;
        case 2:
            [rightAddBtn setHidden:YES];
            [ZeRenButton setSelected:NO];
            [inButton setSelected:NO];
            [LianZhengButton setSelected:YES];
            break;
            
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)popself{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 判断权限
-(void)pdRole{
    NSLog(@"RowIDRowID::%@",RowID);
    isShowComment = NO;
    isCanComment = NO;
    
    NSString *roStr = [ToolCache userKey:KAppRoleID];
    NSArray *controls = [roStr componentsSeparatedByString:@","];
    for (int i = 0;i < controls.count;i++)
    {
        //                NSLog(@"----=====%@",controls);
        if ([[controls objectAtIndex:i] isEqualToString:@"132"]) {//判断是否有可以查看的权限
            isShowComment = YES;
//            break;
        }else if ([[controls objectAtIndex:i] isEqualToString:@"236"]){//判断可以评论的权限：236
            isCanComment = YES;
        }
    }
    
}

-(void)touchDownLoad{
    TapImageView *tmpView = (TapImageView *)[self.view viewWithTag:10000*tagRow + (int)(myScrollView.contentOffset.x/screenMySize.size.width)];
    LongImg = tmpView.image;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定保存该图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}
#pragma mark  选择日期返回
-(void)getTime:(NSString*)aTag setIndex:(int)index
{
    if (index == 0) {
        timeString = aTag;
    }
    else
        timeEndString = aTag;
    //
    //    [self setHeader];
}

#pragma mark  选择日期
-(void)bInBction
{
    CalendarViewController *vc = [[CalendarViewController alloc] init];
    vc.title = self.title;
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)showActionList{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"会议管理"];
    [actionSheet addButtonWithTitle:@"新闻线索"];
    actionSheet.tag = 200;
    //    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
-(void)setZengCaiList
{
//    if (menuInt != 1) {
        inButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0,0, 200, 35);
        [inButton setFrame:frame];
        [inButton.layer setCornerRadius:4.0];
        [inButton setClipsToBounds:YES];
    
        [inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [inButton setTitleColor:blueFontColor forState:UIControlStateSelected];
        [inButton setBackgroundImage:nil forState:UIControlStateNormal];
        [inButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
    
        if ([self.title isEqualToString:@"责任落实"] ||[self.title isEqualToString:@"4+X"]) {
            
            
//            [inButton setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [inButton setSelected:YES];
            [self.navigationItem setTitleView:inButton];
        }
        else if([self.title rangeOfString:@"领导活动"].location != NSNotFound || [self.title isEqualToString:@"区委抄告单"]|| [self.title isEqualToString:@"流域治理"])
        {//领导活动
//            self.title = nil;
//            [self.navigationItem setTitleView:inButton];
            [inButton setSelected:YES];
            if (isGoingLeft&&isGoingRight)
            {
                UIBarButtonItem *leftBarItem1 = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
                UIBarButtonItem *inButtonItem = [[UIBarButtonItem alloc]initWithCustomView:inButton];
                self.navigationItem.leftBarButtonItems = @[leftBarItem1,inButtonItem];
                
                [self.navigationItem setTitleView:[[UIView alloc] init]];
            }else if(isGoingLeft){
                [inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [inButton setBackgroundImage:nil forState:UIControlStateSelected];
                
                [self.navigationItem setTitleView:inButton];
            }else{
//                [self.navigationItem setTitleView:inButton];
            }
            
        }
        else
        {
            [self.navigationItem setTitleView:inButton];
//            [inButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    
        if ([ToolCache GetPhoneDevice] <= iPhone5) {
            if ([self.title isEqualToString:@"4+X"]) {
                inButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-5];
            }else{
                inButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-4];
            }
        }else{
            inButton.titleLabel.font = [UIFont systemFontOfSize:labelSize-2];
        }
    
    [inButton addTarget:self action:@selector(aInBction:) forControlEvents:UIControlEventTouchUpInside];
    
        [self setIntPath:0];
//    }
}

-(void)setIntPath:(int)path
{
    NSString *title = nil;
    if (path == 0) {
        if ([self.title isEqualToString:@"责任落实"]) {
            title = @"责任落实";
        }
        else if ([self.title isEqualToString:@"4+X"]){
            title = @"责任落实";
        }
        //16-12-2修改
        else if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
            title = @"每日工作安排";
        }
        else if ([self.title rangeOfString:@"区委抄告单"].location != NSNotFound) {
            title = @"抄告单下达";
        }
        else if ([self.title rangeOfString:@"流域治理"].location != NSNotFound) {
            title = @"流域治理";
        }
        else if([self.title isEqualToString:@"请假出差报告"]){
            title = @"部门领导";
        }
        else{
            title = self.title;
        }
        if (!isChild) {
            RowID = [wfSubCodeLDArray objectAtIndex:menuInt];
        }
    }
    else
    {
        path --;
        title =ldMneuArray[path][@"ClassName"];
        RowID = ldMneuArray[path][@"RowID"];
    }
    [inButton setTitle:title forState:UIControlStateNormal];
    if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
        [self setInButtonSize];//重新设置长度
    }
    [self setButtonTitle];
    
    [self setHeader];
    
}
#pragma mark - 设置顶部选择按钮的长度
- (void) setInButtonSize{
    NSDictionary *attribute = @{NSFontAttributeName:inButton.titleLabel.font};
    CGSize titleSize = [inButton.titleLabel.text boundingRectWithSize:CGSizeMake(screenMySize.size.width-150, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [inButton setFrame:CGRectMake(inButton.frame.origin.x,inButton.frame.origin.y, titleSize.width+40, inButton.frame.size.height)];
//    [inButton setWidth:titleSize.width];
}
#pragma mark - 获取第一级菜单
-(void)GetFirstMenu:(UIButton *)btn{
    //暂留，现在仅请假出差报告存在这个方式
    if (btn == otherLeftTextButton) {
        RowID = @"77";
        selectYCQFTop = 0;
    }else if (btn == inButton){
        RowID = @"432";
        selectYCQFTop = 1;
    }else if (btn == otherRightTextButton){
        RowID = @"527";
        selectYCQFTop = 2;
    }
    
    if (btn.selected) {
        [OtherMenuArray removeAllObjects];
        OtherMenuArray = nil;//置空，用于判断
        [OtherMenuSecondArray removeAllObjects];
        OtherMenuSecondArray = nil;//置空，用于判断
        //读取顶部其他的列表
        //    if (OtherMenuArray == nil) {
        isLoadOtherMenu = true;
        
        if (btn == otherLeftTextButton) {
            [serive GetFromURL:AOAGetDept params:nil mHttp:httpUrl isLoading:NO];
        }else{
            
            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
            [postDicc setObject:RowID  forKey:@"ParentID"];
            [postDicc setObject:@"leave" forKey:@"TabClass"];
            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
            
            
        }
    }else{
        [self ReloadThe];
    }
    [self changeTopColorForThree:selectYCQFTop];
//    if (selectYCQFTop == 1) {
//        
//        //顺序问题，放两个
//        
//    }else if(selectYCQFTop == 2){
//        
//    }else{
//        [self changeTopColorForTwo:1];
//        [self ReloadThe];
//    }
}
#pragma mark - 原来获取中间菜单
-(void)aInBction:(UIButton *)btn
{
    if (menuInt == 0 || menuInt == 28||menuInt == 18||menuInt == 19||menuInt == 27 || menuInt == 22||menuInt == 23|| menuInt == 17||menuInt == 7)//领导活动
    {
        if (btn == inButton) {
            if (selectYCQFTop == 0) {
                if (menuInt == 18||menuInt == 19) {
                    [self aTCQ];
                }else if (menuInt == 7) {
                    [self aTCQ];
                }
                else if (menuInt == 28){
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
                    NSArray *controls = @[@"按发布时间",@"按最新回复时间"];
                    for (int i = 0; i < controls.count; i ++)
                    {
                        [actionSheet addButtonWithTitle:[controls objectAtIndex:i]];
                    }
                    actionSheet.tag = 300;
                    [actionSheet showInView:self.view];
//                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                    [dic setValue:@"区委" forKey:@"dept"];
//                    [serive PostFromURL:AOAGetLeader params:dic mHttp:httpUrl isLoading:NO];
                }else{
                    [self aTLD];
                }
                
            }else{
                secondAllText = nil;
                //16-12-2修改
//                [otherRightTextButton setTitle:@"定期工作计划" forState:0];
//                [self setButtonTitleWithOther];
//
                selectYCQFTop = 0;
                RowID = [wfSubCodeLDArray objectAtIndex:menuInt];
                [self ReloadThe];
            }
            [self changeTopColorForTwo:0];
        }else if (btn == otherRightTextButton){
            if (selectYCQFTop == 1) {
                if (menuInt == 18||menuInt == 19) {
                    [self aTCQ];
                }else if (menuInt == 28){
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
                    NSArray *controls = @[@"默认排序",@"按回复时间排序"];
                    [actionSheet addButtonWithTitle:@"全部"];
                    for (int i = 0; i < controls.count; i ++)
                    {
                        [actionSheet addButtonWithTitle:[controls objectAtIndex:i]];
                    }
                    actionSheet.tag = 300;
                    [actionSheet showInView:self.view];
                    
//                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                    [dic setValue:@"区委" forKey:@"dept"];
//                    [serive PostFromURL:AOAGetLeader params:dic mHttp:httpUrl isLoading:NO];
                }else if (menuInt == 7) {
//                    [self DuChaAction];
                    [self aTCQ];
                    [self changeTopColorForTwo:1];
                }
                else{
                    [self aTLD];
                }
            }else{
                secondAllText = nil;
                selectYCQFTop = 1;
                
                if ([self.title isEqualToString:@"流域治理"]) {
                    RowID = [wfSubCodeDic objectForKey:@"治理督导"];
//                        ldMneuArray = [NSMutableArray array];
//                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//                        [postDicc setObject:RowID  forKey:@"ParentID"];
//                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                }else{
                
                RowID = [wfSubCodeLDArray objectAtIndex:menuInt];
                }
                [self ReloadThe];
            }
            [self changeTopColorForTwo:1];
        }
        
        return;
    }
    if (menuInt == 1||menuInt == 2||menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30||menuInt == 4||menuInt == 6 || menuInt == 31 ||menuInt == 33 || menuInt == 34 || menuInt == 32 ||menuInt == 8 || menuInt == 9||menuInt ==10|| menuInt == 11|| menuInt == 12|| menuInt == 13|| menuInt == 15|| menuInt == 16 || menuInt == 24|| menuInt == 21)
    {
        if (menuInt == 16 || menuInt == 24) {//责任落实
            if (selectYCQFTop == 1) {
                [self aTCQ];
            }
            [self changeTopColor:1];
            [self.otherBodyScrollView setContentOffset:CGPointMake(screenMySize.size.width, 0) animated:YES];
        }else{
            [self aTCQ];
        }
        return;
    }
}

-(void)setHeader
{
//    pageForNumber = 1;
//    fListArray = [[NSMutableArray alloc] init];
//    numHightArray = [[NSMutableArray alloc] init];
//    [mTableView reloadData];
    if ([self.title isEqualToString:@"4+X"] && selectYCQFTop == 0) {
//        [self.otherNewsLeft upDateTableView];
        self.otherNewsLeft_4x.RowID = [wfSubCodeDic objectForKey:@"\"x\"机制"];
        [self.otherNewsLeft_4x ReloadThe];
    }else{
        [self.otherBodyScrollView setContentOffset:CGPointMake(screenMySize.size.width, 0) animated:NO];
        [mTableView.header beginRefreshing];
    }
}

-(void)addSend
{
    SendViewController *vc = [[SendViewController alloc] init];
    vc.title = self.title;
    if ([self.title isEqualToString:@"责任清单"])
    {
        vc.RowID = [wfSubCodeDic objectForKey:@"责任清单"];
    }else if ([self.title isEqualToString:@"4+X"]){
        if (selectYCQFTop == 0) {
            vc.RowID = [wfSubCodeDic objectForKey:@"\"x\"机制"];
            vc.title = @"\"x\"机制";
        }else{
            vc.RowID = RowID;
        }
    }
    //16-12-2修改
//    else if([self.title isEqualToString:@"领导活动"]||[self.title isEqualToString:@"镇级和部门领导"]){
//        if (selectYCQFTop == 0) {
//            vc.title = @"区级领导";
//        }else if (selectYCQFTop == 1){
//            vc.isLDHDOther = true;
//            vc.title = @"镇级和部门领导";
//        }
//        vc.RowID = RowID;
//    }
    else if ([self.title rangeOfString:@"领导活动"].location != NSNotFound)
    {
        if (selectYCQFTop == 0) {
            vc.LDHDString = @"day";
        }else if (selectYCQFTop == 1){
            vc.LDHDString = @"regular";
        }
        vc.RowID = RowID;
    }
    else if ([self.title rangeOfString:@"请假出差报告"].location != NSNotFound||[self.title rangeOfString:@"外出报告"].location != NSNotFound)
    {
        vc.LDHDString = @"leave";
        vc.RowID = RowID;
    }
    else if ([self.title isEqualToString:@"区委抄告单"]){
        if (selectYCQFTop == 0) {
            vc.tabClass = @"notice";
        }else{
            vc.tabClass = @"instructions";
        }
        vc.showTitle = selectYCQFTop == 0?@"抄告单下达":@"抄告单反馈";
        vc.RowID = RowID;
    }
    else if ([self.title isEqualToString:@"流域治理"]){
        if (selectYCQFTop == 0) {
            vc.RowID = RowID;
        }else{
            vc.RowID = [wfSubCodeDic objectForKey:@"治理督导"];
        }
        vc.showTitle = selectYCQFTop == 0?@"流域治理":@"治理督导";
    }
    else
    {
        vc.RowID = RowID;
    }
    
    vc.isChild = isChild;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 请求代理
- (void)isDeleteOrReplyComment:(BOOL)isDelete
                 isSelfArticle:(BOOL)isSelf
                     withRowID:(long)rowID
                    withSender:(SingleReplyButton *)sender
{
    if (isDelete)
    {
        needDeleteRowID = rowID;
        [_DeleteRowIDArr addObject:[NSString stringWithFormat:@"%ld",rowID]];
        NSLog(@"_DeleteRowIDArr:%@",_DeleteRowIDArr);
        NSDictionary *postDic = @{@"rowID":[NSNumber numberWithLong:rowID]};
        [serive PostFromURL:ADeleteCommentByRowID params:postDic mHttp:httpUrl isLoading:NO];
    }
    else
    {
        if (isSelf)
            [self replyClick:sender];
    }
}

-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName
{

    if ([urlName isEqualToString:ADeleteCommentByRowID])//删除回调
    {
        
//        NSLog(@"删除回调 %@",dic);
        
        if (dic != nil)
        {
            if ([[dic objectForKey:@"error"] intValue] == 0)
            {
//                kAlertShow(@"删除成功");
                [mTableView reloadData];
            }
            else if ([[dic objectForKey:@"error"] intValue ]==2)
            {
                NSString *showMessge = [dic objectForKey:@"message"];
                kAlertShow(showMessge);
            }
            
        }
    }else if ([urlName isEqualToString:AChangeConfState]){
        NSLog(@"设置已读%@",dic);
        if ([dic[@"message"] isEqualToString:@"success"]) {
            if (menuInt == 1) {
                FullCutModel *model = self.showDataList[tagRow-1];
                model.UDefine1 = @"True";
                
                [self.showDataList replaceObjectAtIndex:tagRow-1 withObject:model];
                [mTableView reloadData];
            }else{
                FullCutModel *model = self.showDataList[touchRow];
                model.UDefine1 = @"True";
                
                [self.showDataList replaceObjectAtIndex:touchRow withObject:model];
                [mTableView reloadData];
            }
//            [self loadNewData];
//            [self upDateTableView];
            
        }
    }
    
    
    if ([urlName isEqualToString:AUploadCommentData])//评价回调
    {
        if (dic != nil) {
            NSLog(@"评价回调 %@",dic);
            
            if ([[dic objectForKey:@"error"] intValue] == 0)
            {
                NSString *oldCommentStr = [fListArray[goalIndexPathRow] objectForKey:@"Comment"];
                NSArray *oldSubArr = [oldCommentStr componentsSeparatedByString:@"],\"TotalCount"];
                
                NSString *headStr = oldSubArr[0];
                NSString *newComment;
                
                if (headStr.length == 20 /* 字符的前半部分为空,则说明没有评论 追加字符 "," 不需要加  符号 */)
                {
                    newComment = [NSString stringWithFormat:@"%@%@],\"TotalCount%@",[oldSubArr objectAtIndex:0],[dic objectForKey:@"message"],[oldSubArr objectAtIndex:1]];
                }
                else
                {
                    newComment = [NSString stringWithFormat:@"%@,%@],\"TotalCount%@",[oldSubArr objectAtIndex:0],[dic objectForKey:@"message"],[oldSubArr objectAtIndex:1]];
                }
                
                //如果新增的评论row 包含在之前删除的rowID上 则移除该rowid
                for (int i = 0; i < _DeleteRowIDArr.count; i++)
                {
                    NSNumber *rowIDNum  = _DeleteRowIDArr[i];
                    //rowID关键字
                    NSString * rowIDNumKey = [NSString stringWithFormat:@"%d",[rowIDNum intValue]];
                    //NSString stringWithFormat:@"\\\"RowID\\\":%d"]如果包含关键字
                    NSLog(@"_deleteArr %@",_DeleteRowIDArr);
                    if ([[dic objectForKey:@"message"] rangeOfString:rowIDNumKey].location != NSNotFound)
                    {
                        [_DeleteRowIDArr removeObjectAtIndex:i];
                    }
                }
                
                //                NSLog(@"fListArrayfListArray%@",[fListArray objectAtIndex:goalIndexPathRow]);
                
                NSMutableDictionary *tmpCommentDic = [NSMutableDictionary dictionaryWithDictionary:[fListArray objectAtIndex:goalIndexPathRow]];
                [tmpCommentDic setObject:newComment forKey:@"Comment"];
                
                [fListArray replaceObjectAtIndex:goalIndexPathRow withObject:tmpCommentDic];
                
                NSLog(@"替换过的字典 %@",fListArray[goalIndexPathRow]);
                
                [mTableView reloadData];
                
                
            }
            else if ([[dic objectForKey:@"error"] intValue ]==2)
            {
                NSString *showMessge = [dic objectForKey:@"message"];
                kAlertShow(showMessge);
            }
        }
    }
    
    if ([urlName isEqualToString:AGetZengCaiList]||[urlName isEqualToString:AGetDepartmentClassList])//获取项目
    {
        NSLog(@"征集%@",dic);
        if (dic != nil) {
            if (is4XLeftTouch) {
                NSLog(@"aaa");
                arr4xZR = [[NSMutableArray alloc]init];
                for (NSDictionary *a in dic) {
                    [arr4xZR addObject:a];
                }
                is4XLeftTouch = NO;
                [self arr4xflATCQ:arr4xZR];
            }else if (is4XRightTouch) {
                NSLog(@"bbb");
                arr4xJZ = [[NSMutableArray alloc]init];
                for (NSDictionary *a in dic) {
                    [arr4xJZ addObject:a];
                }
                is4XRightTouch = NO;
                [self arr4xflATCQ:arr4xJZ];
            }else if (noAll) {
                secondDepatment = [[NSMutableArray alloc]init];
                for (NSDictionary *a in dic) {
                    [secondDepatment addObject:a];
                }
//                if ([RowID intValue]==171) {
//                    secondDepatment171 = [[NSMutableArray alloc]init];
//                    for (NSDictionary *a in dic) {
//                        [secondDepatment171 addObject:a];
//                    }
//                }else
//                {
//                    secondDepatment151 = [[NSMutableArray alloc]init];
//                    for (NSDictionary *a in dic) {
//                        [secondDepatment151 addObject:a];
//                    }
//                }
                noAll = NO;
                [self sencondATCQ];
            }else if(isLoadOtherMenu){
                if (OtherMenuArray == nil) {
                    OtherMenuArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *a in dic) {
                        [OtherMenuArray addObject:a];
                    }
                    [self showOtherMenuAction:OtherMenuArray];
                }else{
                    OtherMenuSecondArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *a in dic) {
                        [OtherMenuSecondArray addObject:a];
                    }
                    [self showOtherMenuAction:OtherMenuSecondArray];
                }
                isLoadOtherMenu = false;
            }else{
                if (isShowSecond) {//显示第二级
                    ldMneuArraySeconed = [[NSMutableArray alloc] init];
                    for (NSDictionary *a in dic) {
                        [ldMneuArraySeconed addObject:a];
                    }
                    NSLog(@"aaa");
                    [self aTCQ2];
                }else if (isShowThird){
                    ldMneuArrayThird = [[NSMutableArray alloc] init];
                    for (NSDictionary *a in dic) {
                        [ldMneuArrayThird addObject:a];
                    }
                    [self aTCQ3];
                }else if (ldMneuArrayOther!=nil && menuInt == 7){
                    if ([RowID isEqualToString:@"824"]) {
                        for (NSDictionary *a in dic) {
                            [ldMneuArrayOther addObject:a];
                        }
                        RowID = @"262";
                    }else{
                        for (NSDictionary *a in dic) {
                            [ldMneuArray addObject:a];
                        }
                        [self setZengCaiList];
                    }
                }else{
                    for (NSDictionary *a in dic) {
                        [ldMneuArray addObject:a];
                    }
                    [self setZengCaiList];
                }
                
            }
        }
    }
    if ([urlName isEqualToString:AOAGetDept])// 获取部门
    {
        if (dic != nil) {
            dicLDStr = nil;
            
            dicLDStr = dic[@"NewDataSet"][@"Table"][@"msg"][@"text"];
            
            if ([self.title isEqualToString:@"请假出差报告"]) {
                [self aTLD];
            }else{
                [self setZengCaiList];
            }
            
            
        }
    }
    if ([urlName isEqualToString:AOAGetLeader])// 获取领导
    {
        if (dic != nil)
        {
            if ([[dic[@"NewDataSet"] allKeys] containsObject:@"Table"]) {
                
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
                for (NSDictionary *DIC in dic[@"NewDataSet"][@"Table"])
                {
                    [actionSheet addButtonWithTitle:DIC[@"userName"][@"text"]];
                }
                actionSheet.tag = 101;
//                actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [actionSheet showInView:self.view];
            }
            else
            {
//                NSLog(@"NewDataSet===%@",dic);
//                [inButton setTitle:[menuLDArray objectAtIndex:0] forState:UIControlStateNormal];
//                if ([self.title isEqualToString:@"领导活动"]) {
//                    [self setInButtonSize];//重新设置长度
//                }
                [self setButtonTitle];
                [self ReloadThe];
            }
            
        }
    }
    if (   [urlName isEqualToString:AGetPerPhotoList_All]
        || [urlName isEqualToString:AGetPerPhotoList]
        || [urlName isEqualToString:AGetPerPhotoList_LD]
        || [urlName isEqualToString:AGetConfList]
        || [urlName isEqualToString:APullPerPhotoListByClassID]
        || [urlName isEqualToString:AGetleaveList]
        || [urlName isEqualToString:AGetPerPhotoList_CGD])
    {
        
        NSLog(@"列表:%@",dic);
        
        if (dic != nil) {
            //清除列表
            if (pageForNumber == 1) {
                self.showDataList = [[NSMutableArray alloc]init];
                fListArray = [[NSMutableArray alloc] init];
                numHightArray = [[NSMutableArray alloc] init];
                titleHArray = [[NSMutableArray alloc] init];
                timeNowArray = [[NSMutableArray alloc] init];
                aImageViewArray = [[NSMutableDictionary alloc] init];
                [_DeleteRowIDArr removeAllObjects];
            }
            FullCutModel *entity;
            NSArray *arr = dic[@"DataList"];
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
            for (NSDictionary *dic in arr) {
                entity = [[FullCutModel alloc] initWithDictionary:dic];
                [self.showDataList addObject:entity];
            }
//            NSLog(@"fListArray::%ld",fListArray.count);
            [fListArray addObjectsFromArray:dic[@"DataList"]];
        }
        
        [mTableView reloadData];
        [mTableView.header endRefreshing];
        [mTableView.footer endRefreshing];
    }
}


-(void)aTLD
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    NSArray *controls = [dicLDStr componentsSeparatedByString:@","];
    [actionSheet addButtonWithTitle:@"全部"];
    for (int i = 0; i < controls.count; i ++)
    {
        [actionSheet addButtonWithTitle:[controls objectAtIndex:i]];
    }
    actionSheet.tag = 100;
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)aTCQ
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
//    if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ) {
//        for (NSString *str in bumenMenuArr) {
//            [actionSheet addButtonWithTitle:str];
//        }
//    }else{
        [actionSheet addButtonWithTitle:@"全部"];
        for (NSDictionary *dic in ldMneuArray)
        {
            [actionSheet addButtonWithTitle:dic[@"ClassName"]];
        }
//    }
    actionSheet.tag = 102;
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
-(void)aTCQ2
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (secondAllText == nil) {
        secondAllText = @"全部";
    }
    [actionSheet addButtonWithTitle:secondAllText];
    for (NSDictionary *dic in ldMneuArraySeconed)
    {
        [actionSheet addButtonWithTitle:dic[@"ClassName"]];
    }
    //    }
    actionSheet.tag = 202;
    [actionSheet showInView:self.view];
}
-(void)aTCQ3
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (thirdAllText == nil) {
        thirdAllText = @"全部";
    }
    [actionSheet addButtonWithTitle:thirdAllText];
    for (NSDictionary *dic in ldMneuArrayThird)
    {
        [actionSheet addButtonWithTitle:dic[@"ClassName"]];
    }
    //    }
    actionSheet.tag = 203;
    [actionSheet showInView:self.view];
}
#pragma mark - 显示顶部菜单actionSheet。
-(void)showOtherMenuAction:(NSArray *)MenuArray{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    if (secondAllText == nil) {
        secondAllText = @"全部";
    }
    [actionSheet addButtonWithTitle:secondAllText];
    for (NSDictionary *dic in MenuArray)
    {
        [actionSheet addButtonWithTitle:dic[@"ClassName"]];
    }
    actionSheet.tag = 302;
    [actionSheet showInView:self.view];
    
    secondAllText = nil;
}
-(void)arr4xflATCQ:(NSArray *)arr{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"全部"];
    for (NSDictionary *dic in arr)
    {
        [actionSheet addButtonWithTitle:dic[@"ClassName"]];
    }
    if (arr == arr4xZR) {
        actionSheet.tag = 204;
    }else{
        actionSheet.tag = 205;
    }
    
    //    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
//预留部门第二级
-(void)sencondATCQ{
//    NSArray *arr = nil;
//    if ([RowID intValue]==171) {
//        if (secondDepatment171!=nil) {
//            arr = secondDepatment171;
//            noAll = NO;
//        }else{
//            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//            [postDicc setObject:RowID  forKey:@"ParentID"];
//            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
//            noAll = YES;
//            return;
//        }
//    }else{
//        if (secondDepatment151!=nil) {
//            arr = secondDepatment151;
//            noAll = NO;
//        }else{
//            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//            [postDicc setObject:RowID  forKey:@"ParentID"];
//            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
//            noAll = YES;
//            return;
//        }
//    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
//    [actionSheet addButtonWithTitle:@"全部"];
    for (NSDictionary *dic in secondDepatment)
    {
        [actionSheet addButtonWithTitle:dic[@"ClassName"]];
    }
    actionSheet.tag = 105;
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}
-(void)gotoLDTwo:(NSString*)aLDStr
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:aLDStr forKey:@"dept"];
    [serive PostFromURL:AOAGetLeader params:dic mHttp:httpUrl isLoading:NO];
    
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"aaaaa===%zd",actionSheet.tag);
    if (buttonIndex==0&&actionSheet.tag != 302) {
//        if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30||menuInt == 21) {
//            [inButton setTitle:self.title forState:0];
//        }
        return;
    }
    LDStr = @"";
    if (actionSheet.tag == 100)//部门选择
    {
        if (buttonIndex == 1) {
            [self ReloadThe];
        }
        else
        {
            [self gotoLDTwo:[actionSheet buttonTitleAtIndex:buttonIndex]];
        }
    }
    if (actionSheet.tag == 101)//领导选择
    {
        
        LDStr = [actionSheet buttonTitleAtIndex:buttonIndex];
//        [inButton setTitle:LDStr forState:UIControlStateNormal];
//        if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
//            [self setInButtonSize];//重新设置长度
//        }
        [self ReloadThe];
    }
    else if (actionSheet.tag == 102)
    {
#warning 部门选项
        if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ||menuInt == 21) {
            if (buttonIndex == 1) {
                [inButton setTitle:[menuLDArray objectAtIndex:menuInt] forState:UIControlStateNormal];
                RowID =  [wfSubCodeLDArray objectAtIndex:menuInt];
                if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
                    [self setInButtonSize];//重新设置长度
                }
                [self ReloadThe];
            }
            else
            {
                if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
                    [self setInButtonSize];//重新设置长度
                }
                RowID =  ldMneuArray[buttonIndex-2][@"RowID"];
                
                NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                [postDicc setObject:RowID  forKey:@"ParentID"];
                [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                noAll = YES;
//                [self sencondATCQ];
            }
//            if (buttonIndex ==1){
//                [inButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
//                RowID =  @"171";
//                
//                [self sencondATCQ];
//            }else if (buttonIndex == 2){
//                [inButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
//                RowID =  @"151";
//                
//                [self sencondATCQ];
//            }
        }else{
            if (buttonIndex == 1) {//全部
                if ([self.title rangeOfString:@"领导活动"].location == NSNotFound) {
                    [inButton setTitle:[menuLDArray objectAtIndex:menuInt] forState:UIControlStateNormal];
                    [self setInButtonSize];//重新设置长度
                }
                if (menuInt == 7 &&selectYCQFTop == 1) {
                    RowID =  @"824";
                }else{
                RowID =  [wfSubCodeLDArray objectAtIndex:menuInt];
                }
            }
            else
            {
                if (menuInt == 7 &&selectYCQFTop == 1) {
                    RowID =  ldMneuArrayOther[buttonIndex-2][@"RowID"];
                }else{
                RowID =  ldMneuArray[buttonIndex-2][@"RowID"];
                }
                if ([self.title isEqualToString:@"责任落实"] ||[self.title isEqualToString:@"4+X"]) {
                    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"全部"]) {
                        SecondRowID = ldMneuArray[buttonIndex-2][@"RowID"];
                        secondAllText = ldMneuArray[buttonIndex-2][@"ClassName"];
                        isShowSecond = YES;
                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                        [postDicc setObject:RowID  forKey:@"ParentID"];
                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                        return;
                    }
                }else if ([self.title isEqualToString:@"区级领导活动"]||[self.title isEqualToString:@"镇街领导活动"]) {
                    if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"全部"]) {
                        SecondRowID = ldMneuArray[buttonIndex-2][@"RowID"];
                        secondAllText = ldMneuArray[buttonIndex-2][@"ClassName"];
                        isShowSecond = YES;
                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                        [postDicc setObject:RowID  forKey:@"ParentID"];
                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
                        return;
                    }
                }else{
                    if ([self.title rangeOfString:@"流域治理"].location == NSNotFound) {
                        [inButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
                    }
                    if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
                        [self setInButtonSize];//重新设置长度
                    }
                }
            }
            [self ReloadThe];
        }
    }else if(actionSheet.tag == 202){
        if ([self.title isEqualToString:@"4+X"] && selectYCQFTop == 0) {
            if (buttonIndex == 1) {//全部
                leftRowID =  SecondRowID;
            }else{
                leftRowID =  ldMneuArraySeconed[buttonIndex-2][@"RowID"];
            }
            
            self.otherNewsLeft_4x.RowID = leftRowID;
            [self.otherNewsLeft_4x ReloadThe];
            
            is4XLeftTouch = false;
        }else{
            if (buttonIndex == 1) {//全部
                RowID =  SecondRowID;
            }else{
                RowID =  ldMneuArraySeconed[buttonIndex-2][@"RowID"];
            }
            if (0&&[self.title isEqualToString:@"4+X"]) {//4+x原本存在第三级选择
                ThirdRowID = ldMneuArray[buttonIndex-2][@"RowID"];
                thirdAllText = ldMneuArray[buttonIndex-2][@"ClassName"];
                isShowSecond = NO;
                isShowThird = NO;//这里设置yes显示第三集选择
                NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                [postDicc setObject:RowID  forKey:@"ParentID"];
                [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
            }else{
                [self ReloadThe];
            }
        }
    }else if(actionSheet.tag == 203){//4+x存在第三集选择
        if (buttonIndex == 1) {//全部
            RowID =  ThirdRowID;
        }else{
            RowID =  ldMneuArrayThird[buttonIndex-2][@"RowID"];
        }
        isShowThird = NO;
        [self ReloadThe];
    }else if(actionSheet.tag == 204){//4+x存在责任清单选择
        if (buttonIndex == 1) {//全部
            leftRowID = [wfSubCodeDic objectForKey:@"\"x\"机制"];
            self.otherNewsLeft_4x.RowID = leftRowID;
            [self.otherNewsLeft_4x ReloadThe];
            return;
        }else{
            leftRowID =  arr4xZR[buttonIndex-2][@"RowID"];
        }
//        isShowThird = NO;
//        [self ReloadThe];
        SecondRowID = leftRowID;
        secondAllText = arr4xZR[buttonIndex-2][@"ClassName"];
        isShowSecond = YES;
        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
        [postDicc setObject:leftRowID  forKey:@"ParentID"];
        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
        
//        self.otherNewsLeft.RowID = RowID;
//        [self.otherNewsLeft upDateTableView];
    }else if(actionSheet.tag == 2041){//4+x责任清单第二级
        if (buttonIndex == 1) {//全部
            leftRowID =  [wfSubCodeDic objectForKey:@"\"x\"机制"];
        }else{
            leftRowID =  arr4xZR[buttonIndex-2][@"RowID"];
        }
        self.otherNewsLeft.RowID = RowID;
    }else if(actionSheet.tag == 205){//4+x体制机制
        NSString *rightRowid;
        if (buttonIndex == 1) {//全部
            rightRowid =  [wfSubCodeDic objectForKey:@"机制体制"];
        }else{
            rightRowid =  arr4xJZ[buttonIndex-2][@"RowID"];
        }
        self.otherNewsRight.RowID = rightRowid;
        [self.otherNewsRight upDateTableView];
    }else if (actionSheet.tag == 105){
        [inButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
        if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
            [self setInButtonSize];//重新设置长度
        }
        RowID = secondDepatment[buttonIndex-1][@"RowID"];
//            if ([RowID intValue]==171) {
//                RowID =  secondDepatment171[buttonIndex-1][@"RowID"];
//            }else{
//                RowID =  secondDepatment151[buttonIndex-1][@"RowID"];
//            }
        [self ReloadThe];
    }else if (actionSheet.tag == 200){//会议顶部点击
        if (buttonIndex == 1) {//全部
            meetting_jinshen = NO;
            
            [inButton setTitle:[menuLDArray objectAtIndex:menuInt] forState:UIControlStateNormal];
            if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
                [self setInButtonSize];//重新设置长度
            }
            RowID =  [wfSubCodeLDArray objectAtIndex:menuInt];
            self.title = [menuLDArray objectAtIndex:menuInt];
        }
        else
        {
            meetting_jinshen = YES;
            [inButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
            if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
                [self setInButtonSize];//重新设置长度
            }
            RowID = @"319";
            self.title = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
        [self ReloadThe];
    }else if (actionSheet.tag == 302){//镇级和部门领导选择
        if (OtherMenuSecondArray == nil&&![self.title isEqualToString:@"请假出差报告"]) {//点第一级时
//            secondAllText = nil;
            RowID = wfSubCodeDic[@"镇级和部门领导"];
        }
        if (buttonIndex == 0) {//取消
//            secondAllText = nil;
            OtherMenuSecondArray = nil;
            return;
        }else if (buttonIndex == 1) {//全部
            if (![[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"全部"]) {
                [otherRightTextButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:0];
                [self setButtonTitleWithOther];
            }
            [self ReloadThe];
        }
        else
        {
            if (OtherMenuSecondArray == nil) {//点第一级时
                RowID = OtherMenuArray[buttonIndex-2][@"RowID"];//第二级时用
                secondAllText = [[OtherMenuArray objectAtIndex:buttonIndex-2] objectForKey:@"ClassName"];
                isLoadOtherMenu = true;
                NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
                [postDicc setObject:RowID  forKey:@"ParentID"];
                [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
            }else{//点第二级时
                if (![self.title isEqualToString:@"请假出差报告"]) {
                    [otherRightTextButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:0];
                    [self setButtonTitleWithOther];
                }
                RowID = OtherMenuSecondArray[buttonIndex-2][@"RowID"];//第二级时用
                [self ReloadThe];
                OtherMenuSecondArray = nil;
            }
            
//            [otherRightTextButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:0];
//            self.title = [actionSheet buttonTitleAtIndex:buttonIndex];
        }
    }else if (actionSheet.tag == 300){
        if (buttonIndex == 2) {
            orderByString = @"Reply";
        }else{
            orderByString = @"";
        }
        [self ReloadThe];
    }
    if (![self.title isEqualToString:@"责任落实"] ||[self.title isEqualToString:@"4+X"]) {
        [self setButtonTitle];
    }
}
#pragma mark - 设置选择按钮的标题
-(void)setButtonTitle
{
//    NSLog(@"===----%@,%d",self.title,isGoingLeft);
    if (!isGoingLeft&&([self.title isEqualToString:@"领导活动"]||[self.title isEqualToString:@"镇级和部门领导"])) {//领导活动没有左边区级领导权限时
        return;
    }
    NSString *atextStr =  inButton.titleLabel.text;
    UIImage *imageD = [UIImage imageNamed:@"bottom_arrow"];
    UIImage *imageD_press = [UIImage imageNamed:@"bottom_arrow_press"];
    //16-12-2修改
//    if ([self.title rangeOfString:@"领导活动"].location != NSNotFound&&isGoingLeft&&!isGoingRight) {
//        imageD_press = [UIImage imageNamed:@"bottom_arrow"];
//    }
    CGSize titleSize = [atextStr sizeWithAttributes:@{NSFontAttributeName: inButton.titleLabel.font}];
    if (titleSize.width > 200) {
        titleSize.width = 200;
    }
    [inButton setFrame:CGRectMake(inButton.frame.origin.x, inButton.frame.origin.y, titleSize.width+30, inButton.frame.size.height)];
    [inButton setImage:imageD forState:UIControlStateNormal];
    [inButton setImage:imageD_press forState:UIControlStateSelected];
    [inButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
    [inButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
}
#pragma mark - 设置其他选择按钮的标题，如领导活动右边的镇级领导
-(void)setButtonTitleWithOther
{
    NSString *atextStr =  otherRightTextButton.titleLabel.text;
    UIImage *imageD = [UIImage imageNamed:@"bottom_arrow"];
    UIImage *imageD_press = [UIImage imageNamed:@"bottom_arrow_press"];
    CGSize titleSize = [atextStr sizeWithAttributes:@{NSFontAttributeName: otherRightTextButton.titleLabel.font}];
    if (titleSize.width > 200) {
        titleSize.width = 200;
    }
    [otherRightTextButton setFrame:CGRectMake(otherRightTextButton.frame.origin.x, otherRightTextButton.frame.origin.y, titleSize.width+30, otherRightTextButton.frame.size.height)];
    [otherRightTextButton setImage:imageD forState:UIControlStateNormal];
    if (isGoingLeft) {
        [otherRightTextButton setImage:imageD_press forState:UIControlStateSelected];
    }
    [otherRightTextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
    [otherRightTextButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    
    if ([self.title isEqualToString:@"请假出差报告"]) {
        [otherLeftTextButton setFrame:CGRectMake(otherLeftTextButton.frame.origin.x, otherLeftTextButton.frame.origin.y, titleSize.width+30, otherLeftTextButton.frame.size.height)];
        [otherLeftTextButton setImage:imageD forState:UIControlStateNormal];
        [otherLeftTextButton setImage:imageD_press forState:UIControlStateSelected];
        [otherLeftTextButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageD.size.width, 0, imageD.size.width)];
        [otherLeftTextButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width)];
    }
}

#pragma mark - 刷新
-(void)ReloadThe
{
    [mTableView.header beginRefreshing];
}

- (void)loadNewData
{
    pageForNumber = 1;
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
        NSLog(@"qqq---%@,%@",self.title,RowID);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[ToolCache userKey:kDeviceToken] forKey:@"IMEINO"];
        [dic setValue:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
        [dic setValue:RowID forKey:@"classID"];
        [dic setValue:@"" forKey:@"lastTime"];
        [dic setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
        [dic setValue:[NSString stringWithFormat:@"%d",itemLabel] forKey:@"PageSize"];
        [dic setValue:@"" forKey:@"TabClass"];
        if ([self.title rangeOfString:@"领导活动"].location != NSNotFound) {
            if (selectYCQFTop == 0) {
                [dic setValue:@"day" forKey:@"TabClass"];
            }else if (selectYCQFTop == 1) {
                [dic setValue:@"regular" forKey:@"TabClass"];
            }
        }else if ([self.title rangeOfString:@"请假出差报告"].location != NSNotFound||[self.title rangeOfString:@"外出报告"].location != NSNotFound){
            [dic setValue:@"leave" forKey:@"TabClass"];
        }else if ([self.title isEqualToString:@"区委抄告单"]){
            [dic setValue:[wfSubCodeDic objectForKey:@"区委抄告单"] forKey:@"classID"];
            if (selectYCQFTop == 0) {
                [dic setValue:@"notice" forKey:@"TabClass"];
            }else if (selectYCQFTop == 1){
                [dic setValue:@"instructions" forKey:@"TabClass"];
            }
        }
        if (menuInt == 0)
        {
            [dic setValue:LDStr forKey:@"LeaderName"];//传领导名字
            [serive PostFromURL:AGetPerPhotoList_LD params:dic mHttp:httpUrl isLoading:NO];
        }else if (menuInt == 28){
            [dic setValue:orderByString forKey:@"OrderBy"];
            [serive PostFromURL:AGetPerPhotoList_CGD params:dic mHttp:httpUrl isLoading:NO];
        }
//        else if (menuInt == 7){
//            if (selectYCQFTop == 1) {
//                NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//                [postDicc setObject:RowID  forKey:@"ParentID"];
//                [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
//            }else{
//                [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
//            }
//        }
        else if (menuInt == 1)
        {
            if (timeString.length != 0) {
                [dic setValue:timeString forKey:@"confBeginDate"];//传开始日期
            }
            else
                [dic setValue:@"" forKey:@"confBeginDate"];
            if (timeEndString.length != 0) {
                [dic setValue:timeEndString forKey:@"confEndDate"];//传结束日期
            }
            else
                [dic setValue:@"" forKey:@"confEndDate"];
            
            if (meetting_jinshen) {
                [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
            }else{
                [serive PostFromURL:AGetConfList params:dic mHttp:httpUrl isLoading:NO];
            }
        }
        else if (menuInt == 2||menuInt == 8 || menuInt == 9)
        {
            if (RowID == [wfSubCodeLDArray objectAtIndex:menuInt])
            {
                [serive PostFromURL:AGetPerPhotoList_All params:dic mHttp:httpUrl isLoading:NO];
            }
            else
                [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
        }
        //@"领导活动", @"会议管理",@"征拆动态",@"部门动态",@"城管执法",@"工业社区",@"重点工程",@"流域治理"
        else if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ||menuInt == 4||menuInt == 5||menuInt == 6 || menuInt == 31 ||menuInt == 33 || menuInt == 34 || menuInt == 32 ||menuInt == 27 || menuInt == 22||menuInt == 23|| menuInt == 17||menuInt ==10|| menuInt == 11|| menuInt == 12|| menuInt == 13|| menuInt == 15|| menuInt == 16 || menuInt == 24||menuInt == 18||menuInt == 19||menuInt == 20 || [self.title isEqualToString:@"\"x\"机制"]||menuInt == 7)
        {
            if (menuInt == 26) {
                [dic setValue:@"aqsc" forKey:@"TabClass"];//安全生产在部门动态的基础上添加tabclass
            }else if (menuInt == 29){
                [dic setValue:@"xin" forKey:@"TabClass"];
            }else if (menuInt == 30){
                [dic setValue:@"msbd" forKey:@"TabClass"];
            }else if (menuInt == 31){
                [dic setValue:@"zhong" forKey:@"TabClass"];
            }else if (menuInt == 33){
                [dic setValue:@"stone" forKey:@"TabClass"];
            }else if (menuInt == 34){
                [dic setValue:@"briefing" forKey:@"TabClass"];
            }
//            if (RowID == [wfSubCodeLDArray objectAtIndex:menuInt])
            {
                [dic setValue:@"" forKey:@"TownName"];
                NSLog(@"qqq===%@",dic);
                if (menuInt == 20&&selectYCQFTop == 0) {//请假出差报告
                    [dic setValue:LDStr forKey:@"LeaderName"];//传领导名字
                    [serive PostFromURL:AGetPerPhotoList_LD params:dic mHttp:httpUrl isLoading:NO];
                }else{
//                    if (selectYCQFTop == 1 && menuInt == 7) {
//                                        NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
//                                        [postDicc setObject:RowID  forKey:@"ParentID"];
//                                        [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:NO];
//
//                    }
                    [serive PostFromURL:AGetPerPhotoList params:dic mHttp:httpUrl isLoading:NO];
                }
            }
//            else
//                [serive PostFromURL:APullPerPhotoListByClassID params:dic mHttp:httpUrl isLoading:NO];
        }
        else if (menuInt == 21)
        {//外出报告
            [serive PostFromURL:AGetleaveList params:dic mHttp:httpUrl isLoading:NO];
        }
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
    if (tableView == mTableView) {
        return self.showDataList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (numHightArray.count>indexPath.row)
//    {
//        return [[NSString stringWithFormat:@"%@",[numHightArray objectAtIndex:indexPath.row]] intValue];
//    }
//    else
    if (tableView == mTableView)
    {
        if (fListArray.count <= indexPath.row)
        {
            return 0;
        }
        FullCutModel *entity = [[FullCutModel alloc]initWithDictionary:fListArray[indexPath.row]];
        
        int detialInt  = 0;
        if ([self.title isEqualToString:[menuLDArray objectAtIndex:1]])//会议
        {
            detialInt = detialInt - timeHight;
            if ((int)indexPath.row == 0)
            {
                detialInt = detialInt + timeHight+aTimeHight;
                [timeNowArray addObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
            }
            else if (self.showDataList.count > (int)indexPath.row) {
                FullCutModel *entity1 = self.showDataList[indexPath.row-1];
                if (entity.AuthorCompany.length >= 10&&entity1.AuthorCompany.length>=10) {
                    NSString* start = [NSString stringWithFormat:@"%@", [entity.AuthorCompany substringToIndex:10]];
                    start = [start stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    NSString* end = [NSString stringWithFormat:@"%@", [entity1.AuthorCompany substringToIndex:10]];
                    end = [end stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    if (![start isEqualToString:end])
                    {
                        detialInt = detialInt + timeHight + aTimeHight;
                        [timeNowArray addObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
                    }
                    else
                        [timeNowArray addObject:@"-1"];
                }
            }
            //5,12添加，在会议管理滑道底部切换为新闻线索闪退
            [titleHArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        }
        else if (menuInt == 28){
            detialInt = [ToolCache setString:[NSString stringWithFormat:@"具体要求：%@",entity.SumnaryString] setSize:labelSize-2 setWight:screenMySize.size.width-txImageSize-agsize*2];
            if (detialInt > 60)//三行start
            {
                detialInt = 60;
            }//三行end
            
            if (entity.Location != nil && ![entity.Location isEqualToString:@""]) {
                //                str = [NSString stringWithFormat:@"%@\n%@",entity.Location,entity.SumnaryString];
                detialInt += [ToolCache setString:[NSString stringWithFormat:@"承接单位：%@",entity.Location] setSize:labelSize-2 setWight:screenMySize.size.width-txImageSize-agsize*2];
            }
            [titleHArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        }
        else
        {
            detialInt = [ToolCache setString:entity.SumnaryString setSize:labelSize-2 setWight:screenMySize.size.width-txImageSize-agsize*2];
            if (detialInt > 60)//三行start
            {
                detialInt = 60;
            }//三行end
            [titleHArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        }
        
        NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
        [aImageViewArray setValue:imageUrlArray forKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
        int contAr = (int)imageUrlArray.count;
        
        NSDictionary *commentDic = nil;
        BOOL isCreate = NO;//是否时发帖人
        if ([[NSString stringWithFormat:@"%@",entity.CreateID] isEqualToString:[ToolCache userKey:kAccount]]) {
            isCreate = YES;
        }
        if (isShowComment||isCreate) {
            //获取评论内容
            NSString *commentStr= [fListArray[indexPath.row] objectForKey:@"Comment"];
            //替换字符
            NSString *endString = [commentStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            NSData *dataOfComment = [endString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            commentDic = [NSJSONSerialization JSONObjectWithData:dataOfComment options:NSJSONReadingMutableContainers error:&error];
        }
        
        if (oneLine == 1)
        {
            //一行图片start
            if (contAr > 0) {
                detialInt = (imageSize+10) +detialInt+titleHight+timeHight+titleH+agsize*2;
            }//一行图片end
            else
                detialInt = detialInt+titleHight+timeHight+titleH+agsize*2;
            
            
            if (isShowComment||isCreate) {
                detialInt += [MessageReplyView getReplyViewHeightWith:commentDic withDeleteRowIDArr:_DeleteRowIDArr isShowCompany:isShowReplyCompany];
            }

        }
        else
        {
            if (contAr >= 9) {
                contAr = 9;
            }
            int hight = 0;
            for (int i = 0 ; i < contAr; i ++)
            {
                if ((float)contAr/3 <= i+1 && (float)contAr/3>i) {
                    hight = i+1;
                    break;
                }
            }
            detialInt = hight*(imageSize+10) +detialInt+titleHight+timeHight+titleH+agsize*2;
            
            if (isShowComment || isCreate) {
                detialInt += [MessageReplyView getReplyViewHeightWith:commentDic withDeleteRowIDArr:_DeleteRowIDArr isShowCompany:isShowReplyCompany];
            }
            
        }
        
        
        [numHightArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        return detialInt;
    }
    return sizeHight+10;;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (aTableView == mTableView) {
        static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
        
        UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:
                                 SimpleTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier: SimpleTableIdentifier];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            aTableView.showsVerticalScrollIndicator = NO;
        }
        
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = bgColor;
        int timeINT = 0;
        
        if ([self.title isEqualToString:[menuLDArray objectAtIndex:1]] && timeNowArray.count > (int)indexPath.row)
        {
            if ([[NSString stringWithFormat:@"%@",[timeNowArray objectAtIndex:indexPath.row]] intValue] == (int)indexPath.row)
            {
                UIImageView * _linImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
                [_linImageView setFrame:CGRectMake(agsize, (aTimeHight+timeHight)/2, screenMySize.size.width-2*agsize, 2)];
                [cell.contentView addSubview:_linImageView];
                
                timeINT = timeHight+aTimeHight;
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenMySize.size.width/3,agsize*2, screenMySize.size.width/3, timeHight)];
                _timeLabel.textAlignment = 1;
                _timeLabel.backgroundColor = bgColor;
                _timeLabel.font = [UIFont systemFontOfSize:labelSize-3];
                _timeLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:_timeLabel];
            }
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = [UIColor whiteColor];
            [bgView setFrame:CGRectMake(0, timeINT, screenMySize.size.width,[[NSString stringWithFormat:@"%@",[numHightArray objectAtIndex:indexPath.row]] intValue]-timeINT)];
            [cell.contentView addSubview:bgView];
        }
        //    if (_bgImageView == nil)
        {
            int detialInt = 0;
            _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(agsize,agsize+timeINT, txImageSize,txImageSize)];
            _bgImageView.image = [UIImage imageNamed:@"tx_nan"];
            _bgImageView.contentMode =  UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:_bgImageView];
            //左边名称
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+txImageSize+agsize, _bgImageView.frame.origin.y, (screenMySize.size.width - (_bgImageView.frame.origin.x+txImageSize+agsize))/2, titleHight)];
            _nameLabel.textAlignment = 0;
            [cell.contentView addSubview:_nameLabel];
            //右边名称
            _name1Label = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width, _nameLabel.frame.origin.y, screenMySize.size.width-(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+agsize), titleHight)];
            _name1Label.textAlignment = 2;
            _name1Label.font = [UIFont systemFontOfSize:labelSize-1];
            _name1Label.textColor = [UIColor blackColor];
            [cell.contentView addSubview:_name1Label];
            
            //        if (menuInt == 1) {
            //            _no_read_iview = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-16, CGRectGetMaxY(_name1Label.frame)+5, 10, 10)];
            //            [_no_read_iview setBackgroundColor:[UIColor redColor]];
            //            [_no_read_iview setClipsToBounds:YES];
            //            [_no_read_iview.layer setCornerRadius:5];
            //            [cell.contentView addSubview:_no_read_iview];
            //        }
            //
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+titleHight, screenMySize.size.width-_nameLabel.frame.origin.x, titleH)];
            _titleLabel.textAlignment = 0;
            _titleLabel.numberOfLines = 2;
            _titleLabel.font = [UIFont systemFontOfSize:labelSize];
            _titleLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            [cell.contentView addSubview:_titleLabel];
            //
            _name2Label = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x-agsize, detialInt)];
            _name2Label.textAlignment = 0;
            _name2Label.numberOfLines = 3;
            _name2Label.font = [UIFont systemFontOfSize:labelSize-2];
            _name2Label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
            [cell.contentView addSubview:_name2Label];
            
            if (![self.title isEqualToString:[menuLDArray objectAtIndex:1]])
            {
                _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH+detialInt, screenMySize.size.width-_titleLabel.frame.origin.x, timeHight)];
                _timeLabel.textAlignment = 0;
                _timeLabel.font = [UIFont systemFontOfSize:labelSize-3];
                _timeLabel.textColor = [UIColor grayColor];
                [cell.contentView addSubview:_timeLabel];
            }
            
            _line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
            [_line1ImageView setFrame:CGRectMake(agsize, _timeLabel.frame.origin.y+_timeLabel.frame.size.height, screenMySize.size.width-2*agsize, 2)];
            [cell.contentView addSubview:_line1ImageView];
        }
        
        if (self.showDataList.count != 0)
        {
            FullCutModel *entity = self.showDataList[indexPath.row];
            int detialInt = 0;
            
            if ([entity.title hash] && (id)entity.title != [NSNull null]){
#pragma 已阅未阅先隐藏，此处判断只有会议管理显示 '未阅'
                if ([self.title isEqualToString:[menuLDArray objectAtIndex:1]]&&[entity.UDefine1 hash] &&(id)entity.UDefine1 != [NSNull null]) {
                    if ([entity.UDefine1 isEqualToString:@"True"]) {
                        _titleLabel.text = entity.title;
                    }else{
                        //                    NSString *tit = [NSString stringWithFormat:@"%@",entity.title];
                        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"【未阅】%@",entity.title]];
                        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,4)];
                        [_titleLabel setAttributedText:str];
                    }
                }else{
                    _titleLabel.text = entity.title;
                }
            }
            if (![self.title isEqualToString:[menuLDArray objectAtIndex:1]])
            {
//                if (titleHArray == nil ||titleHArray.count == 0) {
//                    detialInt = 0;
//                    [titleHArray addObject:@"0"];
//                }else{
                    detialInt = [[NSString stringWithFormat:@"%@",[titleHArray objectAtIndex:indexPath.row]] intValue];
//                }
                
                if ([entity.CreateTime hash] && (id)entity.CreateTime != [NSNull null])
                    _timeLabel.text = [NSString stringWithFormat:@"%@",entity.CreateTime];
                
                if (menuInt == 28) {
                    if (entity.Location != nil && ![entity.Location isEqualToString:@""]) {
                        if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
                        {
                            _name2Label.text = [NSString stringWithFormat:@"承接单位：%@\n具体要求：%@",entity.Location,entity.SumnaryString];
                        }
                        else
                        {
                            _name2Label.text = [NSString stringWithFormat:@"承接单位：%@",entity.Location];
                        }
                    }else{
                        _name2Label.text = [NSString stringWithFormat:@"具体要求：%@",entity.SumnaryString];
                    }
                    
                }else{
                    if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
                    {
                        _name2Label.text = entity.SumnaryString;
                    }
                    else
                    {
                        _name2Label.text = @"";
                    }
                }
                
                _name2Label.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x, detialInt);
            }
            else
            {
                if ([entity.AuthorCompany hash] && (id)entity.AuthorCompany != [NSNull null])
                {
                    if (entity.AuthorCompany.length >= 10) {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
                        
                        NSDate *destDate= [dateFormatter dateFromString:[entity.AuthorCompany substringToIndex:10]];
                        NSString *mStr = [ToolCache weekdayStringFromDate:destDate];
                        _timeLabel.text = [NSString stringWithFormat:@"%@(%@)", [entity.AuthorCompany substringToIndex:10],mStr];
                        int timeWith = [ToolCache setString:_timeLabel.text setSize:labelSize setHight:timeHight];
                        
                        _timeLabel.frame = CGRectMake((screenMySize.size.width-timeWith)/2,agsize*2, timeWith, timeHight);
                    }
                }
            }
#warning 修改
            if (menuInt == 28) {
                _nameLabel.text = [NSString stringWithFormat:@"%@",entity.nameString];
                NSString *authorcompany = [NSString stringWithFormat:@"%@",entity.AuthorCompany];
                if ([authorcompany isEqualToString:@"<null>"]) {
                    authorcompany = @"";
                }
                _name1Label.text = authorcompany;
            }else{
                if ([entity.nameString hash] && (id)entity.nameString != [NSNull null])
                {
//                    if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ||menuInt==4) {
//                        _name1Label.text = [NSString stringWithFormat:@"%@",entity.nameString];
//                    }else{
//                        _name1Label.text = [NSString stringWithFormat:@"%@",entity.Rank];
//                    }
                    _name1Label.text = [NSString stringWithFormat:@"%@",entity.nameString];
                }
#if 0
                if ([entity.Rank hash] && (id)entity.Rank != [NSNull null])
                {
                    if (menuInt == 3 || menuInt == 26 || menuInt == 29||menuInt == 30 ||menuInt==4) {
                        _nameLabel.text = [NSString stringWithFormat:@"%@",entity.Rank];
                    }else{
                        //                NSLog(@"=====%@",entity.nameString);
                        _nameLabel.text = [NSString stringWithFormat:@"%@",entity.nameString];
                    }
                }
#endif
                if ([entity.AuthorCompany hash] && (id)entity.AuthorCompany != [NSNull null])
                {
                    _nameLabel.text = [NSString stringWithFormat:@"%@",entity.AuthorCompany];
                }
                
            }
            _nameLabel.text = [NSString stringWithFormat:@"%@",entity.Rank];
            
#warning 修改end
            //设置颜色
            if (![_nameLabel.text isEqualToString:@"政府值班室"]) {
                [_nameLabel setFont:[UIFont boldSystemFontOfSize:labelSize]];
                _nameLabel.textColor = [ToolCache stringTOColor:@"#004ed0"];
            }else{
                _nameLabel.font = [UIFont systemFontOfSize:labelSize];
                _nameLabel.textColor = [ToolCache stringTOColor:@"#0090ff"];
            }
            if ([entity.Pictureurl hash] && (id)entity.Pictureurl != [NSNull null])
                [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.Pictureurl]] placeholderImage:[UIImage imageNamed:@"tx_nan"]];
            //        NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
            //        NSLog(@"aaa");
            NSMutableArray *imageUrlArray = [aImageViewArray objectForKey:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
            //        NSLog(@"bbb");
            NSLog(@"imageUrlArrayimageUrlArray::%@",imageUrlArray);
#if 0
            BOOL isXK = false;
            if (![entity.AuthorCompany isKindOfClass:[NSNull class]]) {
                isXK = [entity.AuthorCompany isEqualToString:@"西柯镇"];
            }
            if (isXK) {
                NSMutableArray *newImgArray = [NSMutableArray arrayWithCapacity:imageUrlArray.count];
                NSString *str;
                for (NSString *iUrl in imageUrlArray) {
                    str = [iUrl stringByReplacingOccurrencesOfString:imageUrl withString:XKimageUrl];
                    [newImgArray addObject:str];
                }
                imageUrlArray = [newImgArray copy];
            }
#endif
            int contAr = (int)imageUrlArray.count;
            
            //一行图片start
            if (oneLine == 1)
            {
                if (contAr >= 3) {
                    contAr = 3;
                }
                //一行图片end
            }
            else
            {
                if (contAr >= 9) {
                    contAr = 9;
                }
                
            }
            
            int hight = 0;
            for (int i = 0 ; i < contAr; i ++)
            {
                CGRect frame = CGRectMake(10+txImageSize+(imageSize+10)*(i%3), _name2Label.frame.size.height+_name2Label.frame.origin.y+i/3*(imageSize+10), imageSize, imageSize);
                
                TapImageView *tmpView = [[TapImageView alloc] initWithFrame:frame];
                tmpView.t_delegate = self;
                tmpView.tag = 10000*(indexPath.row+1) + i;
                //长按手势
                UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
                longPressGr.minimumPressDuration = 0.8;
                [tmpView addGestureRecognizer:longPressGr];
                [cell.contentView addSubview:tmpView];
                
                
                [tmpView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
                
                
                if ((float)contAr/3 <= i+1 && (float)contAr/3>i) {
                    hight = i+1;
                }
                
            }
            if (![self.title isEqualToString:[menuLDArray objectAtIndex:1]])
                _timeLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10), screenMySize.size.width-_titleLabel.frame.origin.x, timeHight);
            
            //判断是否是会议类型,如果不是 添加评论功能
            //        NSLog(@"menuArr %@",menuArray[1]);
            if (![self.title isEqualToString:[menuLDArray objectAtIndex:1]])
            {
                //评论按钮  (加大点击范围),CreateID = ldm;
                //            NSLog(@"%@,%@",[NSString stringWithFormat:@"%@",entity.CreateID],[ToolCache userKey:kAccount]);
                if (isCanComment || [[NSString stringWithFormat:@"%@",entity.CreateID] isEqualToString:[ToolCache userKey:kAccount]]) {
                    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                    commentBtn.frame = CGRectMake(screenMySize.size.width-40, _timeLabel.frame.origin.y-20, 40,40);
                    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    //    [commentBtn setBackgroundImage:[UIImage imageNamed:@"commentClickBg"] forState:UIControlStateNormal];
                    [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:commentBtn];
                    
                    UIImageView *commentImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 20, 20)];
                    commentImgView.image = [UIImage imageNamed:@"commentClickBg"];
                    commentImgView.userInteractionEnabled = NO;
                    [commentBtn addSubview:commentImgView];
                }
                
                //评论内容获取
                NSDictionary *commentDic = nil;
                if (isShowComment||[[NSString stringWithFormat:@"%@",entity.CreateID] isEqualToString:[ToolCache userKey:kAccount]]) {
                    NSString *commentStr= [fListArray[indexPath.row] objectForKey:@"Comment"];
                    
                    //    NSLog(@"aaaa");
                    //替换字符
                    NSString *endString = [commentStr stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
                    NSData *dataOfComment = [endString dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error;
                    
                    commentDic = [NSJSONSerialization JSONObjectWithData:dataOfComment options:NSJSONReadingMutableContainers error:&error];
                }
                MessageReplyView *replyView = [[MessageReplyView alloc] init];
                [replyView setWithDictionary:commentDic withDeleteRowIDArr:_DeleteRowIDArr isShowCompany:isShowReplyCompany];
                replyView.delegate = self;
                replyView.articleID = entity.CreateID;
                if ([[NSString stringWithFormat:@"%@",entity.CreateID] isEqualToString:[ToolCache userKey:kAccount]])
                {
                    replyView.isSelfArticle = YES;
                }
                
                float replyHeight = [MessageReplyView getReplyViewHeightWith:commentDic withDeleteRowIDArr:_DeleteRowIDArr isShowCompany:isShowReplyCompany];
                replyView.frame = CGRectMake(0, _timeLabel.frame.origin.y+_timeLabel.frame.size.height, self.view.frame.size.width, replyHeight);
                [cell.contentView addSubview:replyView];
                
                _line1ImageView.frame = CGRectMake(agsize, replyView.frame.origin.y+replyView.frame.size.height, screenMySize.size.width-2*agsize, 2);
            }
            else
                _line1ImageView.frame = CGRectMake(agsize, _titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10), screenMySize.size.width-2*agsize, 2);
            
        }
        
        return cell;
    }else{
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
#pragma mark - 长按事件
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        TapImageView *tmpView=(TapImageView *)[gesture view];
        LongImg = tmpView.image;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定保存该图片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (buttonIndex == 1)
    {
        UIImageWriteToSavedPhotosAlbum(LongImg, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [RequestSerive alerViewMessage:msg];
}
#pragma mark -
#pragma mark - 图片点击 delegate
- (void) tappedWithObject:(id)sender
{
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    currentIndex = tmpView.tag%10000;
    tagRow = (int)tmpView.tag/10000;
    
    //设置已读
    if (tagRow > 0&&menuInt == 1) {
        FullCutModel *entity = self.showDataList[tagRow-1];
//        NSLog(@"%d,%@",tagRow,entity.UDefine1);
        if ([entity.UDefine1 isEqualToString:@"False"]) {
            NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
            [postDic setValue:entity.RowID forKey:@"RowID"];
            [postDic setValue:entity.ClassId forKey:@"ClassId"];
            [postDic setValue:[ToolCache userKey:kAccount] forKey:@"UserID"];
            [serive PostFromURL:AChangeConfState params:postDic mHttp:httpUrl isLoading:NO];
        }
    }
    
    //其他操作
    
//    NSLog(@"currentIndex::%ld",currentIndex);
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    convertRect.origin.y =  convertRect.origin.y +64;
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*screenMySize.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image setUrl:nil];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
//    [downBtn setHidden:NO];
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 30; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self.view viewWithTag:10000*tagRow + i];
        NSString *urlStr = nil;
        if (oneLine == 1 && tmpView == nil)
        {
            //            FullCutModel *entity = [[FullCutModel alloc] initWithDictionary:fListArray[tagRow-1]];
            //            NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
            NSMutableArray *imageUrlArray = [aImageViewArray objectForKey:[NSString stringWithFormat:@"%d",tagRow-1]];
            
            if (i >= (int)imageUrlArray.count) {
                
                CGSize contentSize = myScrollView.contentSize;
                contentSize.height = screenMySize.size.height;
                contentSize.width = screenMySize.size.width * i;
                myScrollView.contentSize = contentSize;
                return;
            }
            else
            {
                urlStr = [NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]];
                
            }
        }
        else
        {
            if (tmpView == nil) {
                CGSize contentSize = myScrollView.contentSize;
                contentSize.height = screenMySize.size.height;
                contentSize.width = screenMySize.size.width * i;
                myScrollView.contentSize = contentSize;
                return;
            }
        }
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        convertRect.origin.y =  convertRect.origin.y +64;
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image setUrl:urlStr];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.otherBodyScrollView) {
        [self changeTopColor:(self.otherBodyScrollView.contentOffset.x/self.otherBodyScrollView.frame.size.width)];
    }else{
        CGFloat pageWidth = scrollView.frame.size.width;
        currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == mTableView) {
#pragma 已阅未阅先隐藏
        if (![self.title isEqualToString:[menuLDArray objectAtIndex:1]]) {
            //设置已读
            FullCutModel *entity = self.showDataList[indexPath.row];
            if (1==0&&self.showDataList.count > indexPath.row) {
                touchRow = indexPath.row;
                //        NSLog(@"%d,%@",tagRow,entity.UDefine1);
                
                NSString *UDefine = [NSString stringWithFormat:@"%@",entity.UDefine1];
                if ([UDefine isEqualToString:@"False"]||[UDefine isEqualToString:@"false"]) {
                    NSMutableDictionary *postDic = [[NSMutableDictionary alloc]init];
                    [postDic setValue:entity.RowID forKey:@"RowID"];
                    [postDic setValue:[ToolCache userKey:kAccount] forKey:@"UserID"];
                    [postDic setValue:entity.ClassId forKey:@"ClassId"];
                    [serive PostFromURL:AChangeConfState params:postDic mHttp:httpUrl isLoading:NO];
                }
            }

            BOOL isXK = false;
            if (![entity.AuthorCompany isKindOfClass:[NSNull class]]) {
                isXK = [entity.AuthorCompany isEqualToString:@"西柯镇"];
            }
            
            DetialsViewController *vc = [[DetialsViewController alloc] init];
            vc.title = @"详情";
            vc.isXK = isXK;
            vc.dic = [fListArray objectAtIndex:indexPath.row];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView != commentTf)
    {
    //判断是否键盘正在弹出(用户点击评论 视图调整 不做键盘消失触发)
    if(isKeyboardShowing)
        return;
    
    [commentTf resignFirstResponder];
    }
}

#pragma mark - 评论

//点击评论
- (void)commentClick:(UIButton *)sender
{
    NSLog(@"comment click");
    selectedCommentBtn = sender;
    isArticleReply = NO;
    //获取评论按钮在self.view上的位置
    commentBtnFrameInWindow = [sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    if (bottomCommentTfView == nil || commentTf == nil)
    {
        [self setCommentReplyTextView];
//        bottomCommentTfView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
//        [bottomCommentTfView setBackgroundColor:[UIColor colorWithRed:248.0 green:248.0 blue:248.0 alpha:1]];
//        [self.view addSubview:bottomCommentTfView];
//        
//        commentTf = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-70, 40)];
//        commentTf.delegate = self;
//        commentTf.scrollEnabled = YES;
//        commentTf.font = [UIFont systemFontOfSize:16];
//        commentTf.returnKeyType = UIReturnKeySend;
//        
//        commentTf.layer.cornerRadius = 8;
//        commentTf.layer.masksToBounds =YES;
//        commentTf.layer.borderColor = [UIColor grayColor].CGColor;
//        commentTf.layer.borderWidth = 1.0f;
// 
////        [commentTf addTarget:self action:@selector(sendCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomCommentTfView addSubview:commentTf];
//        
//        //发送
//        UIButton *send = [UIButton buttonWithType:UIButtonTypeSystem];
//        send.frame = CGRectMake(self.view.frame.size.width-60, 5, 60, 40);
//        [send setTitle:@"发送" forState:UIControlStateNormal];
//        [send addTarget:self action:@selector(sendCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomCommentTfView addSubview:send];
        
    }
//    commentTf.placeholder = @"评论";
    
    if (isCommentEdting)
    {
        [commentTf resignFirstResponder];
        isCommentEdting = NO;
    }
    else
    {
        [commentTf becomeFirstResponder];
        isCommentEdting = YES;
    }
    
    
    isCommentEdting = !isCommentEdting;
    
    /* 调整tableView offset 提高用户体验 */
    float delay = 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (commentBtnFrameInWindow.origin.y+28 > tfViewOriginY)
        {
            isKeyboardShowing = YES;
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                float offsetY = commentBtnFrameInWindow.origin.y+28 - tfViewOriginY;
                CGPoint tmpContentOffset = mTableView.contentOffset;
                
                tmpContentOffset = CGPointMake(tmpContentOffset.x, tmpContentOffset.y+offsetY);
                
                mTableView.contentOffset = tmpContentOffset;
            } completion:^(BOOL finished) {
                isKeyboardShowing = NO;
            }];
            
        }
    });
    
}

//文章创建者回复评论
- (void)replyClick:(SingleReplyButton *)sender
{
    NSLog(@"reply click");
    SingleReplyBtn = sender;
    isArticleReply = YES;
    selectedCommentBtn = sender;
    //获取评论按钮在self.view上的位置
    commentBtnFrameInWindow = [sender convertRect:sender.bounds toView:[UIApplication sharedApplication].keyWindow];
    
    
    if (bottomCommentTfView == nil || commentTf == nil)
    {
//        bottomCommentTfView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
//        [bottomCommentTfView setBackgroundColor:[UIColor colorWithRed:138.0 green:142.0 blue:143.0 alpha:1]];
//        [self.view addSubview:bottomCommentTfView];
//        
//        commentTf = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-70, 40)];
//        commentTf.delegate = self;
//        commentTf.scrollEnabled = YES;
//        commentTf.returnKeyType = UIReturnKeySend;
//        commentTf.font = [UIFont systemFontOfSize:16];
//
//        commentTf.layer.cornerRadius = 8;
//        commentTf.layer.masksToBounds =YES;
//        commentTf.layer.borderColor = [UIColor grayColor].CGColor;
//        commentTf.layer.borderWidth = 0.5f;
//
//        [bottomCommentTfView addSubview:commentTf];
//        
//        //发送
//        UIButton *send = [UIButton buttonWithType:UIButtonTypeSystem];
//        send.frame = CGRectMake(self.view.frame.size.width-60, 5, 60, 40);
//        [send setTitle:@"发送" forState:UIControlStateNormal];
//        [send addTarget:self action:@selector(sendCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
//        [bottomCommentTfView addSubview:send];
        [self setCommentReplyTextView];
    }
    
//    commentTf.placeholder = @"回复";

    if (isCommentEdting)
    {
        [commentTf resignFirstResponder];
        isCommentEdting = NO;
    }
    else
    {
        [commentTf becomeFirstResponder];
        isCommentEdting = YES;
    }
    
    
    /* 调整tableView offset 提高用户体验 */
    float delay = 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (commentBtnFrameInWindow.origin.y+28 > tfViewOriginY)
        {
            isKeyboardShowing = YES;
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                float offsetY = commentBtnFrameInWindow.origin.y+23 - tfViewOriginY;
                CGPoint tmpContentOffset = mTableView.contentOffset;
                
                tmpContentOffset = CGPointMake(tmpContentOffset.x, tmpContentOffset.y+offsetY);
                
                mTableView.contentOffset = tmpContentOffset;
            } completion:^(BOOL finished) {
                isKeyboardShowing = NO;
            }];
            
        }
    });
}

//评论发送
- (void)sendCommentMessage:(UIButton *)sender
{
    NSLog(@"send");
    [commentTf resignFirstResponder];
    
    NSString *netStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"networkState"];
    
    if ([netStateStr isEqualToString:@"当前网络未连接"])
    {
        kAlertShow(netStateStr);
        return;
    }
    
    if (commentTf.text == nil || [commentTf.text isEqualToString:@""])
    {
        kAlertShow(@"评论内容不能为空!");
        return;
    }
    
    NSIndexPath *indexPath;
    
    if (!isArticleReply) {
        //获取按钮所在Cell及其indexpath
        UIView *contentView = [selectedCommentBtn superview];
        UITableViewCell *cell = (UITableViewCell *)[contentView superview];//uitableviewCell
        indexPath = [mTableView indexPathForCell:cell];

    }
    else
    {
        UIView *view1 = [selectedCommentBtn superview];
        UIView *view2 = [view1 superview];
        UIView *view3 = [view2 superview];
        UITableViewCell *cell = (UITableViewCell *)[view3 superview];
        indexPath = [mTableView indexPathForCell:cell];
    }
    
    //操作所在的cell indexPath.row
    goalIndexPathRow = indexPath.row;
    
    //SpecialID - 文章的编号
    NSDictionary *selectedArticleDic = fListArray[indexPath.row];
    NSString *specialId = [selectedArticleDic objectForKey:@"RowID"];//这里ID有问题
    //CreateID - 本账号
    NSString *creatID = [ToolCache userKey:kAccount];
    
    NSString *parmStr;
    
    if (!isArticleReply)
    {
        /* 发送评论请求  格式如下 --------------------------------------------------------------------------------------------
         //{"SpecialID”:1312,”Content":"评论测试2","CommentName":"","CommentDate":null,"Company":"","OrderNo":null,"CreateID”:”ggh”,”Createdate":null,"LastModifierID":"","LastModifyDate":null,"IMEINO":""}
         ------------------------------------------------------------------------------------------- */
        parmStr = [NSString stringWithFormat:@"{\"SpecialID\":%@,\"CreateID\":\"%@\",\"Content\":\"%@\"}",specialId,creatID,commentTf.text];

    }
    else
    {
        parmStr = [NSString stringWithFormat:@"{\"SpecialID\":%@,\"CreateID\":\"%@\",\"Content\":\"%@\",\"OrderNo\":\"%@\"}",specialId,creatID,commentTf.text,SingleReplyBtn.rowID];
        
    }
    
    NSDictionary *pushDic = @{@"source":parmStr};
    [serive PostFromURL:AUploadCommentData params:pushDic mHttp:httpUrl isLoading:NO];
    
    //清空textfield
    commentTf.text = @"";
}
//评论视图创建
- (void)setCommentReplyTextView
{
    bottomCommentTfView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
    [bottomCommentTfView setBackgroundColor:[UIColor colorWithRed:138.0 green:142.0 blue:143.0 alpha:1]];
    bottomCommentTfView.backgroundColor = [UIColor colorWithRed:138.0 green:142.0 blue:143.0 alpha:1];
    bottomCommentTfView.layer.borderWidth = 0.5f;
    bottomCommentTfView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:bottomCommentTfView];
    
    commentTf = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.view.frame.size.width-70, 40)];
    commentTf.delegate = self;
    commentTf.scrollEnabled = YES;
    commentTf.returnKeyType = UIReturnKeySend;
    commentTf.font = [UIFont systemFontOfSize:17];
    
    commentTf.layer.cornerRadius = 8;
    commentTf.layer.masksToBounds =YES;
    commentTf.layer.borderColor = [UIColor grayColor].CGColor;
    commentTf.layer.borderWidth = 0.5f;
    
    [bottomCommentTfView addSubview:commentTf];
    
    //发送
    UIButton *send = [UIButton buttonWithType:UIButtonTypeSystem];
    send.frame = CGRectMake(self.view.frame.size.width-60, 5, 60, 40);
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendCommentMessage:) forControlEvents:UIControlEventTouchUpInside];
    [bottomCommentTfView addSubview:send];
    
    isCommentEdting = NO;
}


#pragma mark - keyBoard method

- (void)keyboardWillChangeFrame:(NSNotification *)notify
{
    NSDictionary *notiDic = [notify userInfo];
    
    NSValue *frameEnd = [notiDic objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrame = [frameEnd CGRectValue];
    
    
/* 键盘带动输入栏 */
    CGRect tmpTfViewFrame = bottomCommentTfView.frame;
    
    if (keyboardFrame.origin.y == screenMySize.size.height)
        tmpTfViewFrame.origin.y = keyboardFrame.origin.y-64;
    else
        tmpTfViewFrame.origin.y = keyboardFrame.origin.y-50-64;
    
    bottomCommentTfView.frame = tmpTfViewFrame;
    
    //获取输入栏顶端y坐标
    tfViewOriginY = tmpTfViewFrame.origin.y+50;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentMessage:nil];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendCommentMessage:nil];
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    [serive cancelRequest];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
