//
//  MonitorViewController.h
//  FMta
//
//  Created by wx_air on 2017/3/27.
//  Copyright © 2017年 push. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHelper.h"
@interface MonitorViewController : UIViewController{
    UITableView *aTableView;
    NSMutableArray *resArray;
    MCHelper *wrapper;
}
@property (nonatomic, retain)Cvs2ResEntity *rootNode;
@end
