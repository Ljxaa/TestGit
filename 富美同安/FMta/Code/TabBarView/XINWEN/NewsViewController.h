//
//  NewsViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/22.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "RequestSerive.h"
#import "NewsView.h"
#import "ViedoDetialsViewController.h"

@interface NewsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate,NewsViewDelegat>
{
    int pageForNumber;
    RequestSerive *serive;
    int TotalCount;
    BOOL notImage;
    NewsView *NewsViews;
    int IsScroll;
}
@property (nonatomic, retain) UITableView * mTableView;
@property (nonatomic, retain)  NSMutableArray *fListArray;
@property (nonatomic, retain)  NSMutableArray *imageFArray;
@property (nonatomic, strong) NSString *RowID;

-(void)inAction:(int)aTag;
@end
