//
//  VideoViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "ViedoDetialsViewController.h"
#import "Reachability.h"
#import "Global.h"
#import "ToolCache.h"
#import "GiFHUD.h"
#import "FontSIzeViewController.h"

@interface ViedoDetialsViewController ()

@end

#define ImageHiehgt 40+180
#define kWaitViewTag2 200
@implementation ViedoDetialsViewController
@synthesize dic,movie;

-(void)rightAction
{
    FontSIzeViewController *diet = [[FontSIzeViewController alloc ] init];
    [self.navigationController pushViewController:diet animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频详情";
    self.view.backgroundColor = bgColor;
    
    
    Reachability  *hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    if (![hostReach isReachableViaWiFi]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"建议在Wi-Fi环境下观看。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [GiFHUD setGifWithImageName:@"bp.gif"];
    [GiFHUD showWithOverlay];
    
#if foneSizeRight
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] landscapeImagePhone:[UIImage imageNamed:@"more_press"]style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];
#endif
    
}

-(void)getFontSize
{
    if (gScrollView != nil) {
        [gScrollView removeFromSuperview];
        gScrollView = nil;
    }
    [self performSelector:@selector(tableShow) withObject:nil afterDelay:.1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (gScrollView != nil) {
        [gScrollView removeFromSuperview];
        gScrollView = nil;
    }
    [self performSelector:@selector(tableShow) withObject:nil afterDelay:.1];
}

-(void)tableShow
{
    gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height-64-49)];
    [gScrollView setPagingEnabled:NO];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:gScrollView];

    titleLableH = [ToolCache setString:[dic objectForKey:@"Title"] setSize:labelSize+2 setWight:screenMySize.size.width-20];
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(10, 0, screenMySize.size.width-20, titleLableH)];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.numberOfLines = 0;
    cellTitle.text = [dic objectForKey:@"Title"];
    cellTitle.backgroundColor = [UIColor clearColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+2];
    [gScrollView addSubview:cellTitle];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    [timeTitle setFrame:CGRectMake(10, titleLableH, 120, 20)];
    timeTitle.textColor = [UIColor grayColor];
    BOOL result1 = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"PublishDate"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if (![[dic objectForKey:@"PublishDate"] isEqual:@""] && !result1)
        timeTitle.text = [[dic objectForKey:@"PublishDate"] substringToIndex:10];
    timeTitle.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    timeTitle.backgroundColor = [UIColor clearColor];
    [gScrollView addSubview:timeTitle];
    
#if !foneSizeRight
    FontSizeView *aFont = [[FontSizeView alloc] initWithFrame:CGRectMake(screenMySize.size.width-150, titleLableH, 140, 20)];
    aFont.delegate = self;
    [gScrollView addSubview:aFont];
#endif
    
    UILabel *time1Title = [[UILabel alloc] init];
    [time1Title setFrame:CGRectMake(10, titleLableH+20, 195, 20)];
    time1Title.textColor = [UIColor grayColor];
    time1Title.backgroundColor = [UIColor clearColor];
    BOOL result = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"Source"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if (![[dic objectForKey:@"Source"] isEqual:@""] && !result)
        time1Title.text = [NSString stringWithFormat:@"来源:%@",[dic objectForKey:@"Source"]];
    time1Title.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    [gScrollView addSubview:time1Title];
    

    UIImage *lineImage = [[UIImage imageNamed:@"line.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:2];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:lineImage];
    [lineImageView setFrame:CGRectMake(10, timeTitle.frame.origin.y+timeTitle.frame.size.height+30, screenMySize.size.width-20, 2)];
    [gScrollView addSubview:lineImageView];

    //视频URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[dic objectForKey:@"VideoAddress"]]];
    //视频播放对象
    movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    movie.controlStyle = MPMovieControlStyleEmbedded;
    [movie.view setFrame:CGRectMake(10, 30+timeTitle.frame.origin.y+timeTitle.frame.size.height+5, screenMySize.size.width-20, ImageHiehgt-40)];
    movie.initialPlaybackTime = -1;
    [gScrollView addSubview:movie.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFullModeDidChange:) name:MPMoviePlayerWillEnterFullscreenNotification object:movie];//scale
    [movie setFullscreen:NO animated:YES];
    movie.shouldAutoplay = NO;//是否直接播放
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10+ImageHiehgt+titleLableH, screenMySize.size.width-20, screenMySize.size.height)];
    webView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
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
    NSString *string = [dic objectForKey:@"VideoDesc"];
    
    string = [ToolCache setHtmlStr:string];
    webView.delegate = self;
    webView.opaque = NO;
    [webView setScalesPageToFit:NO];
    webView.dataDetectorTypes = UIDataDetectorTypeNone;
    [gScrollView addSubview:webView];
    NSString *webviewText = [ToolCache webString];
    NSString *htmlString = [webviewText stringByAppendingFormat:@"%@",string];
    [webView loadHTMLString:htmlString baseURL:nil];

    webView.scrollView.scrollEnabled = NO;
    
    float height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    [webView setFrame:CGRectMake(10, ImageHiehgt+titleLableH, screenMySize.size.width-20, height)];
    
    
    TabDetialsView *TabDetials = [[TabDetialsView alloc] initWithFrame:CGRectMake(0, screenMySize.size.height-49-64, screenMySize.size.width, 49) styleBool:NO];
    TabDetials.delegate = self;
    [self.view addSubview:TabDetials];
    
    [TabDetials setDetialsViewDic:self.dic];
    
}

-(void)dealloc{
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:movie];
    [movie.view removeFromSuperview];

}

#pragma mark TabDetialsView按钮
-(void)getTag:(NSInteger)aTag
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView setFrame:CGRectMake(10, ImageHiehgt+titleLableH+30, screenMySize.size.width-20, webView.scrollView.contentSize.height)];
    [gScrollView setContentSize:CGSizeMake(screenMySize.size.width,webView.scrollView.contentSize.height+ImageHiehgt+titleLableH)];
    [GiFHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    [theMovie stop];
    
}

-(void)movieFullModeDidChange:(NSNotification*)notify
{
    [ToolCache setUserStr:@"1" forKey:KallowRotation];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [ToolCache setUserStr:@"0" forKey:KallowRotation];
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
