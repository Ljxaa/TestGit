//
//  TSViewController.h
//  同安政务
//
//  Created by _ADY on 16/1/15.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSButtonView.h"

@interface TSViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,TSButtonViewDelegate>
{
    UIScrollView *gScrollView;
    TSButtonView *buttonView;
    NSArray *m1Array,*m2Array,*m3Array;
    UITableView *mTableView;
}
- (void)setFiset:(int)isF setSecond:(int)isS;
@end
