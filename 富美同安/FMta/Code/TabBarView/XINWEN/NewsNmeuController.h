//
//  NewsNmeuController.h
//  同安政务
//
//  Created by _ADY on 16/1/19.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "RequestSerive.h"
#import "NewsView.h"
#import "ViedoDetialsViewController.h"
#import "CCSegmentedControl.h"

@interface NewsNmeuController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate,NewsViewDelegat>
{
    int pageForNumber;
    RequestSerive *serive;
    int TotalCount;
    BOOL notImage;
    NewsView *NewsViews;
    int IsScroll;
    
    
    UIView *tabView;
    UIScrollView *tScrollView;
    UIScrollView *gScrollView;
    CCSegmentedControl* segmentedControl;
    int whatNum;
    NSMutableArray * arrayN;
    NSMutableDictionary *allArray;
    NSMutableDictionary *ImageArray;
    //第几页
    NSMutableDictionary *pageNumber;
    int scrollViewWidth;
    
}
@property (nonatomic, retain) UITableView * mTableView;
//@property (nonatomic, retain)  NSMutableArray *fListArray;
//@property (nonatomic, retain)  NSMutableArray *imageFArray;
@property (nonatomic, strong) NSString *RowID;
@property (nonatomic) BOOL isChild_Page;//page类型进入

@property (nonatomic) BOOL isOther_Page;//银城清风类型进入
-(void)inAction:(int)aTag;
-(void)upDateTableView;//刷新表格
@end

