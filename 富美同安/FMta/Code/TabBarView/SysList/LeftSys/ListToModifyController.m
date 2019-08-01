//
//  ListToModifyController.m
//  同安政务
//
//  Created by _ADY on 16/1/29.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "ListToModifyController.h"
#import "Global.h"
#import "MJRefresh.h"
#import "ToolCache.h"
#import "DetialsViewController.h"
#import "SendViewController.h"
#import "FullCutModel.h"
#import "FullCutTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ListToModifyController
@synthesize mTableView,fListArray;
#define sizeHight screenMySize.size.width*.2
#define aTimeHight 20
#define oneLine 1//1=一行图片 其他为三行
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;

    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenMySize.size.width, self.view.frame.size.height-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];//清除多余分割线
    [mTableView setTableFooterView:v];
    
    scrollPanel = [[UIView alloc] initWithFrame:screenMySize];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:screenMySize];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    serive=[[RequestSerive alloc]init];
    [serive setDelegate:self];
    
    __weak __typeof(self) weakSelf = self;
    
    mTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    mTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];

    [mTableView.header beginRefreshing];
    
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeader) name:KsendSuccess object:nil];

}


-(void)dealloc{
    [serive cancelRequest];
}
#pragma mark - 请求代理
-(void)responseData:(NSDictionary *)dic mUrl:(NSString *)urlName{
    
    if ([urlName isEqualToString:AGetMyPerPhotosList])
    {
        NSLog(@"我的发布：：%@",dic);
        if (dic != nil) {
            [fListArray addObjectsFromArray:dic[@"DataList"]];
            TotalCount = [dic[@"TotalCount"] intValue];
        }
        
        [mTableView reloadData];
        [mTableView.header endRefreshing];
        [mTableView.footer endRefreshing];
    }
    if ([urlName isEqualToString:ADeletePerPhotosByRowID])
    {
        if (dic != nil)
        {
            if ([dic[@"error"] isEqualToString:@"0"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [fListArray removeObjectAtIndex:howInt];
                    [numHightArray removeObjectAtIndex:howInt];
                    [titleHArray removeObjectAtIndex:howInt];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:howInt inSection:0];
                        [mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        [mTableView reloadData];
                    });
                });
                [RequestSerive alerViewMessage:mDeleteSuccess];
            }
            else
                [RequestSerive alerViewMessage:mDeleteFailure];
        }
        
        
    }
    
}



-(void)gotoDelete
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:fListArray[howInt][@"RowID"] forKey:@"rowID"];
    [serive PostFromURL:ADeletePerPhotosByRowID params:dic mHttp:httpUrl isLoading:NO];
}

-(void)loginAction:(UIButton*)sender
{
    howInt = (int)sender.tag -10;
    
    NSArray *tArray = [NSArray arrayWithObjects:@"修改文章",@"删除文章",nil];
    UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *adic in tArray)
    {
        [photoSheet addButtonWithTitle:adic];
    }
    photoSheet.tag = 1;
    photoSheet.actionSheetStyle=UIActionSheetStyleDefault;
    [photoSheet showInView:[UIApplication sharedApplication].keyWindow];
}
#pragma mark - uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)//取消
        {
            
        }
        else if (buttonIndex == 1)//修改文章
        {
            SendViewController *vc = [[SendViewController alloc] init];
            NSLog(@"-----%@",fListArray[howInt]);
            NSLog(@"AuthorCompany:%@",fListArray[howInt]);
            if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"78"]) {
                vc.RowID = @"78";
                vc.title = [menuArray objectAtIndex:3];
            }
            else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"0"]) {
                vc.RowID = @"0";
                vc.title = [menuLDArray objectAtIndex:3];
            }
            else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"151"]) {
                vc.RowID = @"151";
                vc.title = [menuLDArray objectAtIndex:3];
            }
            else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"171"]) {
                if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"TabClass"]] isEqualToString:@"<null>"]) {
                    vc.RowID = @"171";
                    vc.title = [menuLDArray objectAtIndex:3];
                }else{
                    vc.RowID = @"186";
                    vc.title = @"安全稳定";
                }
            }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"165"]) {
                vc.RowID = @"165";
                vc.title = [menuLDArray objectAtIndex:4];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"261"]) {
               vc.RowID = @"261";
               vc.title = [menuLDArray objectAtIndex:6];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"262"]) {
               vc.RowID = @"262";
               vc.title = [menuLDArray objectAtIndex:7];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"281"]) {
               vc.RowID = @"281";
               vc.title = [menuLDArray objectAtIndex:8];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"301"]) {
               vc.RowID = @"301";
               vc.title = [menuLDArray objectAtIndex:9];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"309"]) {
               vc.RowID = fListArray[howInt][@"ClassId"];
               vc.isChild = YES;
               vc.title = fListArray[howInt][@"AuthorCompany"];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"310"]) {
//               NSLog(@"AuthorCompany:%@",fListArray[howInt][@"AuthorCompany"]);
               vc.RowID = fListArray[howInt][@"ClassId"];
               vc.isChild = YES;
               vc.title = fListArray[howInt][@"AuthorCompany"];
           }
           else if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"353"]||[[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"354"]||[[NSString stringWithFormat:@"%@",fListArray[howInt][@"SpecialId"]] isEqualToString:@"355"]) {
               //               NSLog(@"AuthorCompany:%@",fListArray[howInt][@"AuthorCompany"]);
               vc.RowID = fListArray[howInt][@"ClassId"];
               vc.isChild = YES;
               vc.title = fListArray[howInt][@"AuthorCompany"];
           }
            else
            {
                
//                for (int i = 0 ; i < wfSubCodeArray.count; i ++)
//                {
//                    if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"ClassId"]] isEqualToString:[wfSubCodeArray objectAtIndex:i]])
//                    {
//                        vc.RowID = [wfSubCodeArray objectAtIndex:i];
//                        vc.title = [menuArray objectAtIndex:i];
//                        break;
//                    }
//                }
                vc.RowID = fListArray[howInt][@"ClassId"];
                vc.isChild = YES;
//                vc.title = fListArray[howInt][@"AuthorCompany"];
                for (NSString *str in [wfSubCodeDic allKeys]) {
                    if ([[NSString stringWithFormat:@"%@",fListArray[howInt][@"ClassId"]] isEqualToString:[wfSubCodeDic objectForKey:str]]) {
                        vc.RowID = [wfSubCodeDic objectForKey:str];
                        vc.title = str;
                        break;
                    }
                }
            }
            vc.Adic = fListArray[howInt];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (buttonIndex == 2)//删除文章
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除文章?"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag =2;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [self gotoDelete];
        }
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)setHeader
{
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];
    numHightArray = [[NSMutableArray alloc] init];
    titleHArray = [[NSMutableArray alloc] init];
    [mTableView.header beginRefreshing];
}


- (void)loadNewData
{
    pageForNumber = 1;
    fListArray = [[NSMutableArray alloc] init];
    numHightArray = [[NSMutableArray alloc] init];
    titleHArray = [[NSMutableArray alloc] init];
    [self upDateTableView];
}
- (void)loadMoreData
{
    pageForNumber++;
    [self upDateTableView];
}

-(void)upDateTableView
{
    if (TotalCount <= [fListArray count]||pageForNumber ==1)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:[ToolCache userKey:kAccount] forKey:@"IMEINO"];
        [dic setValue:[NSString stringWithFormat:@"%d",pageForNumber] forKey:@"PageIndex"];
        [dic setValue:[NSString stringWithFormat:@"%d",itemLabel] forKey:@"PageSize"];
        [dic setValue:[ToolCache userKey:kAccount] forKey:@"OAUserID"];
        [serive PostFromURL:AGetMyPerPhotosList params:dic mHttp:httpUrl isLoading:NO];
    }
    else
    {
        [mTableView.footer endRefreshingWithNoMoreData];
        [mTableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (numHightArray.count>indexPath.row)
    {
        return [[NSString stringWithFormat:@"%@",[numHightArray objectAtIndex:indexPath.row]] intValue];
    }
    else
    {
        if (fListArray.count <= indexPath.row) {
            return 0;
        }
        FullCutModel *entity = [[FullCutModel alloc] initWithDictionary:fListArray[indexPath.row]];
        
        int detialInt  = 0;

        {
            detialInt = [ToolCache setString:entity.SumnaryString setSize:labelSize-2 setWight:screenMySize.size.width-txImageSize-agsize*2];
            if (detialInt > 60)//三行start
            {
                detialInt = 60;
            }//三行end
            [titleHArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        }
        
        NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
        int contAr = (int)imageUrlArray.count;
        if (oneLine == 1) {
            //一行图片start
            if (contAr > 0) {
                detialInt = (imageSize+10) +detialInt+titleHight+timeHight+titleH+agsize*2;
            }//一行图片end
            else
                detialInt = detialInt+titleHight+timeHight+titleH+agsize*2;
        }
        else
        {
            if (contAr >= 9) {
                contAr = 9;
            }
            int hight = 0;
            for (int i = 0 ; i < contAr; i ++)
            {
                if ((float)contAr/3 <= i+1 && (float)contAr/3>i) {
                    hight = i+1;
                    break;
                }
            }
            detialInt = hight*(imageSize+10) +detialInt+titleHight+timeHight+titleH+agsize*2;
            
        }
        
        [numHightArray addObject:[NSString stringWithFormat:@"%d",detialInt]];
        return detialInt;
    }
    
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
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        aTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        aTableView.showsVerticalScrollIndicator = NO;
    }
    while ([cell.contentView.subviews lastObject] != nil)
    {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = bgColor;

//    if (_bgImageView == nil)
//    {
        UIImageView *_bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(agsize,agsize, txImageSize,txImageSize)];
        _bgImageView.image = [UIImage imageNamed:@"tx_nan"];
        _bgImageView.contentMode =  UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:_bgImageView];
    
    
        UILabel *_nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_bgImageView.frame.origin.x+txImageSize+agsize, _bgImageView.frame.origin.y, 150, titleHight)];
        _nameLabel.textAlignment = 0;
        _nameLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _nameLabel.textColor = [UIColor blueColor];
        [cell.contentView addSubview:_nameLabel];
    
    UILabel *_name1Label = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width, _nameLabel.frame.origin.y, screenMySize.size.width-(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+agsize), titleHight)];
    _name1Label.textAlignment = 2;
    _name1Label.font = [UIFont fontWithName:@"Arial" size:labelSize-1];
    _name1Label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:_name1Label];
    
    
        UILabel *_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y+titleHight, screenMySize.size.width-_nameLabel.frame.origin.x, titleH)];
        _titleLabel.textAlignment = 0;
        _titleLabel.numberOfLines = 2;
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:labelSize];
        _titleLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [cell.contentView addSubview:_titleLabel];
        
        UILabel *_name2Label = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x-agsize, 0)];
        _name2Label.textAlignment = 0;
        _name2Label.numberOfLines = 3;
        _name2Label.font = [UIFont fontWithName:@"Arial" size:labelSize-2];
        _name2Label.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [cell.contentView addSubview:_name2Label];
        
 
    UILabel*  _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_titleLabel.frame.origin.x, timeHight)];
    _timeLabel.textAlignment = 0;
    _timeLabel.font = [UIFont fontWithName:@"Arial" size:labelSize-3];
    _timeLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:_timeLabel];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setFrame:CGRectMake(screenMySize.size.width-agsize-44,_titleLabel.frame.origin.y+titleH, 35, 35)];
    [loginButton setImage:[UIImage imageNamed:@"操作图标"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.tag = 10+indexPath.row;
    [cell.contentView addSubview:loginButton];
    
    
    UIImageView *_line1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [_line1ImageView setFrame:CGRectMake(agsize, _timeLabel.frame.origin.y+_timeLabel.frame.size.height, screenMySize.size.width-2*agsize, 2)];
    [cell.contentView addSubview:_line1ImageView];
//    }
//    操作图标
    if (fListArray.count != 0)
    {
        FullCutModel *entity = [[FullCutModel alloc] initWithDictionary:fListArray[indexPath.row]];
        int detialInt = 0;
        
        if ([entity.title hash] && (id)entity.title != [NSNull null])
            _titleLabel.text = entity.title;

        {
            detialInt = [[NSString stringWithFormat:@"%@",[titleHArray objectAtIndex:indexPath.row]] intValue];
            if ([entity.CreateTime hash] && (id)entity.CreateTime != [NSNull null])
                _timeLabel.text = [NSString stringWithFormat:@"%@",entity.CreateTime];
            
            
            
            if ([entity.SumnaryString hash] && (id)entity.SumnaryString != [NSNull null])
            {
                _name2Label.text = entity.SumnaryString;
            }
            else
            {
                _name2Label.text = @"";
            }
            _name2Label.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH, screenMySize.size.width-_nameLabel.frame.origin.x, detialInt);
        }

        _nameLabel.text = [NSString stringWithFormat:@"%@",[ToolCache userKey:kDspName]];
        
        if ([entity.Rank hash] && (id)entity.Rank != [NSNull null])
            _name1Label.text = [NSString stringWithFormat:@"%@",entity.Rank];
        
        if ([entity.Pictureurl hash] && (id)entity.Pictureurl != [NSNull null])
            [_bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,entity.Pictureurl]] placeholderImage:[UIImage imageNamed:@"tx_nan"]];
        
        NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
        int contAr = (int)imageUrlArray.count;
        
        //一行图片start
        if (oneLine == 1)
        {
            if (contAr >= 3) {
                contAr = 3;
            }
            //一行图片end
        }
        else
        {
            if (contAr >= 9) {
                contAr = 9;
            }
            
        }
        
        int hight = 0;
        for (int i = 0 ; i < contAr; i ++)
        {
            CGRect frame = CGRectMake(10+txImageSize+(imageSize+10)*(i%3), _name2Label.frame.size.height+_name2Label.frame.origin.y+i/3*(imageSize+10), imageSize, imageSize);
            
            TapImageView *tmpView = [[TapImageView alloc] initWithFrame:frame];
            tmpView.t_delegate = self;
            tmpView.image = [UIImage imageNamed:@"no-imgage2.jpg"];
            tmpView.tag = 10000*(indexPath.row+1) + i;
            [cell.contentView addSubview:tmpView];
            
            [tmpView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"no-imgage2.jpg"]];

            if ((float)contAr/3 <= i+1 && (float)contAr/3>i) {
                hight = i+1;
            }
            
        }

        _timeLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10), screenMySize.size.width-_titleLabel.frame.origin.x, timeHight);

        loginButton.frame = CGRectMake(screenMySize.size.width-agsize-35,_titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10)-7, 25, 25);
        _line1ImageView.frame = CGRectMake(agsize, _titleLabel.frame.origin.y+titleH+detialInt+hight*(imageSize+10)+timeHight, screenMySize.size.width-2*agsize, 2);

        
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    [self.view bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    currentIndex = tmpView.tag%10000;
    tagRow = (int)tmpView.tag/10000;
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
    convertRect.origin.y =  convertRect.origin.y +64;
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex*screenMySize.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image setUrl:nil];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 30; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self.view viewWithTag:10000*tagRow + i];
        NSString *urlStr = nil;
        if (oneLine == 1 && tmpView == nil)
        {
            FullCutModel *entity = [[FullCutModel alloc] initWithDictionary:fListArray[tagRow-1]];
            NSMutableArray *imageUrlArray =  [ToolCache setUrlImage:entity.Content];
            
            if (i >= (int)imageUrlArray.count) {
                
                CGSize contentSize = myScrollView.contentSize;
                contentSize.height = screenMySize.size.height;
                contentSize.width = screenMySize.size.width * i;
                myScrollView.contentSize = contentSize;
                return;
            }
            else
            {
                urlStr = [NSString stringWithFormat:@"%@",[imageUrlArray objectAtIndex:i]];
            }
        }
        else
        {
            if (tmpView == nil) {
                CGSize contentSize = myScrollView.contentSize;
                contentSize.height = screenMySize.size.height;
                contentSize.width = screenMySize.size.width * i;
                myScrollView.contentSize = contentSize;
                return;
            }
        }
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:self.view];
        convertRect.origin.y =  convertRect.origin.y +64;
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image setUrl:urlStr];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    DetialsViewController *vc = [[DetialsViewController alloc] init];
    vc.title = self.title;
    vc.dic = [fListArray objectAtIndex:indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

