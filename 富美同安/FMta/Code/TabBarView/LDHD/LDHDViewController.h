//
//  LDHDViewController.h
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestSerive.h"
#import "CalendarViewController.h"
#import "ImgScrollView.h"
#import "TapImageView.h"
#import "FullCutModel.h"
#import "MessageReplyView.h"
#import "SingleReplyButton.h"

@interface LDHDViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,RSeriveDelegate,CalendarViewDelegat,ImgScrollViewDelegate,TapImageViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate,MessageReplyViewDelegate>
{
    int pageForNumber,pageForNumber_left,pageForNumber_right;
    RequestSerive *serive;
    int menuInt;
    UIButton *inButton;
    NSMutableArray *numHightArray,*titleHArray,*timeNowArray;
    NSMutableDictionary *aImageViewArray;
    NSString *timeString,*timeEndString;
    
    NSString *dicLDStr,*LDStr;
//    int detialInt;//详情高度
    
    int tagRow;
    NSInteger currentIndex;
    
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    
    UIImage *LongImg;//长按的图片
    BOOL noAll;
//    NSMutableArray *secondDepatment151,*secondDepatment171;
    NSMutableArray *secondDepatment;
    UIButton *downBtn;
    
    UIView *bottomCommentTfView;//评论底层视图
    UITextView *commentTf;//评论输入栏
    CGRect commentBtnFrameInWindow;//评论按钮在键盘上的位置
    UIButton *selectedCommentBtn;
    BOOL isKeyboardShowing;//是否键盘正在弹出
    float tfViewOriginY;//输入栏顶端的y坐标
    
    long goalIndexPathRow;// 所在的indexpath.row
    long needDeleteRowID;// 需要删除的RowID
    
    BOOL isArticleReply; //是否是文章创建者回复
    SingleReplyButton *SingleReplyBtn;//回复按钮
    
    BOOL isCommentEdting;//是否在编辑状态;
    
}
@property (nonatomic,strong) NSMutableArray *DeleteRowIDArr;

@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)UILabel *nameLabel;
@property (nonatomic, retain)UILabel *name1Label;
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, retain)UILabel *name2Label;
@property (nonatomic, retain)UIImageView *line1ImageView;

//@property (nonatomic, retain)UIView *no_read_iview;//未读标志

@property (nonatomic, retain) UITableView * mTableView;
@property (nonatomic, retain)  NSMutableArray *fListArray;
@property (nonatomic, retain)  NSMutableArray *ldMneuArray;
@property (nonatomic, strong) NSString *RowID;
@property (nonatomic, strong) NSString *SecondRowID;
@property (nonatomic, strong) NSString *ThirdRowID;//顶部有第三集时使用
@property(nonatomic) BOOL isChild;//其他类型进入判断，为了跳过原代码里的menuInt
@property(nonatomic) BOOL noAdd;//是否不能发布

@property(nonatomic) BOOL isOther;//判断是否是其他类型进来
@property (nonatomic, retain)  NSMutableArray *showDataList;//用来显示的数组


-(void)ReloadThe;
@end
