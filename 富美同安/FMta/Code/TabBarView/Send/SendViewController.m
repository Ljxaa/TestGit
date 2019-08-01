//
//  SendViewController.m
//  同安政务
//
//  Created by _ADY on 15/12/24.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import "SendViewController.h"
#import "Global.h"
#import "ToolCache.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"

@implementation SendViewController
@synthesize fListArray,imagePicker,_photos,_thumbs,RowID,Adic,isChild,isLDHDOther,LDHDString,tabClass;
#define fieldHeight 40
#define jiangeH 10
#define imageSize1 (screenMySize.size.width-20)/3-10
#define kSendplist @"userSendImage.plist"
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    jionInt = -1;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(sendAction)];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    gScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 10, screenMySize.size.width-10, screenMySize.size.height-64-49)];
    [gScrollView setPagingEnabled:NO];
    [gScrollView.layer setCornerRadius:5];
    [gScrollView setBackgroundColor:[UIColor whiteColor]];
    [gScrollView setShowsHorizontalScrollIndicator:NO];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    [remData removeAllObjects];
    [remData writeToFile:filename atomically:YES];
    
    [self performSelector:@selector(after) withObject:nil afterDelay:.1];
}

-(void)after
{
    [self.view addSubview:gScrollView];
    
    if (!isChild) {
        if ([self.title isEqualToString:@"请假出差报告"]&&[RowID isEqualToString:wfSubCodeDic[@"区级领导活动"]]) {
            jionInt = 0;
        }else{
            for (int i = 0; i < menuLDArray.count; i ++) {
                if ([self.title isEqualToString:[menuLDArray objectAtIndex:i]])
                {
                    jionInt = i;
                    break;
                }
            }
        }
    }else{
        jionInt = 100;
    }
    
    if (self.showTitle != nil) {
        self.title = self.showTitle;
    }
    
    field1=[[UITextField alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-30, fieldHeight)];
    [field1.layer setBorderWidth:1];
    [field1.layer setBorderColor:[UIColor grayColor].CGColor];
    [field1.layer setCornerRadius:5];
    [field1 setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
    field1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field1 setBackgroundColor:[UIColor whiteColor]];
    [field1 setAutocorrectionType:UITextAutocorrectionTypeNo];
    [field1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [gScrollView addSubview:field1];
    [field1 setPlaceholder:mkTitle];
    
    int Hight = 0;
    if (jionInt == 0&&!isLDHDOther) {//领导活动,添加选择部门
        Hight = fieldHeight+ jiangeH;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(field1.frame.origin.x,field1.frame.origin.y+Hight, field1.frame.size.width, fieldHeight)];
        [view1.layer setBorderWidth:1];
        [view1.layer setBorderColor:[UIColor grayColor].CGColor];
        [view1.layer setCornerRadius:5];
        [gScrollView addSubview:view1];

        int titleLableH = [ToolCache setString:@"相关部门:" setSize:labelSize setHight:fieldHeight];
        
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, titleLableH, view1.frame.size.height)];
        tLabel.textColor = [UIColor blackColor];
        tLabel.textAlignment = 0;
        tLabel.text = @"相关部门:";
        [tLabel setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        [view1 addSubview:tLabel];
        
        
        LingDaoField =[[UITextField alloc]initWithFrame:CGRectMake(tLabel.frame.origin.x+5+tLabel.frame.size.width,0, field1.frame.size.width-10-tLabel.frame.size.width, view1.frame.size.height)];
        [LingDaoField setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        LingDaoField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [LingDaoField setBackgroundColor:[UIColor clearColor]];
        [LingDaoField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [LingDaoField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [view1 addSubview:LingDaoField];
        
        UIButton *in1Button = [UIButton buttonWithType:UIButtonTypeCustom];
        [in1Button setFrame:view1.frame];
        in1Button.tag = 9999;
        [in1Button addTarget:self action:@selector(aInAction:) forControlEvents:UIControlEventTouchUpInside];
        [gScrollView addSubview:in1Button];
        [LingDaoField setPlaceholder:mkUnit];
    }
//    @"领导活动", @"会议管理",@"征拆动态",@"部门动态",@"城管执法",@"工业社区",@"重点工程",@"流域治理",@"协税护税"
//    if (jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 3 || jionInt == 26||jionInt == 4)
    if ((jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9||jionInt == 11||jionInt == 16 || jionInt == 28 || jionInt == 32)&&!isLDHDOther)
    {
        Hight += fieldHeight+ jiangeH;
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(field1.frame.origin.x,field1.frame.origin.y+Hight, field1.frame.size.width, fieldHeight)];
        [view1.layer setBorderWidth:1];
        [view1.layer setBorderColor:[UIColor grayColor].CGColor];
        [view1.layer setCornerRadius:5];
        [gScrollView addSubview:view1];
        NSArray *mArray = [NSArray arrayWithObjects:@"相关领导:",@"会议时间:",@"项目:",@"项目:",@"单位:",@"",@"单位:",@"单位:",@"单位:",@"单位:",@"项目:",@"项目:",@"",@"",@"",@"",@"单位",@"项目", nil];
        NSString *labelStr;
        if (jionInt == 22) {
            labelStr = @"项目:";
        }else if (jionInt == 27) {
            labelStr = @"项目:";
        }else if (jionInt == 28) {
            labelStr = @"承接单位:";
        }else if(jionInt == 32){
            labelStr = @"单位:";
        }else{
            labelStr = [mArray objectAtIndex:jionInt];
        }
        int titleLableH = [ToolCache setString:labelStr setSize:labelSize setHight:fieldHeight];
        
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0, titleLableH, view1.frame.size.height)];
        tLabel.textColor = [UIColor blackColor];
        tLabel.textAlignment = 0;
        tLabel.text = labelStr;
        [tLabel setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        [view1 addSubview:tLabel];
        
        
        field2 =[[UITextField alloc]initWithFrame:CGRectMake(tLabel.frame.origin.x+5+tLabel.frame.size.width,0, field1.frame.size.width-10-tLabel.frame.size.width, view1.frame.size.height)];
        [field2 setFont:[UIFont fontWithName:@"Arial" size:labelSize]];
        field2.clearButtonMode = UITextFieldViewModeWhileEditing;
        [field2 setBackgroundColor:[UIColor clearColor]];
        [field2 setAutocorrectionType:UITextAutocorrectionTypeNo];
        [field2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [view1 addSubview:field2];
        
        if (jionInt != 28) {
            UIButton *in1Button = [UIButton buttonWithType:UIButtonTypeCustom];
            [in1Button setFrame:view1.frame];
            in1Button.tag = jionInt+10000;
            [in1Button addTarget:self action:@selector(aInAction:) forControlEvents:UIControlEventTouchUpInside];
            [gScrollView addSubview:in1Button];
        }
        
        if (jionInt == 0)
        {
             [field2 setPlaceholder:mkLeaders];
             selectUser = [[NSMutableArray alloc] init];
        }
        else if (jionInt == 1) {
            [field2 setPlaceholder:mkDays];
        }
        else if (jionInt == 2|| jionInt == 17)
        {
            [field2 setPlaceholder:mkProject];
        }
        else if (jionInt == 3 || jionInt == 26||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22||jionInt == 9||jionInt == 11)
        {
            [field2 setPlaceholder:mkUnit];
        }
        else if (jionInt == 16 || jionInt == 32)
        {
            [field2 setPlaceholder:@"请选择单位"];
        }
        else if (jionInt == 22)
        {
            [field2 setPlaceholder:@"请选择项目"];
        }else if (jionInt == 28)
        {
            [field2 setPlaceholder:@"请输入承接单位"];
        }
    }
    
    nLtextView = [[UITextView alloc] initWithFrame:CGRectMake(field1.frame.origin.x,field1.frame.origin.y+jiangeH+fieldHeight+Hight, field1.frame.size.width, fieldHeight*3)] ;
    nLtextView.backgroundColor = [UIColor whiteColor];
    nLtextView.textColor = [UIColor grayColor];
    [nLtextView.layer setBorderWidth:1];
    [nLtextView.layer setBorderColor:[UIColor grayColor].CGColor];
    [nLtextView.layer setCornerRadius:5];
    [nLtextView setFont:[UIFont systemFontOfSize:labelSize]];
    nLtextView.returnKeyType = UIReturnKeyDone;
    nLtextView.text = mkContent;
    nLtextView.delegate = self;
    nLtextView.editable = YES;
    nLtextView.scrollEnabled = YES;
    [gScrollView addSubview:nLtextView];
    
    UIImage *loginImage = [UIImage imageNamed:@"add"];
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [loginButton setFrame:CGRectMake(10, jiangeH+fieldHeight+Hight+jiangeH*2+nLtextView.frame.size.height, imageSize1,imageSize1)];
    [loginButton setFrame:CGRectMake(10, CGRectGetMaxY(nLtextView.frame)+10, imageSize1,imageSize1)];
    [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(bgbuttonType) forControlEvents:UIControlEventTouchUpInside];
    [gScrollView addSubview:loginButton];
    
    if (Adic)
    {
        field1.text = Adic[@"Title"];
        nLtextView.text = Adic[@"AuthorName"];
        NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:Adic[@"Content"]];
        [self HYAction:imageUrlArray];
    }
    [self gScrollViewHight];
}

-(void)gScrollViewHight
{
    if (screenMySize.size.height > loginButton.frame.size.height+loginButton.frame.origin.y+10+64)
    {
        [gScrollView setFrame:CGRectMake(5, 10, screenMySize.size.width-10, loginButton.frame.size.height+loginButton.frame.origin.y+10)];
    }
    else
    {
        [gScrollView setContentSize:CGSizeMake(screenMySize.size.width-10,loginButton.frame.size.height+loginButton.frame.origin.y+10)];
    }
}
-(void)setAddImage
{
    int Hight = 0;
    if (jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9||jionInt == 11||jionInt == 16 || jionInt == 32)
    {
        Hight = fieldHeight+ jiangeH;
    }
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    if (remData.count >= 9) {
        loginButton.alpha = 0;
    }
    else
    {
        loginButton.alpha = 1;
    }
//    [loginButton setFrame:CGRectMake(10+remData.count%3*(imageSize1+10), jiangeH+fieldHeight+Hight+jiangeH*2+nLtextView.frame.size.height+remData.count/3*(imageSize1+10), imageSize1,imageSize1)];
    [loginButton setFrame:CGRectMake(10+remData.count%3*(imageSize1+10), CGRectGetMaxY(nLtextView.frame)+10+remData.count/3*(imageSize1+10), imageSize1,imageSize1)];
    
    [self gScrollViewHight];
    
    for (int i = 0 ; i < remData.count; i++)
    {

//        CGRect frame = CGRectMake(10+(imageSize1+10)*(i%3), jiangeH+fieldHeight+Hight+jiangeH*2+nLtextView.frame.size.height+i/3*(imageSize1+10), imageSize1,  imageSize1);
        CGRect frame = CGRectMake(10+(imageSize1+10)*(i%3), CGRectGetMaxY(nLtextView.frame)+10+i/3*(imageSize1+10), imageSize1,  imageSize1);
        UIImageView *imageView = (UIImageView*)[self.view viewWithTag:20000+i];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithFrame:frame];
            [gScrollView addSubview:imageView];
        }
        
        UIButton *in1Button = (UIButton*)[self.view viewWithTag:1000+i];
        if (in1Button == nil)
        {
            in1Button = [UIButton buttonWithType:UIButtonTypeCustom];
            [gScrollView addSubview:in1Button];
        }
        [in1Button setFrame:frame];

        NSString *str = [NSString stringWithFormat:@"%@",[remData objectForKey:[NSString stringWithFormat:@"%d",i]]];
        if ([self isBoolHttp:str])
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:str]];
        }
        else
            [imageView setImage:[UIImage imageWithData:[remData objectForKey:[NSString stringWithFormat:@"%d",i]]]];
        imageView.tag = 20000+i;
        in1Button.tag = 1000+i;
        [in1Button addTarget:self action:@selector(iMageAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

#pragma mark 图片按钮
-(void)iMageAction:(UIButton*)amTag
{
    UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"删除图片", @"查看图片",nil];
    photoSheet.tag = amTag.tag;
    photoSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [photoSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark 选人返回显示事件
- (void)doneSelect:(NSMutableArray *)userSet
{
    selectUser = userSet;
    NSString *aNameString = nil;
    for (NSMutableDictionary *d in userSet)
    {
        //        NSString *user = d[@"GPLD_User"];
        
        if (aNameString.length == 0) {
            aNameString = [NSString stringWithFormat:@"%@",d[@"userName"][@"text"]];
        }
        else
        {
            aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,d[@"userName"][@"text"]];
            
        }
    }
    
    field2.text = aNameString;
}
- (void)doneSelection:(NSMutableArray *)userSet
{
    selectUser = userSet;
    NSString *aNameString = nil;
    for (NSMutableDictionary *d in userSet)
    {
//        NSString *user = d[@"GPLD_User"];

        if (aNameString.length == 0) {
            aNameString = [NSString stringWithFormat:@"%@",d[@"GPLD_UserDspName"]];
        }
        else
        {
            aNameString = [NSString stringWithFormat:@"%@,%@",aNameString,d[@"GPLD_UserDspName"]];
            
        }
    }
    
    field2.text = aNameString;
}

-(void)leader
{
    
    LDSendPersonController *vc = [[LDSendPersonController alloc] initWithNibName:nil bundle:nil];
    vc.deptName = LingDaoField.text;
    vc.delegate = self;
    vc.mSelectionUsers =selectUser;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
//    GroupUserViewController *vc = [[GroupUserViewController alloc] initWithNibName:nil bundle:nil];
//    vc.groupBy = 2;
//    vc.delegate = self;
//    vc.mSelectionUsers =selectUser;
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
#pragma mark  选择按钮
-(void)aInAction:(UIButton*)amTag
{
    if (amTag.tag == 1+10000)
    {
        
        [self pickerView];//时间选择
    }
    else if (amTag.tag == 10000)
    {
        if (jionInt == 0) {
            if (LingDaoField.text.length == 0) {
                [RequestSerive alerViewMessage:mkDept];
                return;
            }
        }
        [self leader];//领导选择
    }
    else if (amTag.tag == 9999)
    {
        NSLog(@"领导活动选择部门");
        if (fListArray.count == 0) {
            fListArray = [[NSMutableArray alloc] init];
            [serive GetFromURL:AOAGetDept params:nil mHttp:httpUrl isLoading:NO];
        }
        else
        {
            [self setZengCaiList];
        }
    }
    else if (amTag.tag == 10000+2)
    {
        if (fListArray.count == 0) {
            fListArray = [[NSMutableArray alloc] init];
            [serive PostFromURL:AGetZengCaiList params:nil mHttp:httpUrl isLoading:YES];
        }
        else
        {
            [self setZengCaiList];
        }
        
    }
    else if (amTag.tag == 10000+3||amTag.tag == 10000+4||amTag.tag == 10000+6||amTag.tag == 10000+27||amTag.tag == 10000+7||amTag.tag == 10000+8||amTag.tag == 10000+9||amTag.tag == 10000+11||amTag.tag == 10000+16||amTag.tag == 10000+17||amTag.tag == 10000+22||amTag.tag == 10000+32)
    {
        if (fListArray.count == 0) {
            fListArray = [[NSMutableArray alloc] init];
            NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
            [postDicc setObject:[wfSubCodeLDArray objectAtIndex:amTag.tag-10000]  forKey:@"ParentID"];
            [serive PostFromURL:AGetDepartmentClassList params:postDicc mHttp:httpUrl isLoading:YES];
        }
        else
        {
            [self setZengCaiList];
        }
        
    }
}

-(void)setZengCaiList
{
    /**
     UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
     NSArray *controls = [dicLDStr componentsSeparatedByString:@","];
     [actionSheet addButtonWithTitle:@"全部"];
     for (int i = 0; i < controls.count; i ++)
     {
     [actionSheet addButtonWithTitle:[controls objectAtIndex:i]];
     }
     actionSheet.tag = 100;
     //    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
     [actionSheet showInView:self.view];
     */
    UIActionSheet *actionSheet;
    if (jionInt == 0||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择单位" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择项目" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    }
//    [actionSheet addButtonWithTitle:@"全部"];
    if (jionInt == 0) {
        for (int i = 0; i < LDArr.count; i ++)
        {
            [actionSheet addButtonWithTitle:[LDArr objectAtIndex:i]];
        }
        actionSheet.tag = 101;
    }else{
        for (NSDictionary *adic in fListArray)
        {
            [actionSheet addButtonWithTitle:adic[@"ClassName"]];
        }
        actionSheet.tag = 100;
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.tabBarController.view];
}

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0&&actionSheet.tag <1000) {
        return;
    }
    
    if (actionSheet.tag == 100)//项目选择
    {
        if (buttonIndex-1 >  fListArray.count ||buttonIndex < 0)
        {
            return;
        }
//        if (buttonIndex == 0) {
//            RowID = [wfSubCodeLDArray objectAtIndex:jionInt];
//            field2.text = [actionSheet buttonTitleAtIndex:buttonIndex];
//        }
//        else
        {
            RowID = fListArray[buttonIndex-1][@"RowID"];
            field2.text = fListArray[buttonIndex-1][@"ClassName"];
        }
    }
    else if (actionSheet.tag == 101)//领导活动选择部门
    {
        if (buttonIndex-1 >  LDArr.count ||buttonIndex < 0)
        {
            return;
        }
        LingDaoField.text = LDArr[buttonIndex-1];
    }
    else if (actionSheet.tag >= 1000)
    {
        if (buttonIndex == 0)//删除图片
        {
            [self deleteImage:(int)actionSheet.tag-1000];
        }
        else if (buttonIndex == 1)//查看图片
        {
            [self seeImage:(int)actionSheet.tag-1000];
        }else{
            return;
        }
    }
    else
    {
        if (buttonIndex == 1)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if(buttonIndex == 2)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else if (buttonIndex == 3)//查看会议
        {
            HYListController *vc = [[HYListController alloc] init];
            vc.title = @"会议管理";
            vc.hidesBottomBarWhenPushed = YES;
            vc.RowID = RowID;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark 发送
-(void)sendAction
{
    if (field1.text.length == 0)
    {
        [RequestSerive alerViewMessage:mkTitle];
        return;
    }
//    if (jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 3 || jionInt == 26||jionInt == 4)
    if ((jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9||jionInt == 11||jionInt == 16 || jionInt == 32)&&!isLDHDOther)
    {
        
        if (field2.text.length == 0)
        {
            if (jionInt == 0)
            {
                [RequestSerive alerViewMessage:mkLeaders];
            }
            else if (jionInt == 1) {
                [RequestSerive alerViewMessage:mkDays];
            }
            else if (jionInt == 2||jionInt == 11)
            {
                [RequestSerive alerViewMessage:mkProject];
            }
            else if (jionInt == 3 || jionInt == 26||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9)
            {
                [RequestSerive alerViewMessage:mkUnit];
            }
            else if (jionInt == 16 || jionInt == 32){
                [RequestSerive alerViewMessage:@"请选择单位"];
            }
            return;
        }
    }
    
    if (jionInt == 28 && field2.text.length == 0) {
        [RequestSerive alerViewMessage:@"请输入承接单位"];
    }
//    if (nLtextView.text.length == 0 || [nLtextView.text isEqualToString:mkContent])
//    {
//        [RequestSerive alerViewMessage:mkContent];
//        return;
//    }

    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    if (LDHDString != nil) {
        [postDic setObject:LDHDString forKey:@"TabClass"];
    }
    if (jionInt == 4) {//城管执法添加gps
        [postDic setObject:@"aaa" forKey:@"Title"];
    }
    [postDic setObject:field1.text forKey:@"Title"];
    [postDic setObject:@"" forKey:@"Location"];
    if (jionInt == 0&&!isLDHDOther){
        [postDic setObject:field2.text forKey:@"LocationGPS"];
    }
    else{
        [postDic setObject:@"" forKey:@"LocationGPS"];
    }
    [postDic setObject:@"" forKey:@"PubDateTime"];
    [postDic setObject:@"" forKey:@"Author"];
    if (jionInt == 1) {
      [postDic setObject:field2.text forKey:@"AuthorCompany"];
    }
    else if (jionInt == 28){
        [postDic setObject:field2.text forKey:@"Location"];
    }
    else
        [postDic setObject:@"" forKey:@"AuthorCompany"];//会议时间
    [postDic setObject:[ToolCache userKey:kDspName] forKey:@"OAUserID"];
    if (nLtextView.text.length == 0 || [nLtextView.text isEqualToString:mkContent])
         [postDic setObject:@"" forKey:@"AuthorName"];
    else
        [postDic setObject:nLtextView.text forKey:@"AuthorName"];
    [postDic setObject:[ToolCache userKey:kAccount] forKey:@"IMEINO"];
    NSLog(@"AdicAdic::%@",Adic);
    
    
    if (jionInt == 3 || jionInt == 26 || jionInt == 29||jionInt == 30||jionInt == 33||jionInt == 34) {
        [postDic setObject:@"0" forKey:@"ClassId"];
    }else if(jionInt == 7||jionInt == 8){
//        [postDic setObject:[wfSubCodeLDArray objectAtIndex:jionInt] forKey:@"ClassId"];
        [postDic setObject:self.RowID forKey:@"ClassId"];
    }else if([self.title isEqualToString:@"外出报告"]){
        [postDic setObject:@"0" forKey:@"ClassId"];
    }else{
        [postDic setObject:RowID forKey:@"ClassId"];
    }
    
    //不需要选择类别的，不传classid
    if (!((jionInt == 0||jionInt == 1||jionInt == 2||jionInt == 4||jionInt == 6 ||jionInt == 27 || jionInt == 22|| jionInt == 17||jionInt == 9||jionInt == 11||jionInt == 16)&&!isLDHDOther) && Adic){
//        [postDic removeObjectForKey:@"ClassId"];
        [postDic setObject:Adic[@"ClassId"] forKey:@"ClassId"];
    }

    if (jionInt == 26) {//安全生产添加tabclass
        [postDic setObject:@"aqsc" forKey:@"TabClass"];
    }else if (jionInt == 28){
        [postDic setObject:tabClass forKey:@"TabClass"];
    }else if (jionInt == 29){
        [postDic setObject:@"xin" forKey:@"TabClass"];
    }else if (jionInt == 30){
        [postDic setObject:@"msbd" forKey:@"TabClass"];
    }else if(jionInt == 31){
        [postDic setObject:@"zhong" forKey:@"TabClass"];
    }else if(jionInt == 33){
        [postDic setObject:@"stone" forKey:@"TabClass"];
    }else if(jionInt == 34){
        [postDic setObject:@"briefing" forKey:@"TabClass"];
    }
    
    NSDictionary *dic = @{@"controller":@"dsadsa",@"ispublish":@"yes",@"publishDic":@{@"TabClass":@"msbd",@"ClassId":@"0"}};
    if (Adic)
        [postDic setObject:Adic[@"RowID"] forKey:@"RowID"];
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    NSString *temStr = @"";
//    NSLog(@"remData:====%@",remData);
    for (int i = 0 ; i < remData.count; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%@",[remData objectForKey:[NSString stringWithFormat:@"%d",i]]];
        if ([self isBoolHttp:str])
        {
            if (temStr.length == 0) {
                temStr =  str;
            }
            else
                temStr = [NSString stringWithFormat:@"%@,%@",temStr,str];
                
        }
        else
        {
            NSMutableDictionary* mailInfoDic = [[NSMutableDictionary alloc] init];
            NSString *encodingStr = [[remData objectForKey:[NSString stringWithFormat:@"%d",i]] base64Encoding];
            [mailInfoDic setObject:encodingStr forKey:@"Pic"];
            [mailInfoDic setObject:@"" forKey:@"PicRemark"];
            [myArray addObject:mailInfoDic];
        }
    }
    if(remData.count == 0)
    {
        NSMutableDictionary* mailInfoDic = [[NSMutableDictionary alloc] init];
        [mailInfoDic setObject:@"" forKey:@"Pic"];
        [mailInfoDic setObject:@"" forKey:@"PicRemark"];
        [myArray addObject:mailInfoDic];
    }
    [postDic setObject:myArray forKey:@"PicsContent"];
  
    [postDic setObject:temStr forKey:@"ConfPics"];
    
    NSMutableDictionary *postDicc = [NSMutableDictionary dictionary];
    
    [postDicc setObject:postDic.JSONString  forKey:@"source"];
    
    NSLog(@"postDiccpostDicc:%@",postDic);
//    return;
    if (Adic) {
        [serive PostFromURL:ACheckPerPhoto params:postDicc mHttp:httpUrl isLoading:YES];
    }
    else
        [serive PostFromURL:AUploadPhotoData params:postDicc mHttp:httpUrl isLoading:YES];
}

-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:AGetZengCaiList]||[urlName isEqualToString:AGetDepartmentClassList])//获取项目
    {
        if (dic != nil) {
            for (NSDictionary *a in dic) {
                [fListArray addObject:a];
            }
            [self setZengCaiList];
        }
    }
    else if ([urlName isEqualToString:AOAGetDept])// 获取部门
    {
        if (dic != nil) {
            LDArr = nil;
            
            LDArr = [dic[@"NewDataSet"][@"Table"][@"msg"][@"text"] componentsSeparatedByString:@","];
            
            [self setZengCaiList];
            
        }
    }
    else if ([urlName isEqualToString:AUploadPhotoData]||[urlName isEqualToString:ACheckPerPhoto])//发送
    {
        if (dic != nil) {
            if ([[dic objectForKey:@"error"] isEqualToString:@"0"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:KsendSuccess object:self];
                [RequestSerive alerViewMessage:mActionSuccess];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        [RequestSerive alerViewMessage:mActionFailure];
    }
    
}

-(void)bgbuttonType
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {//支持相册和照相
    
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:YES];
        
        NSArray *tArray = nil;
        if (jionInt == 0) {
            tArray = [NSArray arrayWithObjects:@"拍照",@"相册",@"会议", nil];
        }
        else
           tArray = [NSArray arrayWithObjects:@"拍照",@"相册",nil];
        UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:@"请选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString *adic in tArray)
        {
            [photoSheet addButtonWithTitle:adic];
        }
        
        photoSheet.actionSheetStyle=UIActionSheetStyleDefault;
        [photoSheet showInView:[UIApplication sharedApplication].keyWindow];
        
    }
    else if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:YES];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // The user canceled -- simply dismiss the image picker.
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark    imagePicker委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];//原图
//    image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image,0.2);
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if (remData == nil) {
        NSMutableDictionary *remData1 = [[NSMutableDictionary alloc] init];
        [remData1 setObject:imageData forKey:@"0"];
        [remData1 writeToFile:filename  atomically:YES];
        [remData1 removeAllObjects];
    }
    else
    {
        
        [remData setObject:imageData forKey:[NSString stringWithFormat:@"%ld",(unsigned long)remData.count]];
        [remData writeToFile:filename  atomically:YES];
    }
    [self setAddImage];
}

//改变图片大小
- (UIImage *)image:(UIImage *)image centerInSize:(CGSize)viewsize
{
    UIGraphicsBeginImageContext(CGSizeMake(viewsize.width, viewsize.height));
    [image drawInRect:CGRectMake(0, 0, viewsize.width, viewsize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}

#pragma mark 删除图片
-(void)deleteImage:(int)type
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    
    UIButton *in1Button = (UIButton*)[self.view viewWithTag:1000+(int)remData.count-1];
    [in1Button removeFromSuperview];
    in1Button = nil;
    
    UIImageView *imageView = (UIImageView*)[self.view viewWithTag:20000+(int)remData.count-1];
    [imageView removeFromSuperview];
    imageView = nil;
    
    for (int i = 0; i < remData.count; i ++)
    {
        if (i > type)
        {
            [remData setValue:[remData objectForKey:[NSString stringWithFormat:@"%d",i]] forKey:[NSString stringWithFormat:@"%d",i-1]];
        }
    }
    [remData removeObjectForKey:[NSString stringWithFormat:@"%d",(int)remData.count-1]];
    [remData writeToFile:filename  atomically:YES];
    [self setAddImage];
}
#pragma mark 查看图片
-(void)seeImage:(int)type
{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    for (int i = 0; i < remData.count; i ++)
    {
        NSString *str = [NSString stringWithFormat:@"%@",[remData objectForKey:[NSString stringWithFormat:@"%d",i]]];
        if ([self isBoolHttp:str])
        {
              photo = [MWPhoto photoWithURL:[NSURL URLWithString:str]];
        }
        else
            photo = [MWPhoto photoWithImage:[UIImage imageWithData:[remData objectForKey:[NSString stringWithFormat:@"%d",i]]]];
        [thumbs addObject:photo];
        photo.caption =nil;
        [photos addObject:photo];
        
    }
    
    self._photos = photos;
    self._thumbs = thumbs;
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;//分享按钮,默认是
    browser.displayNavArrows = YES;//左右分页切换,默认否
    browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:type];
    
    // Reset selections
    if (photos.count>0) {
        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }
    }
    [self.navigationController pushViewController:browser animated:YES];

}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    //    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {

    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textview delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    if (range.location < 500)
    {
        return YES;
    }
    else
        textView.text = [textView.text substringToIndex:[textView.text length] - 1];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    if ([textView.text  isEqualToString:mkContent] ) {
        textView.text = @"";
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.text = mkContent;
    }
    
    [textView resignFirstResponder];
    return YES;
}

-(void)pickerView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (openpickerButton != nil)
    {
        [openpickerButton removeFromSuperview];
        openpickerButton = nil;
    }
    openpickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openpickerButton setFrame:CGRectMake(0, screenMySize.size.height, screenMySize.size.width, screenMySize.size.height)];
    [openpickerButton addTarget:self action:@selector(calcelAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:openpickerButton];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenMySize.size.height-180-44, screenMySize.size.width, 44)];
    toolBar.tintColor = [UIColor grayColor];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureAction:)];
    UIBarButtonItem* placeHolderButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    placeHolderButton.title = @"请选择时间";
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(calcelAction)];
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, placeHolderButton, doneButton, nil]];
    [openpickerButton addSubview:toolBar];
    
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenMySize.size.height-180, screenMySize.size.width, 180)];
//   timePicker.datePickerMode = UIDatePickerModeDate;//24小时制
    timePicker.backgroundColor = [UIColor grayColor];
//    timePicker.maximumDate = [NSDate new];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSLocale* local = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [timePicker setLocale:local];
    [timePicker addTarget:self action:@selector(changes:)forControlEvents:UIControlEventValueChanged];
    [openpickerButton addSubview:timePicker];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        openpickerButton.frame = CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height);
    }];
}

-(void)changes:(id)sender
{
    //    [self setTime];
}

-(void)calcelAction
{
    [UIView animateWithDuration:0.5 animations:^{
        openpickerButton.frame = CGRectMake(0, screenMySize.size.height, screenMySize.size.width, screenMySize.size.height);
    }];
    [self performSelector:@selector(afterClose) withObject:self afterDelay:0.5];
}

-(void)afterClose
{
    if (openpickerButton != nil)
    {
        [openpickerButton removeFromSuperview];
        openpickerButton = nil;
    }
}

-(void)sureAction:(id)sender
{
    [self setTime];
    [self calcelAction];
}

-(void)setTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dayString = [dateFormatter stringFromDate:[timePicker date]];
    field2.text = dayString;
}
#pragma mark 回调
-(void)HYAction:(NSMutableArray*)aTag
{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths  objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:kSendplist];
    for (NSDictionary *dic1 in aTag) {
        NSMutableDictionary *remData= [NSMutableDictionary dictionaryWithContentsOfFile:filename];
        
        NSString *urlString = [NSString stringWithFormat:@"%@",dic1];
        if (remData == nil) {
            NSMutableDictionary *remData1 = [[NSMutableDictionary alloc] init];
            
            [remData1 setObject:urlString forKey:@"0"];
            [remData1 writeToFile:filename  atomically:YES];
            [remData1 removeAllObjects];
        }
        else
        {
            [remData setObject:urlString forKey:[NSString stringWithFormat:@"%ld",(unsigned long)remData.count]];
            [remData writeToFile:filename  atomically:YES];
        }
    }

    [self setAddImage];

}

#pragma mark 图片来源判断
-(BOOL)isBoolHttp:(NSString*)tempStr
{
    NSRange range = [tempStr rangeOfString:@"http"];
    if (range.length >0)//包含
    {
        return YES;
    }
    else//不包含
    {
        return NO;
    }
}

//滚动或者触摸隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

@end
