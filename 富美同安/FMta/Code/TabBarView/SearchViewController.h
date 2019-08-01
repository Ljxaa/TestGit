//
//  SearchViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/17.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableDictionary *scArray;
    UITableView *mTableView;
}

@end
