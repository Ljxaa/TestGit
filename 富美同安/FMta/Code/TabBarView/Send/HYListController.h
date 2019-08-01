//
//  HYListController.h
//  同安政务
//
//  Created by _ADY on 16/1/6.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
@protocol HYListDelegat<NSObject>
-(void)HYAction:(NSMutableArray*)aTag;
@end
@interface HYListController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate>
{
    RequestSerive *serive;
    int pageForNumber;
}
@property (unsafe_unretained) id <HYListDelegat> delegate;
@property (nonatomic, retain)UITableView * mTableView;
@property (nonatomic, retain)NSMutableArray *fListArray;
@property (nonatomic, strong)NSString *RowID;
@end
