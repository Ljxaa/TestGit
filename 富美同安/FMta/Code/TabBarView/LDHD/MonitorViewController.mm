//
//  MonitorViewController.m
//  FMta
//
//  Created by wx_air on 2017/3/27.
//  Copyright © 2017年 push. All rights reserved.
//

#import "MonitorViewController.h"
//#import "AppDelegate.h"
#import "Cvs2VideoView.h"
#import "VideoPlayController.h"

@interface MonitorViewController ()<MCHelperDelegate,UITableViewDelegate,UITableViewDataSource>{
    VideoPlayController *videoController;
    NSInteger touchLevel;
    NSArray *peerUnits;
}

@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"防汛视频（资源列表）";
    resArray = [[NSMutableArray alloc] init];
//    AppDelegate *app = [AppDelegate app];
//    wrapper = app.wrapper;
    MCHelper *aWrapper = [[MCHelper alloc] init];
    wrapper = aWrapper;
    wrapper.delegate = self;
    
    touchLevel = 0;
    
    aTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+100)];
    [aTableView setDelegate:self];
    [aTableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)]];
    [aTableView setDataSource:self];
    [self.view addSubview:aTableView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"return_white"] forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0, 0, 37*.7, 34*.7)];
    [backBtn addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = item;
    [self login];
    // Do any additional setup after loading the view.
}

- (void)touchBack{
    if (touchLevel == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (touchLevel == 1){
        touchLevel = 0;
        [resArray removeAllObjects];
        [resArray addObjectsFromArray:peerUnits];
        [aTableView reloadData];
    }else if(touchLevel == 2){
        touchLevel = 1;
        [wrapper stopRend];
        [videoController.view removeFromSuperview];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [wrapper stopRend];
    [self loginOut];
}

- (void)reLoadResList:(Cvs2ResEntity *)pRoot
{
    [resArray removeAllObjects];
    
    int nCount = [pRoot.childrenArray count];
    for (int i=0; i<nCount; i++)
    {
        Cvs2ResEntity *pRes = [pRoot.childrenArray objectAtIndex:i];
        [resArray addObject:pRes];
    }
    
    [aTableView reloadData];
}

- (void)selectCell:(int)nSelect
{
    Cvs2ResEntity *pRes = [resArray objectAtIndex:nSelect];
    if (pRes.resType == kCvs2PeerUnit)
    {
        // 如果点击的是设备资源就去获取设备下的摄像头
        [wrapper fetchCameras:nil];
        touchLevel = 1;
        [self reLoadResList:pRes];
    }
    else if (pRes.resType == kCvs2Camera)
    {
        touchLevel = 2;
        // 播放视频
        Cvs2ResEntity *pVideo = (Cvs2ResEntity *)pRes;
        videoController = [[VideoPlayController alloc] initWithNibName:@"VideoPlayController"
                                                                bundle:nil];
//        videoController = [[VideoPlayController alloc]init];
        videoController.pVideo = pVideo;
        videoController.wrapper = wrapper;
        videoController.view.frame = self.view.bounds;
        
        self.navigationItem.title = pVideo.resName;
        [self.view addSubview:videoController.view];
        [wrapper rend:pVideo.puid index:nSelect streamType:0 target:videoController.view];
//        [self.navigationController pushViewController:videoController animated:YES];
    }
}

- (void)login
{
    NSString *strUsername = @"yidong";
    NSString *strPassword = @"123456";
//    NSString *strIPAddress = @"112.5.196.158";
    NSString *strIPAddress = @"183.250.154.137";
    
    NSString *strEPID = @"system";
    NSInteger nRet = [wrapper login:strIPAddress port:9988 user:strUsername psd:strPassword epid:strEPID fixedAddr:NO];
    if (nRet == 0)
    {
        peerUnits = [wrapper fetchPeerUnits:&nRet];
        [resArray removeAllObjects];
        [resArray addObjectsFromArray:peerUnits];
        
//        [self resetButtonStatus:YES];
    }
    
    [aTableView reloadData];
}

- (void)loginOut
{
    [resArray removeAllObjects];
    [wrapper loginOut];
    [aTableView reloadData];
    
//    [self resetButtonStatus:NO];
}

#pragma mark Table View Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [resArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ResourcesListIdentifier = @"ResourcesListIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             ResourcesListIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: ResourcesListIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    // 设置箭头标记
    if (row > 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    Cvs2ResEntity *pRes = [resArray objectAtIndex:row];
    cell.textLabel.text = pRes.resName;
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods


// 设置每行高度
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int nRow = [indexPath row];
    [self selectCell:nRow];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)connectError:(NSInteger)error
{
    
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
