//
//  PushViewController.m
//  港务移动信息
//
//  Created by _ADY on 14-11-27.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import "PushViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "BDModel.h"
#import "DetialsItem.h"
#import "ToolCache.h"

@interface PushViewController ()

@end

@implementation PushViewController


-(void)returnBack
{
//    if (pushView)
//    {
//        pushView = NO;
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;

    scArray = nil;
    if ([DetialsItem unarchiveWithKey:@"DetialsPush"] != nil)
    {
        scArray = [DetialsItem unarchiveWithKey:@"DetialsPush"];
    }
    
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, screenMySize.size.height-64)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollEnabled=YES;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.sectionHeaderHeight = 8.0;
    myTableView.sectionFooterHeight = 8.0;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [myTableView setTableFooterView:v];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    scArray = nil;
    if ([DetialsItem unarchiveWithKey:@"DetialsPush"] != nil)
    {
        scArray = [DetialsItem unarchiveWithKey:@"DetialsPush"];
    }
    [myTableView reloadData];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return scArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Push";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int i = (int)[[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    NSMutableDictionary *dictionary = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)indexPath.row-1]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, screenMySize.size.width-100,20)];
    titleLabel.text = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"Title"]];
    titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize+2];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, screenMySize.size.width-100,45)];
    timeLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [cell.contentView addSubview:timeLabel];
    
    BOOL result1 = [[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"Sumnary"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if ([[dictionary allKeys] containsObject:@"Sumnary"] && !result1)
        timeLabel.attributedText = [ToolCache attributedString:[dictionary objectForKey:@"Sumnary"]];
    timeLabel.numberOfLines = 2;
    timeLabel.lineBreakMode = NSLineBreakByCharWrapping;

    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 55)];
    BOOL result = [[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"Entity"]] compare:[NSString stringWithFormat:@"<null>"]] == NSOrderedSame;
    if (![[dictionary objectForKey:@"Entity"] isEqual:@""] && !result)
        [bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[dictionary objectForKey:@"Entity"]]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];
    bgImageView.contentMode =  UIViewContentModeScaleAspectFill;
    bgImageView.clipsToBounds  = YES;
    [cell.contentView addSubview:bgImageView];
    
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [lineImageView setFrame:CGRectMake(10, 68, screenMySize.size.width-20, 2)];
    [cell.contentView addSubview:lineImageView];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *pushArray = [[NSMutableDictionary alloc]init];
    if ([DetialsItem unarchiveWithKey:@"DetialsPush"] != nil)
    {
        pushArray = [DetialsItem unarchiveWithKey:@"DetialsPush"];
    }
    for (int i = 0; i < pushArray.count; i++)
    {
        if ([[[pushArray objectForKey:[NSString stringWithFormat:@"%d",i]] objectForKey:@"Title"] isEqualToString:[[scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]] objectForKey:@"Title"]])
        {
            for (int j = i; j< pushArray.count-1; j++)
            {
                [pushArray setObject:[pushArray objectForKey:[NSString stringWithFormat:@"%d",j+1]] forKey:[NSString stringWithFormat:@"%d",j]];
            }
            [pushArray removeObjectForKey:[NSString stringWithFormat:@"%d",(int)pushArray.count-1]];
            [pushArray archiveWithKey:@"DetialsPush"];
        }
    }//去除已查看消息
    
    
    
    if ([[[scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]] objectForKey:@"IsImage"] isEqualToString:[NSString stringWithFormat:@"0"]])
    {
        NSMutableDictionary *dictionary = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]];
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        MWPhoto *photo;
        BOOL enableGrid = YES;
        BOOL startOnGrid = NO;
        
        NSArray *controlsEnd = [[dictionary objectForKey:@"Author"] componentsSeparatedByString:@"||"];
        NSArray *controlsEnd1 = [[dictionary objectForKey:@"ClassId"] componentsSeparatedByString:@"||"];
        for (int j = 0; j <controlsEnd.count; j ++)
        {
            photo = [MWPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,[controlsEnd objectAtIndex:j]]]];
            
            [thumbs addObject:photo];
            photo.caption =[controlsEnd1 objectAtIndex:j];
            [photos addObject:photo];
        }
        
        
        self.photos = photos;
        self.thumbs = thumbs;
        
        // Create browser
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = YES;//分享按钮,默认是
        browser.displayNavArrows = YES;//左右分页切换,默认否
        browser.displaySelectionButtons = NO;//是否显示选择按钮在图片上,默认否
        browser.alwaysShowControls = NO;//控制条件控件 是否显示,默认否
        browser.zoomPhotosToFill = YES;//是否全屏,默认是
        [browser setDion:dictionary];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        browser.wantsFullScreenLayout = YES;
#endif
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = YES;
        [browser setCurrentPhotoIndex:0];
        
        // Reset selections
        if (photos.count>0) {
            _selections = [NSMutableArray new];
            for (int i = 0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
        }
        [self.navigationController pushViewController:browser animated:YES];
        
        
    }
    else
    {
        DetialsViewController *details = [[DetialsViewController alloc] init];
        details.hidesBottomBarWhenPushed = YES;
        details.dic = [scArray objectForKey:[NSString stringWithFormat:@"%d",(int)scArray.count-(int)newIndexPath.row-1]];
        [self.navigationController pushViewController:details animated:YES];
    }
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
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

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    //    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    //    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

