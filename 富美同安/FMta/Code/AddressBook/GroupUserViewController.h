//
//  GroupUserViewController.h
//  厦门信息集团
//
//  Created by _ADY on 15-3-30.
//  Copyright (c) 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSegmentedControl.h"
#import <MessageUI/MessageUI.h>
#import "RequestSerive.h"

@protocol GroupAddressBookDelegate<NSObject>

@optional
- (void)cancel;
- (void)doneSelection:(NSMutableArray *)userSet;
@end

@interface GroupUserViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,RSeriveDelegate>
{
    CCSegmentedControl* segmentedControl;
    NSMutableArray *mGroupArray;//组别
    NSMutableArray *mContactArray;//组别内容
    NSMutableArray *mCurrentGroups;
    NSMutableSet *mDeptments;
    UIButton *mHeaderButton;//返回上级菜单按钮
    UILabel *mHeaderLabel,*cLabel;//返回上级菜单文字  cLabel常用
    int ccsType;//判断切换到哪个菜单
    NSMutableArray *ccGroupArray,*ccArray;//常用
    NSMutableArray *gzArray;//关注
    UIButton *gzBuuton;
    NSMutableArray *ssArray;//搜索
    NSMutableArray *mSearchResults;//搜索内容
    UISearchBar* mSearchBar;//搜索框
    UITableView *aTableView;
    RequestSerive *serive;
    
}
@property (nonatomic, retain)id<GroupAddressBookDelegate> delegate;
@property (nonatomic, assign)BOOL isMultChoose;//判断是否单选
@property (nonatomic, retain)NSMutableArray *mSelectionUsers;//选中的人
@property (nonatomic, assign)int groupBy;//0 电话短信 1 邮件  2 其他 3 公司

@property (nonatomic, copy)NSString *ChooseUserFilter;
@property (nonatomic, copy)NSString *ChooseUserFilterKey;
@end
