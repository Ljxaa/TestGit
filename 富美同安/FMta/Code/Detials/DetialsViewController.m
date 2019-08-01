//
//  DetialsViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "DetialsViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "NewsViewController.h"
#import "NemuViewController.h"
#import "GiFHUD.h"
#import "FontSIzeViewController.h"
@implementation DetialsViewController
@synthesize dic,_photos,_thumbs,RowID,num,TotalCount,left,right;

#define ImageHiehgt 25

-(void)rightAction
{
    FontSIzeViewController *diet = [[FontSIzeViewController alloc ] init];
    [self.navigationController pushViewController:diet animated:YES];
}

-(void)getFontSize
{
    [webView removeFromSuperview];
    webView = nil;
    [mTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if foneSizeRight
    if (webINt != 0) {
        [webView removeFromSuperview];
        webView = nil;
        [mTableView reloadData];
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [GiFHUD dismiss];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = bgColor;
#if foneSizeRight
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] landscapeImagePhone:[UIImage imageNamed:@"more_press"]style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];
#endif
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height-49-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    if ([self.title isEqualToString:[menuArray objectAtIndex:4]]||[self.title isEqualToString:[menuArray objectAtIndex:5]]||[self.title isEqualToString:[menuArray objectAtIndex:2]])
    {
        self.left=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
        self.left.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:self.left];
        
        self.right=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
        self.right.direction=UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:self.right];
    }

    
    webINt = 0;
    
    [self performSelector:@selector(after) withObject:nil afterDelay:.1];
    
}

//#pragma mark - NJKWebViewProgressDelegate
//-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
//{
//    [_webViewProgressView setProgress:progress animated:YES];
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        if (pageForNumber < TotalCount)
        {
            pageForNumber ++;
            [self upDateTableView];
        }

    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {

        if (pageForNumber > 1)
        {
            pageForNumber --;
            [self upDateTableView];
        }
    }
}

-(void)after
{
    BOOL tabBool = NO;
    if ([self.title isEqualToString:[menuArray objectAtIndex:4]]||[self.title isEqualToString:[menuArray objectAtIndex:5]]) {
        tabBool = YES;
    }
    TabDetials = [[TabDetialsView alloc] initWithFrame:CGRectMake(0, screenMySize.size.height-49-64, screenMySize.size.width, 49) styleBool:tabBool];
    TabDetials.delegate = self;
    [self.view addSubview:TabDetials];

    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    
    if (dic == nil) {
        pageForNumber = 1;
        [self upDateTableView];
    }
    else
    {
        pageForNumber = num;
        [TabDetials setDetialsViewDic:self.dic];
    }
}

-(void)upDateTableView
{
    
    webINt = 0;
    [GiFHUD dismiss];
    [GiFHUD setGifWithImageName:@"bp.gif"];
    [GiFHUD showWithOverlay];
    
    NSMutableDictionary *tem = [[NSMutableDictionary alloc] init];
    [tem setValue:[ToolCache userKey:kDeviceToken] forKey:@"IMEINO"];
    [tem setValue:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
    [tem setValue:RowID forKey:@"classID"];
    [tem setValue:@"" forKey:@"lastTime"];
    [tem setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
    [tem setValue:[NSString stringWithFormat:@"%d",1] forKey:@"PageSize"];
    [serive PostFromURL:AGetDTInfoList params:tem mHttp:httpUrl isLoading:YES];
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)tem mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetDTInfoList])
    {
        [GiFHUD dismiss];
        if (tem != nil) {
            if ([tem[@"DataList"] count] > 0) {
              dic = [tem[@"DataList"] objectAtIndex:0];
            }
            [TabDetials setDetialsViewDic:self.dic];
            TotalCount = [tem[@"TotalCount"] intValue];
        }
        
        [mTableView reloadData];
    }
}

#pragma mark TabDetialsView按钮
-(void)getTag:(NSInteger)aTag
{
    if (aTag == 1) {
        if (pageForNumber > 1)
        {
           pageForNumber --;
            [self upDateTableView];
        }
    }
    else if (aTag == 2)
    {
        if (pageForNumber < TotalCount)
        {
            pageForNumber ++;
            [self upDateTableView];
        }
    }
    else if (aTag == 3)
    {
        NewsViewController *vc = [[NewsViewController alloc] init];
        vc.title = self.title;
        vc.hidesBottomBarWhenPushed = YES;
        vc.RowID = RowID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dic != nil) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return webINt+ImageHiehgt+titleLableH+30;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = bgColor;
    
    titleLableH = [ToolCache setString:[dic objectForKey:@"Title"] setSize:labelSize+2 setWight:screenMySize.size.width-20];
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(10, 0, screenMySize.size.width-20, titleLableH)];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.numberOfLines = 0;
    cellTitle.text = [dic objectForKey:@"Title"];
    cellTitle.backgroundColor = [UIColor clearColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+2];
    [cell.contentView addSubview:cellTitle];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    [timeTitle setFrame:CGRectMake(10, titleLableH, 120, 20)];
    timeTitle.textColor = [UIColor grayColor];
    timeTitle.backgroundColor = [UIColor clearColor];
    BOOL result1 = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"PublishDate"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if (![[dic objectForKey:@"PublishDate"] isEqual:@""] && !result1)
        timeTitle.text = [[dic objectForKey:@"PublishDate"] substringToIndex:10];
    timeTitle.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    [cell.contentView addSubview:timeTitle];
    
#if !foneSizeRight
    FontSizeView *aFont = [[FontSizeView alloc] initWithFrame:CGRectMake(screenMySize.size.width-150, titleLableH, 140, 20)];
    aFont.delegate = self;
    [cell.contentView addSubview:aFont];
#endif
    
    UILabel *time1Title = [[UILabel alloc] init];
    [time1Title setFrame:CGRectMake(10, titleLableH+20, 195, 20)];
    time1Title.textColor = [UIColor grayColor];
    time1Title.backgroundColor = [UIColor clearColor];
    BOOL result = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"Source"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if (![[dic objectForKey:@"Source"] isEqual:@""] && !result)
        time1Title.text = [NSString stringWithFormat:@"来源:%@",[dic objectForKey:@"Source"]];
    time1Title.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    [cell.contentView addSubview:time1Title];
    
    UIImage *lineImage = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:2];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:lineImage];
    [lineImageView setFrame:CGRectMake(10, timeTitle.frame.origin.y+timeTitle.frame.size.height+30, screenMySize.size.width-20, 2)];
    [cell.contentView addSubview:lineImageView];
    
    if (webINt != 0 && webView != nil)
    {
        [cell.contentView addSubview:webView];
    }
    else
    {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, ImageHiehgt+titleLableH+30, screenMySize.size.width-20, webINt)];
        webView.backgroundColor = bgColor;
        
        for (UIView *aView in [webView subviews])
        {
            if ([aView isKindOfClass:[UIScrollView class]])
            {
                [(UIScrollView *)aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条 （水平的类似）
                
                for (UIView *shadowView in aView.subviews)
                {
                    
                    if ([shadowView isKindOfClass:[UIImageView class]])
                    {
                        shadowView.hidden = YES;  //上下滚动出边界时的黑色的图片 也就是拖拽后的上下阴影
                    }
                }
            }
        }
        NSString *string = [dic objectForKey:@"Content"];
        
        string = [ToolCache setHtmlStr:string];
        
        webView.opaque = NO;
        [webView setScalesPageToFit:NO];
        webView.dataDetectorTypes = UIDataDetectorTypeNone;
        [cell.contentView addSubview:webView];
        
        NSString *webviewText = [ToolCache webString];
        
        NSString *htmlString = [webviewText stringByAppendingFormat:@"%@",string];
        if (_isXK) {
            htmlString = [htmlString stringByReplacingOccurrencesOfString:imageUrl withString:XKimageUrl];
        }
        [webView loadHTMLString:htmlString baseURL:nil];
        
        webView.delegate = self;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [webView addGestureRecognizer:singleTap];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        
        float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
        webINt = height;
        [webView setFrame:CGRectMake(10, ImageHiehgt+titleLableH+30, screenMySize.size.width-20, webINt)];
        
        
        
//        NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
//        [webView loadRequest:req];
//        
//        _webViewProgress = [[NJKWebViewProgress alloc] init];
//        webView.delegate = _webViewProgress;
//        _webViewProgress.webViewProxyDelegate = self;
//        _webViewProgress.progressDelegate = self;
//        
//        
//        CGRect navBounds = self.navigationController.navigationBar.bounds;
//        CGRect barFrame = CGRectMake(0,
//                                     navBounds.size.height - 2,
//                                     navBounds.size.width,
//                                     2);
//        _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
//        _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//        [_webViewProgressView setProgress:0 animated:YES];
//        
//        [self.navigationController.navigationBar addSubview:_webViewProgressView];

    }
    
    webView.scrollView.scrollEnabled = NO;

    return cell;
}

- (void)webViewDidFinishLoad:(UIWebView *)web1View
{
    int lSize = [[ToolCache userKey:kFontSize] intValue];
    NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%d",lSize];
    [web1View stringByEvaluatingJavaScriptFromString:jsString];
    
    webINt = web1View.scrollView.contentSize.height;
    [web1View setFrame:CGRectMake(10, ImageHiehgt+titleLableH+30, screenMySize.size.width-20, webINt)];
    [mTableView reloadData];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap
{
    NSString *string = [dic objectForKey:@"Content"];
//    if (_isXK) {
//        string = [string stringByReplacingOccurrencesOfString:imageUrl withString:XKimageUrl];
//    }
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    
    NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:string];
    int contAr = (int)imageUrlArray.count;
    for (int i = 0 ; i < contAr; i ++)
    {
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]]]];
        [thumbs addObject:photo];
        photo.caption =[dic objectForKey:@"Title"];
        [photos addObject:photo];
        
    }
    
    if (contAr ==0) {
        return;
    }

    self._photos = photos;
    self._thumbs = thumbs;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;//分享按钮,默认是
    browser.displayNavArrows = YES;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    // Reset selections
    if (photos.count>0) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.navigationController pushViewController:browser animated:YES];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    //    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    //    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
