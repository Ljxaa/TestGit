//
//  TSViewController.m
//  同安政务
//
//  Created by _ADY on 16/1/15.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "TSViewController.h"
#import "Global.h"
@implementation TSViewController

#define mmHight 50

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height-64)];
    [gScrollView setPagingEnabled:YES];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:gScrollView];
    
    [gScrollView setContentSize:CGSizeMake(screenMySize.size.width*2,screenMySize.size.height-64)];
    
    [self performSelector:@selector(initBody) withObject:nil afterDelay:.1];
}
//修改后的webview
- (void)initBody{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, gScrollView.frame.size.width, gScrollView.frame.size.height)];
    //    webView.scalesPageToFit = YES;//适应屏幕
    //    webView.detectsPhoneNumbers = YES;//检测电话号码，单击可以拨打
    NSURL *url = [NSURL URLWithString:@"http://172.16.36.198:9007/Pages/admin/Economic/Economic.aspx"];
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:nsrequest];
    [gScrollView addSubview:webView];
    
    UIWebView *webView2 = [[UIWebView alloc]initWithFrame:CGRectMake(gScrollView.frame.size.width, 0, webView.frame.size.width, webView.frame.size.height)];
    NSURL *url2 = [NSURL URLWithString:@"http://172.16.36.198:9007/Pages/admin/Economic/Explanation.aspx"];
    NSURLRequest *nsrequest2 = [NSURLRequest requestWithURL:url2];
    [webView2 loadRequest:nsrequest2];
    [gScrollView addSubview:webView2];
}
//原来的视图
-(void)tableShow
{
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statistic"]];
    bgImage.frame =CGRectMake(screenMySize.size.width, 0, screenMySize.size.width, screenMySize.size.height-64);
    [gScrollView addSubview:bgImage];
    
    buttonView = [[TSButtonView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, 100)];
    buttonView.delegate = self;
    [gScrollView addSubview:buttonView];
    
    
    NSArray *fArray = [NSArray arrayWithObjects:@"财政总收入(地面口径)", @"财政总收入(体制口径)", @"镇街收入", @"规模以上工业产值", @"固定资产投资额(不含农户)",
                       @"工业固投" , @"限额以上批发零售贸易业销售总额" , @"合同利用外资" , @"实际利用外资", nil];
//    NSArray *secArray = [NSArray arrayWithObjects:@"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月", nil];
    NSArray *secArray = [NSArray arrayWithObjects:@"3月", nil];
    [buttonView setFirst:fArray setSecond:secArray];
    
    m1Array = [NSArray arrayWithObjects:@"同安区",@"大同街道",@"祥平街道",@"新民镇",@"西柯镇",@"五显镇",@"洪塘镇",@"莲花镇",@"汀溪镇",@"凤南农场",@" 竹坝农场", nil];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, screenMySize.size.width, self.view.frame.size.height-100)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [gScrollView addSubview:mTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    [self gotoS];
    

}

- (void)setFiset:(int)isF setSecond:(int)isS
{
    if (isF == 0) {
        
 
//    m2Array = [NSArray arrayWithObjects:@"",@"4.5",@"7.2",@"10.2",@"10.6",@"2.3",@"1.8",@"0.5",@"0.9",@"0.3",@"0.2", nil];
//    m3Array = [NSArray arrayWithObjects:@"",@"-15",@"14",@"17",@"14",@"45",@"30",@"11",@"-1",@"29",@"-6", nil];
        m2Array = [NSArray arrayWithObjects:@"--",@"0.8",@"1.9",@"2.1",@"3.3",@"0.2",@"0.7",@"0.1",@"0.1",@"0.1",@"0.1", nil];
        m3Array = [NSArray arrayWithObjects:@"--",@"-41.7",@"24.6",@"-16.1",@"23.3",@"-55.3",@"44.2",@"4.7",@"-63.6",@"54.1",@"-20.9", nil];
    }
    else if (isF == 1)
    {
//    m2Array = [NSArray arrayWithObjects:@"50.0",@"1.4",@"1.6",@"1.5",@"1.3",@"0.5",@"0.8",@"0.4",@"0.6",@"0.3",@"0.2", nil];
//    m3Array = [NSArray arrayWithObjects:@"3",@"-9",@"0.2",@"14",@"4",@"－6",@"－11",@"2",@"-13",@"28",@"-6", nil];
        m2Array = [NSArray arrayWithObjects:@"14.5",@"0.3",@"0.4",@"0.4",@"0.3",@"0.1",@"0.2",@"0.1",@"0.1",@"0.1",@"0.1", nil];
        m3Array = [NSArray arrayWithObjects:@"20.8",@"-27.1",@"-19.6",@"15.2",@"-2.5",@"-23.4",@"0.4",@"-7.4",@"-58.2",@"46.9",@"-20.9", nil];
    }
    
    else if (isF == 2)
    {
//    m2Array = [NSArray arrayWithObjects:@"14.0",@"0.2",@"0.3",@"0.3",@"0.5",@"0.1",@"0.2",@"0.1",@"0.1",@"0.04",@"0.03", nil];
//    m3Array = [NSArray arrayWithObjects:@"11",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
        m2Array = [NSArray arrayWithObjects:@"4.3",@"0.1",@"0.1",@"0.1",@"0.1",@"0.03",@"0.05",@"0.01",@"0.01",@"0.01",@"0.01", nil];
        m3Array = [NSArray arrayWithObjects:@"17.3",@"-25.6",@"-26.3",@"6.7",@"-6.7",@"-19.0",@"5.4",@"-30.7",@"-54.6",@"47.4",@"-33.7", nil];
    }
    else if (isF == 3)
    {
//    m2Array = [NSArray arrayWithObjects:@"479.3",@"35.8",@"95.4",@"109.5",@"145.4",@"17.2",@"57.0",@"5.5",@"6.0",@"7.7",@"--", nil];
//    m3Array = [NSArray arrayWithObjects:@"9",@"-3",@"-16",@"-2",@"5",@"7",@"120",@"7",@"10",@"29",@"--", nil];
        m2Array = [NSArray arrayWithObjects:@"142.3",@"8.3",@"22.4",@"42.8",@"39.6",@"5.0",@"19.7",@"1.5",@"1.0",@"2.1",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"12.4",@"-1.9",@"-10.5",@"-0.7",@"15.0",@"22.4",@"160.3",@"8.9",@"22.4",@"26.1",@"--", nil];
    }
    else if (isF == 4)
    {
//    m2Array = [NSArray arrayWithObjects:@"226.9",@"7.6",@"20.1",@"15.3",@"80.3",@"8.2",@"16.9",@"2.6",@"4.9",@"0.8",@"0.2", nil];
//    m3Array = [NSArray arrayWithObjects:@"40",@"45",@"2",@"-15",@"112",@"50",@"-8",@"-14",@"-53",@"39",@"-41", nil];
        m2Array = [NSArray arrayWithObjects:@"50.4",@"1.1",@"1.6",@"3.9",@"24.0",@"1.1",@"7.0",@"0.3",@"0.9",@"--",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"37.8",@"410.5",@"-80.4",@"107.4",@"278.7",@"-38.3",@"138.1",@"6.9",@"42.5",@"--",@"--", nil];
    
    }
    else if (isF == 5)
    {
//    m2Array = [NSArray arrayWithObjects:@"80.5",@"1.7",@"2.9",@"7.5",@"4.9",@"1.1",@"2.7",@"",@"1.1",@"0.5",@"", nil];
//    m3Array = [NSArray arrayWithObjects:@"56",@"67",@"114",@"-49",@"8",@"2",@"244",@"--",@"249",@"--",@"--", nil];
        m2Array = [NSArray arrayWithObjects:@"11.9",@"0.5",@"0.03",@"2.0",@"1.2",@"0.1",@"1.4",@"--",@"0.4",@"--",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"-35.4",@"--",@"-80.9",@"15.3",@"36.7",@"-76.6",@"-21.8",@"--",@"--",@"--",@"--", nil];
    }
    else if (isF == 6)
    {
//    m2Array = [NSArray arrayWithObjects:@"161.7",@"49.9",@"53.6",@"11.7",@"27.8",@"1.9",@"8.8",@"4.5",@"3.5",@"--",@"--", nil];
//    m3Array = [NSArray arrayWithObjects:@"10",@"1",@"-0.5",@"18",@"38",@"73",@"12",@"643",@"8",@"--",@"--", nil];
        m2Array = [NSArray arrayWithObjects:@"49.3",@"11.2",@"19.2",@"4.2",@"9.1",@"--",@"3.0",@"2.3",@"0.2",@"0.1",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"38.4",@"1.6",@"96.1",@"61.1",@"2.1",@"--",@"27.2",@"456.0",@"-68.6",@"371.5",@"--", nil];
    }
    else if (isF == 7)
    {
//    m2Array = [NSArray arrayWithObjects:@"22783",@"8123",@"10250",@"428",@"689",@"1032",@"1607",@"",@"559",@"",@"", nil];
//    m3Array = [NSArray arrayWithObjects:@"-36",@"69",@"15倍",@"-92",@"-97",@"6",@"--",@"-100",@"18倍",@"--",@"-100", nil];
        m2Array = [NSArray arrayWithObjects:@"4700",@"--",@"3696",@"387",@"264",@"--",@"--",@"--",@"--",@"--",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"-52.3",@"-100",@"12.6倍",@"-8.5",@"22.8",@"-100",@"--",@"--",@"-100",@"--",@"--", nil];
    }
    else if (isF == 8)
    {
//    m2Array = [NSArray arrayWithObjects:@"36148",@"7207",@"1221",@"2603",@"18000",@"1100",@"800",@"100",@"100",@"",@"", nil];
//    m3Array = [NSArray arrayWithObjects:@"39",@"9倍",@"-55",@"-75",@"31倍",@"11",@"148",@"3",@"--",@"--",@"--", nil];
        m2Array = [NSArray arrayWithObjects:@"10965",@"700",@"1800",@"700",@"650",@"150",@"800",@"50",@"150",@"--",@"--", nil];
        m3Array = [NSArray arrayWithObjects:@"-60.0",@"--",@"--",@"--",@"--",@"--",@"--",@"--",@"--",@"--",@"--", nil];
    }
    [mTableView reloadData];
}
-(void)gotoS
{
    
    UIScrollView *threeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenMySize.size.width*2, 0, screenMySize.size.width, screenMySize.size.height-64)];
    [threeScrollView setShowsHorizontalScrollIndicator:NO];
    [gScrollView addSubview:threeScrollView];
    
    [threeScrollView setContentSize:CGSizeMake(screenMySize.size.width,900)];
    
    UIImageView *_bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [threeScrollView addSubview:_bgImageView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect rect = CGRectMake(0,0, screenMySize.size.width,900);

        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor whiteColor] set];
        CGContextFillRect(context, rect);
        
        
        [@"说明" drawInRect:CGRectMake(screenMySize.size.width/2-30,5, screenMySize.size.width/2, 40) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:labelSize+3],NSForegroundColorAttributeName:[UIColor redColor]}];
        
        NSArray *tArray = [NSArray arrayWithObjects:@"区财政局：",@"区统计局、区经信局、区商务局：",@"区商务局：",@"财政局：",@"统计局：",@"商务局：", nil];
        NSArray *nArray = [NSArray arrayWithObjects:@"属地财政总收入、本级财政总收入、本级财政收入",@"固定资产投资额、工业固投、限额以上批发零售贸易业销售总额",@"合同利用外资、实际利用外资",@"1、属地财政总收入：镇街属地总收入合计与全区税收收入差额主要是1、通过市财政划转的原飞地税收收入；2、通过地税部门划转的建安及销售不动产税收\n2、本级财政总收入（财政口径）：由于今年执行新一轮区对镇财政体制，镇街分成企业有所变动，该指标的增长以新一轮体制同口径计算。\n3、本级财政收入：由于今年执行新一轮区对镇财政体制，镇街税收收入分成比例、分成税种均发生较大的改变，与上年同期不具可比性。",@"1、固定资产投资额1-3月有10.56亿元未划分，未划分包括跨镇、火炬、开发办三部分。\n2、工业固投1-3月有6.32亿元未划分，未划分包括火炬、开发办两部分。",@"实际利用外资没有各镇（街、场）2015年的统计基数，因此无法计算增长速度。", nil];
        float oldHeight = 0;
        float piancha = 00;
        for (int i = 0; i <  tArray.count; i ++) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [[nArray objectAtIndex:i] boundingRectWithSize:CGSizeMake(screenMySize.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            NSLog(@"height:%f",size.height);
            if(i==1){
                piancha = 50;
            }
            
            [[tArray objectAtIndex:i] drawInRect:CGRectMake(10,5+40+i*100-piancha+oldHeight, screenMySize.size.width, 25) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:labelSize+3],NSForegroundColorAttributeName:[UIColor redColor]}];
            [[nArray objectAtIndex:i] drawInRect:CGRectMake(20,5+70+i*100-piancha+oldHeight, screenMySize.size.width-30, 90+size.height) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:labelSize-1],NSForegroundColorAttributeName:[UIColor blackColor]}];
            
            
            oldHeight = size.height;
            if (i==tArray.count-3) {
                oldHeight += 50;
            }else if (i==tArray.count-2){
                oldHeight += 200;
            }
            
        }
        
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{

                _bgImageView.frame = rect;
                _bgImageView.image = nil;
                _bgImageView.image = temp;
            
        });
    });
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, mmHight)];
        myView.backgroundColor = [UIColor colorWithRed:241/255.0 green:249/255.0 blue:252/255.0 alpha:1];
        
        for (int i = 0; i <  3; i ++) {
            float atanF = 0.5;
            if (i == 2) {
                atanF = 0.0;
            }
            UILabel *_name1Label = [[UILabel alloc] initWithFrame:CGRectMake(screenMySize.size.width*i/3, 0, screenMySize.size.width/3+atanF, mmHight+.5)];
            _name1Label.textAlignment = 1;
            [_name1Label.layer setBorderWidth:.5];
            [_name1Label.layer setBorderColor:[UIColor grayColor].CGColor];
            _name1Label.textColor = [UIColor orangeColor];
            [myView addSubview:_name1Label];
            if (i == 0) {
                _name1Label.text = @"同安区各镇(街)";
            }
            if (i == 1) {
                _name1Label.text = @"实绩(亿元)";
            }
            if (i == 2) {
                _name1Label.text = @"增长(%)";
            }
        }
        
        return myView;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return mmHight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return m3Array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return mmHight;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"tsCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tsCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    for (int i = 0; i <  3; i ++) {
        float atanF = 0.5;
        if (i == 2) {
            atanF = 0.0;
        }
        UILabel *_name1Label = [[UILabel alloc] initWithFrame:CGRectMake(screenMySize.size.width*i/3, 0, screenMySize.size.width/3+atanF, mmHight+.5)];
        _name1Label.textAlignment = 1;
        [_name1Label.layer setBorderWidth:.5];
        [_name1Label.layer setBorderColor:[UIColor grayColor].CGColor];
        _name1Label.textColor = [UIColor blackColor];
        [cell.contentView addSubview:_name1Label];
        if (i == 0) {
            _name1Label.text = [m1Array objectAtIndex:indexPath.row];
        }
        if (i == 1) {
           _name1Label.text = [m2Array objectAtIndex:indexPath.row];
        }
        if (i == 2) {
            _name1Label.text = [m3Array objectAtIndex:indexPath.row];
       
            if ([[NSString stringWithFormat:@"%@",[m3Array objectAtIndex:indexPath.row]] intValue] >= 0) {
               _name1Label.textColor = [UIColor redColor];
            }
            else
                _name1Label.textColor = [UIColor greenColor];
        }
    }
    return cell;
}

@end
