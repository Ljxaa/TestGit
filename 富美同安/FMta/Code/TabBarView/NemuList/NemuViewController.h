//
//  NemuViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/23.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"

@interface NemuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate>
{
    RequestSerive *serive;
}
@property (nonatomic, retain)UITableView * mTableView;
@property (nonatomic, retain)NSMutableArray *fListArray;
@property (nonatomic, strong)NSString *RowID;
@end
