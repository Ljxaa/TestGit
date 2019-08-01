//
//  PushViewController.h
//  港务移动信息
//
//  Created by _ADY on 14-11-27.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "DetialsViewController.h"

@interface PushViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate>
{
    NSMutableDictionary *scArray;
    UITableView *myTableView;
    
    NSMutableArray *_selections;
    
}
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@end