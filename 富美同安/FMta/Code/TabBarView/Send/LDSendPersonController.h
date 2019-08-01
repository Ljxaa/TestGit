//
//  LDSendPersonController.h
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
@protocol LDSendPersonDelegate<NSObject>
- (void)doneSelect:(NSMutableArray *)userSet;
@end

@interface LDSendPersonController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate>
{
    RequestSerive *serive;
    
}
@property (nonatomic, retain)id<LDSendPersonDelegate> delegate;
@property (nonatomic, retain)NSString *deptName;//部门名称
@property (nonatomic, retain)UITableView * mTableView;
@property (nonatomic, retain)NSMutableArray *fListArray;
@property (nonatomic, retain)NSMutableArray *mSelectionUsers;
@end
