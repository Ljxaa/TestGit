//
//  LeftSySViewController.m
//  同安政务
//
//  Created by _ADY on 16/1/14.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "LeftSySViewController.h"
#import "DetialsItem.h"
#import "Global.h"
#import "SearchViewController.h"
#import "PushViewController.h"
#import "SystemViewController.h"
#import "FKViewController.h"
#import "AboutViewController.h"
#import "ChangePassWordViewController.h"
#import "ListToModifyController.h"
#import "ToolCache.h"
#import "UIImageView+WebCache.h"
#import "JSONKit.h"
#import "MapViewController.h"
#define myJianJu 5

@implementation LeftSySViewController
@synthesize imagePicker;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"系统设置";
    self.view.backgroundColor = bgColor;
    // Do any additional setup after loading the view.
    listArray = [[NSArray alloc] initWithObjects:@"",@"我的发布", @"设置",@"意见反馈", @"检查更新",@"关于",@"操作说明",@"修改密码",@"注销", nil];//@"收藏", @"消息",
    imageArray = [[NSArray alloc] initWithObjects:@"",@"",@"home_sz.png",@"home_yjfk.png", @"home_jcgx.png",@"home_gy.png",@"",@"", nil];//@"home_sc.png", @"home_xx.png",
    
    
    UIImageView *bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    bgImage.frame = self.view.frame;
    [self.view addSubview:bgImage];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [myTableView setTableFooterView:v];
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    }
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    aTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    

    if (indexPath.row == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;

        UIImageView *cellImageView = [[UIImageView alloc] init];
        [cellImageView setFrame:CGRectMake(20, 5, 60, 60)];
        [cell.contentView addSubview:cellImageView];
        
        UILabel *cellTitle = [[UILabel alloc] init];
        [cellTitle setFrame:CGRectMake(cellImageView.frame.origin.x+cellImageView.frame.size.width+myJianJu, cellImageView.frame.origin.y, 200, 60)];
        cellTitle.textColor = [UIColor whiteColor];
        cellTitle.backgroundColor = [UIColor clearColor];
        cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+5];
        [cell.contentView addSubview:cellTitle];
        if ([[ToolCache userKey:kUserImage] hash] && (id)[ToolCache userKey:kUserImage] != [NSNull null])
        {
            [cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[ToolCache userKey:kUserImage]]]  placeholderImage:[UIImage imageNamed:@"tx_nan"]];
        }
        else
            [cellImageView setImage:[UIImage imageNamed:@"tx_nan"]];
        cellTitle.text = [ToolCache userKey:kDspName];
        
        return cell;
    }
    
    UILabel *cellTitle = [[UILabel alloc] init];
    [cellTitle setFrame:CGRectMake(20, 5, 240, 40)];
    cellTitle.textColor = [UIColor whiteColor];
    cellTitle.backgroundColor = [UIColor clearColor];
    cellTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:labelSize+5];
    [cell.contentView addSubview:cellTitle];

    cellTitle.text = [listArray objectAtIndex:indexPath.row];
    
    return cell;
    
}


-(void)bgbuttonType
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {//支持相册和照相
        
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        [imagePicker setAllowsEditing:YES];
        
        NSArray * tArray = [NSArray arrayWithObjects:@"拍照",@"相册",nil];
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

#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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

}

#pragma mark    imagePicker委托方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];//原图
    image = [info valueForKey:UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(image,0.2);

    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    [postDic setObject:[ToolCache userKey:kAccount] forKey:@"account"];
    
    [postDic setObject:[imageData base64Encoding] forKey:@"source"];

    [serive PostFromURL:AUploadHeadPortrait params:postDic mHttp:httpUrl isLoading:YES];
    
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

- (void)tableView:(UITableView *)table1View didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0)
//    {
//        SearchViewController *details = [[SearchViewController alloc] init];
//        details.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:details animated:YES];
//    }
//    else if (indexPath.row == 1)
//    {
////        pushView = NO;
//        PushViewController *details = [[PushViewController alloc] init];
//        details.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:details animated:YES];
//    }
    
    if (indexPath.row == 0)
    {
        [self bgbuttonType];
        return;
    }
    
    int aInt = 0;
    if (indexPath.row == 1) {
        ListToModifyController *details = [[ListToModifyController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.title = [listArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.row == 2-aInt) {
        SystemViewController *details = [[SystemViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.row ==3-aInt)
    {
        
        FKViewController *details = [[FKViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.title = [listArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.row == 4-aInt)
    {
        
        [serive GetFromURL:ACheckIOSPhone params:nil mHttp:httpUrl isLoading:YES];

    }
    else if (indexPath.row == 5-aInt)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"2" forKey:@"ParentID"];
        [serive GetFromURL:AGetDepartmentClassList params:dic mHttp:httpUrl isLoading:YES];
//        AboutViewController *details = [[AboutViewController alloc] init];
//        details.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.row == 6-aInt)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setValue:@"1" forKey:@"ParentID"];
        [serive GetFromURL:AGetDepartmentClassList params:dic mHttp:httpUrl isLoading:YES];
        
//        MapViewController *pushView = [[MapViewController alloc]init];
//        [pushView setHidesBottomBarWhenPushed:YES];
//        pushView.title = @"操作说明";
//        pushView.type = @"web";
//        pushView.url = caozuoUrl;
//        [self.navigationController pushViewController:pushView animated:YES];
    }
    else if (indexPath.row == 7-aInt)
    {
        ChangePassWordViewController *details = [[ChangePassWordViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:details animated:YES];
    }
    else if (indexPath.row == 8-aInt)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定注销登录？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.tag =1;
        [alert show];
    }

    [table1View deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    if ([urlName isEqualToString:ACheckIOSPhone])
    {
        if (dic) {
            myDictionary = dic;
            if ([[dic objectForKey:@"Version"] isEqualToString:Version])
            {
                [RequestSerive alerViewMessage:@"当前已是最新版本"];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"最新客户端 V%@",[dic objectForKey:@"Version"]] message:[dic objectForKey:@"UpdateLog"]  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新",nil];
                alert.tag =2;
                [alert show];
            }
        }
        else
            [RequestSerive alerViewMessage:@"当前已是最新版本"];
    }
    else if ([urlName isEqualToString:AUploadHeadPortrait])
    {
        if (dic != nil) {
            if ([dic[@"error"] isEqualToString:@"0"])
            {
                [RequestSerive alerViewMessage:mActionSuccess];
                [ToolCache setUserStr:dic[@"message"] forKey:kUserImage];
                [myTableView reloadData];
                return;
            }
        }
        [RequestSerive alerViewMessage:mActionFailure];
    }
    else if ([urlName isEqualToString:AGetDepartmentClassList]){//关于或操作说明
//        NSLog(@"关于 %@",dic);
        if (dic != nil) {
            NSArray *arr = (NSArray *)dic;
            NSLog(@"关于 %@",arr);
            NSDictionary *result = [arr objectAtIndex:0];
            
            MapViewController *pushView = [[MapViewController alloc]init];
            [pushView setHidesBottomBarWhenPushed:YES];
            pushView.title = [result objectForKey:@"ClassName"];
            pushView.type = @"web";
            pushView.url = [result objectForKey:@"Url"];
            [self.navigationController pushViewController:pushView animated:YES];
        }else{
            [RequestSerive alerViewMessage:@"获取失败，请检查网络连接情况。"];
        }
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
//            [self dismissViewControllerAnimated:YES completion:nil];
            UINavigationController *presentingVC = (UINavigationController *)self.presentingViewController;
            [self dismissViewControllerAnimated:NO completion:^{
                UINavigationController *nav = presentingVC.topViewController.navigationController;
                [nav popToRootViewControllerAnimated:YES];
            }];
        }
    }
    else if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[myDictionary objectForKey:@"AppURI"]]];
        }
    }
    
}

-(void)dealloc{
    [serive cancelRequest];
}

@end
