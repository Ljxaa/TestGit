//
//  AddressHomeController.h
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCSegmentedControl.h"
#import <MessageUI/MessageUI.h>
#import "RequestSerive.h"

@protocol AddressHomeDelegate<NSObject>

@optional
- (void)cancel;
- (void)doneSelection:(NSMutableArray *)userSet;
@end

@interface AddressHomeController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate,RSeriveDelegate>
{
    CCSegmentedControl* segmentedControl;
    NSMutableArray *mGroupArray;//组别
    NSMutableArray *mContactArray;//组别内容
    NSMutableArray *mCurrentGroups;
    NSMutableSet *mDeptments;
    UIButton *mHeaderButton;//返回上级菜单按钮
    
    UIView *summaryView;//简介文字
    UILabel *summaryLabel;//简介文字
    
    UILabel *mHeaderLabel;//返回上级菜单文字
    int ccsType;//判断切换到哪个菜单
    UIButton *gzBuuton;
    UITableView *aTableView;
    RequestSerive *serive;
    
}
@property (nonatomic, retain)id<AddressHomeDelegate> delegate;
@property (nonatomic, assign)BOOL isMultChoose;//判断是否单选
@property (nonatomic, retain)NSMutableArray *mSelectionUsers;//选中的人
@property (nonatomic, assign)int groupBy;//0 电话短信 1 邮件  2 其他 3 公司

@property (nonatomic, assign)BOOL isShowUnit;//判断是否显示部门通讯录
@end
