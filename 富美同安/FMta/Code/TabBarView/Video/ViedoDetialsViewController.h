//
//  VideoViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TabDetialsView.h"
#import "FontSizeView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface ViedoDetialsViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,TabDetialsViewDelegat,FontSizeViewDelegat>
{
    NSMutableDictionary* dic;
    int  titleLableH;
    UIScrollView *gScrollView;
}
@property(nonatomic,strong) MPMoviePlayerController *movie;
@property(nonatomic, retain) NSMutableDictionary* dic;
-(void)getFontSize;
@end
