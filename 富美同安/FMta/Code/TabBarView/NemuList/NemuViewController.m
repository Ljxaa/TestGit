//
//  NemuViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "NemuViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "DetialsViewController.h"
#import "UIImageView+WebCache.h"
#import "NewsViewController.h"
@implementation NemuViewController
@synthesize mTableView,fListArray,RowID;
#define sizeHight1 40
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.frame.size.height-64)];
//    mTableView.delegate = self;
//    mTableView.dataSource = self;
//    mTableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:mTableView];
//    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
//    [mTableView setTableFooterView:v];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];

    [serive PostFromURL:AGetDuBanList params:nil mHttp:httpUrl isLoading:NO];
    fListArray = [[NSMutableArray alloc] init];
    
}
-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetDuBanList])
    {
        if (dic != nil) {
            for (NSDictionary *a in dic) {
                [fListArray addObject:a];
            }
            [self upDateTableView];
        }
//        [mTableView reloadData];

    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

//#define scrollWidth screenMySize.size.width/3
//#define scrollHight self.view.bounds.size.height/3
-(void)upDateTableView
{
    UIScrollView *gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, screenMySize.size.width, self.view.bounds.size.height)];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    gScrollView.pagingEnabled = YES;
    [gScrollView setContentSize:CGSizeMake(((fListArray.count-1)/9)*screenMySize.size.width+screenMySize.size.width,self.view.bounds.size.height)];
    [self.view addSubview:gScrollView];
    int  scrollWidth  = screenMySize.size.width/3;
    int  scrollHight =  self.view.bounds.size.height/3;
    int imageSize = scrollWidth - 30;
    if (scrollWidth+20 > scrollHight) {
        imageSize = scrollHight - 55;
    }
    for (int i = 0; i < fListArray.count; i++)
    {
        int xInt = (i%3)*scrollWidth+(int)(i/9)*screenMySize.size.width;
        int yInt = (int)((i%9)/3)*scrollHight;
        UIView *bgView = [[UIView alloc] init];
        [bgView.layer setBorderWidth:.5];
        [bgView.layer setBorderColor:[UIColor grayColor].CGColor];
//        [bgView.layer setCornerRadius:5];
        [bgView setFrame:CGRectMake(xInt+.5, yInt+.5, scrollWidth+.5, scrollHight+.5)];
        [gScrollView addSubview:bgView];
        
        UIImageView *ImageView = [[UIImageView alloc] initWithFrame:CGRectMake((scrollWidth-imageSize)/2,10, imageSize,imageSize)];
        ImageView.contentMode =  UIViewContentModeScaleAspectFit;
        ImageView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
        [ImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,fListArray[i][@"Picture"]]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
        [bgView addSubview:ImageView];
        
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ImageView.frame.size.height+ImageView.frame.origin.y+5, scrollWidth-20, 30)];
        _titleLabel.textAlignment = 1;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = fListArray[i][@"ClassName"];
        [bgView addSubview:_titleLabel];
        
        UILabel *_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ImageView.frame.size.height+ImageView.frame.origin.y+40, scrollWidth-20, 10)];
        _nameLabel.textAlignment = 1;
//#warning 此处修改（显示类型）
        _nameLabel.text = [NSString stringWithFormat:@"%@",fListArray[i][@"Type"]];
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        _nameLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [bgView addSubview:_nameLabel];
        
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setFrame:CGRectMake(0, 0, scrollWidth, scrollHight)];
        aButton.tag = 100 + i;
        [aButton addTarget:self action:@selector(aAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:aButton];
        
    }

}

-(void)aAction:(id)sender
{
    int type = (int)((UIButton*)sender).tag - 100;
    
    NewsViewController *vc = [[NewsViewController alloc] init];
    vc.title = self.title;
    vc.hidesBottomBarWhenPushed = YES;
    vc.RowID = fListArray[type][@"RowID"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sizeHight1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"NemuViewController"];
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"NemuViewController"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aTableView.showsVerticalScrollIndicator = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    cell.textLabel.text = fListArray[indexPath.row][@"ClassName"];
    cell.backgroundColor = bgColor;
    if (indexPath.row+1 != fListArray.count) {
        UIImageView *lImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
        [lImageView setFrame:CGRectMake(10, sizeHight1-2, screenMySize.size.width-20, 2)];
        [cell.contentView addSubview:lImageView];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    DetialsViewController *vc = [[DetialsViewController alloc] init];
    vc.title = self.title;
    vc.hidesBottomBarWhenPushed = YES;
    vc.RowID = fListArray[indexPath.row][@"RowID"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
