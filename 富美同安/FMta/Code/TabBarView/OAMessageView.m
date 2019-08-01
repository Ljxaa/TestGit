//
//  OAMessageView.m
//  同安政务
//
//  Created by wx_air on 16/5/13.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "OAMessageView.h"
#import "MJRefresh.h"
#import "RequestSerive.h"
#import "OACell.h"
#import "Global.h"
#import "ToolCache.h"
#import "OaListModel.h"
#import "CustomBadge.h"
#import "OADetailViewController.h"

#define pageSize 20

@interface OAMessageView()<UITableViewDelegate,UITableViewDataSource,RSeriveDelegate>{
    NSInteger pageNumber;
    RequestSerive *request;
    UIView *BodyView;
    
    UIButton *old_btn;
    BOOL isMeetting;//是否是会议
    
    NSString *requestUrl;//访问的url
    NSArray *urlArray;
    
    NSMutableArray *customBadgeArr;//保存customBadge的列表
    UILabel *labelNoData;//没有数据的时候显示
}

@end

@implementation OAMessageView

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"OA消息";
    [self.view setBackgroundColor:bgColor];
    request = [[RequestSerive alloc]init];
    [request setDelegate:self];
    
    [self initBody];
}

- (void)initBody{
    NSArray *titleArr = @[@"待批待办",@"会议管理",@"公文交换"];
    urlArray = @[AgetTask,AgetSignHYTZ,AgetSignGWJH];
    requestUrl = AgetTask;
    BodyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [BodyView setBackgroundColor:bgColor];
    [self.view addSubview:BodyView];
    
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BodyView.frame.size.width, 40)];
    [viewTop setBackgroundColor:[UIColor orangeColor]];
    [BodyView addSubview:viewTop];
    
    //顶部三个按钮
    UIView *view1;
    UIButton *btn1;
    CustomBadge *customBadge;
    customBadgeArr = [NSMutableArray arrayWithCapacity:titleArr.count];
    for (int i = 0; i<titleArr.count; i++) {
        view1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame), 0, viewTop.frame.size.width/titleArr.count, viewTop.frame.size.height)];
        [view1 setBackgroundColor:blueFontColor];
        [viewTop addSubview:view1];
        
        btn1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, view1.frame.size.width-20, view1.frame.size.height-10)];
        [btn1 setTitle:[titleArr objectAtIndex:i] forState:0];
        [btn1 setBackgroundImage:[ToolCache createImageWithColor:blueFontColor] forState:0];
        [btn1 setBackgroundImage:[ToolCache createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        [btn1.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn1 setTitleColor:blueFontColor forState:UIControlStateSelected];
        [btn1 setTitleColor:[UIColor whiteColor] forState:0];
        [btn1.layer setCornerRadius:btn1.frame.size.height/2];
        [btn1 setClipsToBounds:YES];
        if (i==0) {
            old_btn = btn1;
            btn1.selected = YES;
        }
        [btn1 addTarget:self action:@selector(touchTop:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setTag:i+100];
        
        [view1 addSubview:btn1];
        
        //数量
        
        [customBadgeArr addObject:view1];
    }
//    NSLog(@"%@,%d",customBadgeArr,customBadgeArr.count);
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTop.frame), BodyView.frame.size.width, BodyView.frame.size.height-CGRectGetMaxY(viewTop.frame))];
    self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.scrollsToTop=NO;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [BodyView addSubview:self.tableView];
    
    labelNoData = [[UILabel alloc]initWithFrame:self.tableView.frame];
    [labelNoData setTextAlignment:NSTextAlignmentCenter];
    [labelNoData setHidden:YES];
    [BodyView addSubview:labelNoData];
    
    pageNumber=1;
    //下拉刷新和上拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reflashNewData)];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.tableView.header beginRefreshing];
    [self pushCount];
}
-(void)touchTop:(UIButton *)btn{
    if (old_btn != btn) {
        [old_btn setSelected:NO];
        btn.selected = !btn.selected;
        old_btn = btn;
        
        [request cancelRequest];
        [self.tableView.header endRefreshing];
    }else{
        return;
    }
    requestUrl = [urlArray objectAtIndex:btn.tag-100];
    if ([btn.titleLabel.text isEqualToString:@"会议管理"]) {
        isMeetting = YES;
    }else{
        isMeetting = NO;
    }
    [self.tableView.header beginRefreshing];
}
#pragma mark - 读取新数据
-(void)loadNewData{
    [self pushData:++pageNumber];
}
-(void)reflashNewData{
    pageNumber=1;
    //    NSLog(@"刷新:%@",type);
    [self pushData:pageNumber];
}
//初始化数据
-(void)pushData:(NSInteger)page{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:[ToolCache userKey:KPhoneNumber] forKey:@"userAccount"];
    [dic setValue:[NSNumber numberWithInteger:page] forKey:@"nCurPage"];
    [dic setValue:[NSNumber numberWithInt:pageSize] forKey:@"nPageItems"];
    
    if ([requestUrl isEqualToString:AgetTask]) {
        [dic setValue:@"sw|zfbfw|zffw" forKey:@"wfSubCode"];
        [dic setValue:@"" forKey:@"userGroupid"];
    }
//    NSLog(@"requestUrlrequestUrl:%@",requestUrl);
    [request PostFromURL:requestUrl params:dic mHttp:httpUrl isLoading:NO];
}
- (void)pushCount{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setValue:[ToolCache userKey:KPhoneNumber] forKey:@"userAccount"];
    [dic setValue:@"" forKey:@"wfSubCode"];
    [dic setValue:@"" forKey:@"userGroupid"];
    [request PostFromURL:AgetOACount params:dic mHttp:httpUrl isLoading:NO];
}
#pragma mark - tableView代理
//section数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//表格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}
//表格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return OACell_height;
}
//表格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定cellIdentifier为自定义的cell
    static NSString *CellIdentifier = @"CellOA";
    //自定义cell类
    OACell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[OACell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    OaListModel *model = [_dataList objectAtIndex:indexPath.row];
    [cell setModelData:model urlName:requestUrl];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
    if (!isMeetting) {
        kAlertShow(@"请前往电脑端处理.");
    }
    OaListModel *model = [_dataList objectAtIndex:indexPath.row];
    OADetailViewController *pushView = [[OADetailViewController alloc]init];
    [pushView setHyId:model.ProcID];
    [self.navigationController pushViewController:pushView animated:YES];
}
#pragma mark - 请求返回
- (void)responseData:(NSDictionary*)dic mUrl:(NSString*)urlName{
    if (dic==nil) {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        
        if (pageNumber==1){
//            NewDataSet =     {
//                Table =         {
//                    SignGWJHCount =             {
//                        text = 9;
//                    };
//                    SignHYTZCount =             {
//                        text = 3;
//                    };
//                    TaskCount =             {
//                        text = 39;
//                    };
//                };
//            };
        }
        return;
    }else{
        
        if ([urlName isEqualToString:AgetOACount]) {
//            NSLog(@"数量%@",dic);
            NSArray *keyArr = @[@"TaskCount",@"SignHYTZCount",@"SignGWJHCount"];
            CustomBadge *customBadge;
            for (int i=0; i<customBadgeArr.count; i++) {
                UIView *view1 = [customBadgeArr objectAtIndex:i];
                NSString *str = [NSString stringWithFormat:@"%@",dic[@"NewDataSet"][@"Table"][[keyArr objectAtIndex:i]][@"text"]];
                if (str != nil && [str intValue] > 0) {
                    customBadge = [CustomBadge customBadgeWithString:str
                                                     withStringColor:[UIColor whiteColor]
                                                      withInsetColor:[UIColor redColor]
                                                      withBadgeFrame:YES
                                                 withBadgeFrameColor:[UIColor whiteColor]
                                                           withScale:1.0
                                                         withShining:YES];
                    [customBadge setFrame:CGRectMake(view1.frame.size.width-30, 0, 25, 25)];
                    [view1 addSubview:customBadge];
                }
            }
        }else{
//            NSLog(@"OA消息::%@",dic);
            NSDictionary *dicOne = dic[@"NewDataSet"];
            if ([dicOne.allKeys containsObject:@"Table"]) {
                NSDictionary *dicTwo = dicOne[@"Table"];
                if ([dicTwo isKindOfClass:[NSArray class]]) {
                    [labelNoData setHidden:YES];
                    [self.tableView setHidden:NO];
                }else{
                    if ([dic[@"NewDataSet"][@"Table"][@"flag"][@"text"] isEqualToString:@"False"]) {
                        [labelNoData setText:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
                        [labelNoData setHidden:NO];
                        [self.tableView setHidden:YES];
                        [self.tableView.header endRefreshing];
                        return;
                    }
                }
            }else{
                [labelNoData setHidden:YES];
                [self.tableView setHidden:NO];
            }
            
//            if ([dic[@"NewDataSet"][@"Table"][@"flag"][@"text"] isEqualToString:@"False"]) {
//                [labelNoData setText:dic[@"NewDataSet"][@"Table"][@"msg"][@"text"]];
//                [labelNoData setHidden:NO];
//                [self.tableView setHidden:YES];
//                [self.tableView.header endRefreshing];
//                return;
//            }else{
//                [labelNoData setHidden:YES];
//                [self.tableView setHidden:NO];
//            }
            if (pageNumber == 1) {
                if (_dataList) {
                    [_dataList removeAllObjects];
                }else{
                    _dataList = [[NSMutableArray alloc]init];
                }
            }
            NSArray *dataArr;
            if ([urlName isEqualToString:AgetTask]) {
                //            NSLog(@"代办%@",dic);
                dataArr = dic[@"NewDataSet"][@"Table1"];
            }else{
                dataArr = dic[@"NewDataSet"][@"Table"];
            }
//            NSLog(@"OA消息222::%@",dataArr);
            
            OaListModel *model;
            for (NSDictionary *dic2 in dataArr) {
                model = [[OaListModel alloc]initWithDictionary:dic2 urlType:urlName];
                [_dataList addObject:model];
            }
            
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            if (dataArr.count < pageSize) {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.footer endRefreshing];
            }
        }
        
    }
}
@end
