//
//  DetialsViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RequestSerive.h"
#import "TabDetialsView.h"
#import "FontSizeView.h"
//#import "NJKWebViewProgressView.h"
//NJKWebViewProgressDelegate
//#import "NJKWebViewProgress.h"
@interface DetialsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,RSeriveDelegate,TabDetialsViewDelegat,UIWebViewDelegate,FontSizeViewDelegat>
{
    UITableView *mTableView;
    NSMutableArray *_selections;
    RequestSerive *serive;
    int titleLableH;
    int pageForNumber;
    TabDetialsView *TabDetials;
    int webINt;
    UIWebView *webView;
    
//    NJKWebViewProgressView *_webViewProgressView;
//    NJKWebViewProgress *_webViewProgress;
}
@property (nonatomic,strong) UISwipeGestureRecognizer *left;
@property (nonatomic,strong) UISwipeGestureRecognizer *right;
@property(nonatomic, retain) NSMutableDictionary* dic;
@property (nonatomic, strong) NSString *RowID;
@property (nonatomic, strong) NSMutableArray *_photos;
@property (nonatomic, strong) NSMutableArray *_thumbs;
@property (nonatomic) int num;
@property (nonatomic) int TotalCount;

@property (nonatomic) BOOL isXK;
-(void)getTag:(NSInteger)aTag;
-(void)getFontSize;
@end
