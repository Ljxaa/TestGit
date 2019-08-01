//
//  ChildEasyListViewController.m
//  同安政务
//
//  Created by wx_air on 16/9/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "ChildEasyListViewController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "RequestSerive.h"
#import "ChildDataModel.h"
#import "LDHDViewController.h"

@interface ChildEasyListViewController ()<UITableViewDataSource,UITableViewDelegate,RSeriveDelegate>{
    int pageNum;
    RequestSerive *serive;
    
    NSInteger selectTouch;
    
//    NSArray *keyArray;//子列表数量key
}
@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataArray;
@end

@implementation ChildEasyListViewController
@synthesize RowID;
- (void)viewDidLoad {
    [super viewDidLoad];
//    keyArray = @[@"qjbz",@"qjw",@"jcdw",@"jcjw"];//责任落实
    
    serive = [[RequestSerive alloc]init];
    serive.delegate = self;
    pageNum = 0;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.tableView setBackgroundColor:bgColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setDelegate:self];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    [self.tableView.header beginRefreshing];
    //    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // Do any additional setup after loading the view.
}
- (void)loadNewData{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:RowID  forKey:@"ParentID"];
    [serive PostFromURL:AGetDepartmentClassList params:postDic mHttp:httpUrl isLoading:NO];
}
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetDepartmentClassList]) {
        if (dic != nil) {
            NSLog(@"清风：%@",dic);
            NSArray *arr = (NSArray *)dic;
            self.dataArray = [NSMutableArray arrayWithCapacity:arr.count];
            ChildDataModel *model;
            for (NSDictionary *d in arr) {
                model = [[ChildDataModel alloc]initWithDictionary:d];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
        }
    }else if ([urlName isEqualToString:AgetServiceDateTime]){
        NSString* selDateString = dic[@"NewDataSet"][@"Table"][@"msg"][@"text"];
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"touchDate"];
        
        NSMutableDictionary *dic2;
        if (dic==nil||dic.count==0) {
            dic = [[NSMutableDictionary alloc]init];
        }
        dic2 = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        ChildDataModel *model = [self.dataArray objectAtIndex:selectTouch];
//        if (keyArray.count>selectTouch&&![[keyArray objectAtIndex:selectTouch] isEqualToString:@""]) {
            [dic2 setValue:selDateString forKey:[NSString stringWithFormat:@"%@",model.Unread]];
            [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"touchDate"];
//        }
    }
}
- (void)loadMoreData{
    pageNum ++;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark-tableView代理
//表格数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSLog(@"%@,%d",dataList,dataList.count);
    return self.dataArray.count;
}

//表格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //指定cellIdentifier为自定义的cell
        static NSString *CellIdentifier = @"Cell";
        //自定义cell类
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        ChildDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = model.ClassName;
        return cell;
    }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    
    ChildDataModel *model = [self.dataArray objectAtIndex:indexPath.row];
    LDHDViewController *vc = [[LDHDViewController alloc] init];
    vc.title = model.ClassName;
    vc.hidesBottomBarWhenPushed = YES;
    vc.RowID = model.RowID;
    vc.isChild = YES;
    vc.isOther = true;
    [self.navigationController pushViewController:vc animated:YES];
    
    selectTouch = indexPath.row;
    [serive GetFromURL:AgetServiceDateTime params:nil mHttp:httpUrl isLoading:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
