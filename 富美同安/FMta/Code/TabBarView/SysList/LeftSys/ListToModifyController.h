//
//  ListToModifyController.h
//  同安政务
//
//  Created by _ADY on 16/1/29.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
#import "ImgScrollView.h"
#import "TapImageView.h"
#import "FullCutModel.h"
#import "SendViewController.h"

@interface ListToModifyController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate,ImgScrollViewDelegate,TapImageViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIActionSheetDelegate>
{
    int pageForNumber;
    RequestSerive *serive;
    int howInt;
    int TotalCount;
    
    int tagRow;
    NSInteger currentIndex;
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    NSMutableArray *numHightArray,*titleHArray;
}
@property (nonatomic, retain) UITableView * mTableView;
@property (nonatomic, retain)  NSMutableArray *fListArray;
@end
