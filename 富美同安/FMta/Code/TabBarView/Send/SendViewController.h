//
//  SendViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/24.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
#import "MWPhotoBrowser.h"
#import "GroupUserViewController.h"
#import "LDSendPersonController.h"
#import "HYListController.h"
@interface SendViewController : UIViewController<RSeriveDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MWPhotoBrowserDelegate,GroupAddressBookDelegate,HYListDelegat,LDSendPersonDelegate>
{
    int jionInt;
    RequestSerive *serive;
    UIScrollView *gScrollView;
    UITextField *field1,*field2,*LingDaoField;//LingDaoField=保存选择后的领导部门的textfield
    UITextView *nLtextView;
    UIButton *loginButton;
    NSMutableArray *_selections;
    
    UIDatePicker* timePicker;
    UIButton *openpickerButton;
    NSMutableArray *selectUser;
    NSArray *LDArr;
    
    UITextView *locationTextField;
}
@property (nonatomic, strong) NSString *RowID;
@property (nonatomic, strong) NSMutableArray *_photos;
@property (nonatomic, strong) NSMutableArray *_thumbs;
@property (nonatomic, retain)NSMutableArray *fListArray;
@property(nonatomic,strong)UIImagePickerController *imagePicker;
@property(nonatomic, retain) NSMutableDictionary* Adic;
@property (nonatomic, strong) NSString *LDHDString;//领导活动区别字段

@property(nonatomic) BOOL isChild;//其他类型进入判断，为了跳过原代码里的joinInt

@property(nonatomic) BOOL isLDHDOther;//领导活动其他形式进入，如镇级领导

@property(nonatomic) NSString *tabClass;//

@property(nonatomic) NSString *showTitle;//显示的title


@end
