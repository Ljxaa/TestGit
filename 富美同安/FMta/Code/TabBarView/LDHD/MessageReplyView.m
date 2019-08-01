//
//  MessageReplyView.m
//  同安政务
//
//  Created by _ADY on 16/4/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import "MessageReplyView.h"
#import "ToolCache.h"
#import "Global.h"
#import "SRMModalViewController.h"
#import "MessageView.h"
#import "CustomEditLabel.h"
#define kUIScreenSize [UIScreen mainScreen].bounds.size

#define kEdgeLen 5
#define kShowLine 3//显示几行

@interface MessageReplyView()<MessageViewDelegate,SRMModalViewControllerDelegate>{
    BOOL isShowCompany;
}

@end

@implementation MessageReplyView


- (void)setWithDictionary:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr isShowCompany:(BOOL)isShow
{
    if (self)
    {
        isShowCompany = isShow;
        ReplyArr = [replyDic objectForKey:@"CommentDataList"];
        NSLog(@"ReplyArr:%@",ReplyArr);
        float endHeight = 15;
        UIImage *commentImg = [UIImage imageNamed:@"评论"];
        UIImageView *bgReplyImgView = [[UIImageView alloc]initWithImage:commentImg];
        bgReplyImgView.userInteractionEnabled = YES;
        bgReplyImgView.clipsToBounds = NO;
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
        
        [bottomBtn addSubview:bgReplyImgView];
        
        if (!ReplyArr.count) {
            endHeight = -5;
        }
        else
        {
            for (int i = 0; i < ReplyArr.count; i++)
            {
                
                
                CustomEditLabel *singleReplyLbl = [[CustomEditLabel alloc] init];
                NSDictionary *singleCommentDic = ReplyArr[i];
//                [singleReplyLbl setUserInteractionEnabled:YES];
                /* - - - - - - - - - - - - - 遍历已经删除的RowID 如果是 则不执行视图添加- - - - - - - - - - - - - - - - -*/
                BOOL noShowOne = false;
                for (NSString *num in deleteArr)
                {
                    if ([num intValue] == [[singleCommentDic objectForKey:@"RowID"] intValue])
                    {
                        noShowOne = true;
                        break;
                    }
                    //若删除评论,则删除回复改评论的子评论
                    if ([num intValue] == [[NSString stringWithFormat:@"%@",[singleCommentDic objectForKey:@"OrderNo"]] intValue])
                    {
                        noShowOne = true;
                        break;
                    }
                }
                if (noShowOne)
                {
                    noShowOne = false;
                    continue;
                }
                /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
                
                
                NSString *contentStr = [singleCommentDic objectForKey:@"Content"];
                NSString *commentName = [singleCommentDic objectForKey:@"CommentName"];
                NSString *createIDStr = [singleCommentDic objectForKey:@"CreateID"];
                NSString *replyToPersonName = [NSString stringWithFormat:@"%@",[singleCommentDic objectForKey:@"IMEINO"]];
                
                if ([replyToPersonName isEqualToString:@""] || [replyToPersonName isEqualToString:@"<null>"])
                {
                    NSString *endStr;
                    if (isShow) {
                        endStr = [NSString stringWithFormat:@"%@:%@(%@) %@",commentName,[singleCommentDic objectForKey:@"Company"],[singleCommentDic objectForKey:@"Createdate"],contentStr];
                    }else{
                        endStr = [NSString stringWithFormat:@"%@:%@",commentName,contentStr];
                    }
                    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc]initWithString:endStr];
                    [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                        value:[UIColor blueColor]
                                        range:NSMakeRange(0, commentName.length)];
                    
                    [atributeStr addAttribute:NSFontAttributeName             //文字字体
                                        value:[UIFont systemFontOfSize:14]
                                        range:NSMakeRange(0, endStr.length)];
                    singleReplyLbl.attributedText = atributeStr;
                }
                else
                {
                    NSString *endStr = [NSString stringWithFormat:@"%@回复%@:%@",commentName,replyToPersonName,contentStr];
                    NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc]initWithString:endStr];
                    
                    [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                        value:[UIColor blueColor]
                                        range:NSMakeRange(0, commentName.length)];
                    
                    [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                        value:[UIColor blueColor]
                                        range:NSMakeRange(commentName.length+2, replyToPersonName.length)];
                    
                    
                    [atributeStr addAttribute:NSFontAttributeName             //文字字体
                                        value:[UIFont systemFontOfSize:14]
                                        range:NSMakeRange(0, endStr.length)];
                    singleReplyLbl.attributedText = atributeStr;
                    
                }
                
                singleReplyLbl.font = [UIFont systemFontOfSize:14];
                singleReplyLbl.numberOfLines = kShowLine;
                CGSize maxSingleReplyLblSize = CGSizeMake(kUIScreenSize.width-55-10-20-15, 1000);
                CGSize singleReplySize = [singleReplyLbl sizeThatFits:maxSingleReplyLblSize];
                
                //评论上方空行
                UIView *spaceAboveReply = [[UIView alloc] initWithFrame:CGRectMake(0, endHeight, kUIScreenSize.width-55-10-20-15, 7.5)];
                [bgReplyImgView addSubview:spaceAboveReply];
                endHeight += 7.5;
                
                //分割线
                if (i)
                {
                    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(10, endHeight-6.5, kUIScreenSize.width-55-10-15, 1)];
                    spaceLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
                    [bgReplyImgView addSubview:spaceLine];
                }
                //单条评论
                singleReplyLbl.frame = CGRectMake(10, endHeight, kUIScreenSize.width-55-10-20-15, singleReplySize.height);
                [bgReplyImgView addSubview:singleReplyLbl];
                
                //判断是否是自己评价的内容 是自己评价的内容则可以撤销,不是自己评价的内容 则需要再判断文章是不是自己的 如果是则开启回复功能
                if ([createIDStr isEqualToString:[ToolCache userKey:kAccount]])
                {
                    //删除按钮
                    SingleReplyButton *deleteBtn = [SingleReplyButton buttonWithType:UIButtonTypeCustom];
                    [deleteBtn setImage:[UIImage imageNamed:@"撤销"] forState:UIControlStateNormal];
                    [deleteBtn addTarget:self action:@selector(deleteOrReplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [deleteBtn setFrame:CGRectMake(kUIScreenSize.width-28-2.5, endHeight+3, 15, 15)];
                    [self addSubview:deleteBtn];
                    deleteBtn.rowID = [singleCommentDic objectForKey:@"RowID"];
                    deleteBtn.isDelete = YES;
                    deleteBtn.createNickame = commentName;
                    
                    //盖在文字上方的删除按钮
                    SingleReplyButton *replyBtn = [SingleReplyButton buttonWithType:UIButtonTypeCustom];
                    [replyBtn setFrame:CGRectMake(10, endHeight-7.5, kUIScreenSize.width-55, singleReplySize.height+16)];
                    [replyBtn addTarget:self action:@selector(deleteOrReplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgReplyImgView addSubview:replyBtn];
                    NSLog(@"%@",replyBtn);
                    replyBtn.rowID = [singleCommentDic objectForKey:@"RowID"];
                    replyBtn.createNickame = commentName;
                    replyBtn.isDelete = YES;
                    
                }
                else/*其他人的评论*/
                {
                    isDelte = NO;
                    
                    //判断账号是否是文章的发起者 (如果是发起者则可以回复其他评论的人)
                    if([_articleID isEqualToString:[ToolCache userKey:kAccount]])
                        _isSelfArticle = YES;
                    else
                        _isSelfArticle = NO;
                    
                    SingleReplyButton *replyBtn = [SingleReplyButton buttonWithType:UIButtonTypeCustom];
                    [replyBtn setFrame:CGRectMake(10, endHeight-7.5, kUIScreenSize.width-55, singleReplySize.height+16)];
                    [replyBtn addTarget:self action:@selector(deleteOrReplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [bgReplyImgView addSubview:replyBtn];
                    replyBtn.rowID = [singleCommentDic objectForKey:@"RowID"];
                    replyBtn.createNickame = commentName;
                    replyBtn.isDelete = NO;
                }
                [bgReplyImgView bringSubviewToFront:singleReplyLbl];
                
                int lineCount = singleReplySize.height / singleReplyLbl.font.lineHeight;
                
                endHeight += singleReplySize.height;
                
                if (lineCount >= kShowLine) {
                    UIButton *showAllBtn = [[UIButton alloc]initWithFrame:CGRectMake(singleReplyLbl.frame.origin.x, endHeight, singleReplyLbl.frame.size.width, 20)];
                    [showAllBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
                    [showAllBtn setTitleColor:blueFontColor forState:UIControlStateNormal];
                    [showAllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
                    endHeight += 20;
                    [showAllBtn setTag:i + 9999];
                    [showAllBtn addTarget:self action:@selector(showAllTitle:) forControlEvents:UIControlEventTouchUpInside];
                    [bgReplyImgView addSubview:showAllBtn];
                }
                
                //评论下方空行
                UIView *spaceBelowReply = [[UIView alloc] initWithFrame:CGRectMake(0, endHeight, kUIScreenSize.width-55-10-20-15, 7.5)];
                [bgReplyImgView addSubview:spaceBelowReply];
                endHeight += 7.5;
                
//                if (i != (replyArr.count-1 - hiddenCount))
//                {
//                    //分割线
//                    UIView *spaceLine = [[UIView alloc] initWithFrame:CGRectMake(10, endHeight-1, kUIScreenSize.width-55-10-15, 1)];
//                    spaceLine.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
//                    [bgReplyImgView addSubview:spaceLine];
//                }
            }
            if (endHeight == 15)
                endHeight = -5;
        }
        
        [bgReplyImgView setImage:[commentImg stretchableImageWithLeftCapWidth:45 topCapHeight:20]];
        bgReplyImgView.frame = CGRectMake(50+5, 0, kUIScreenSize.width-55-5, endHeight+5);
        
        [bottomBtn setFrame:CGRectMake(0, 0, kUIScreenSize.width, endHeight+5)];
    }
    
}



+ (float)getReplyViewHeightWith:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr isShowCompany:(BOOL)isShow
{
    NSArray *replyArr = [replyDic objectForKey:@"CommentDataList"];
    
    if (!replyArr.count)
    {
        return 0.1;
    }
    else
    {
        float replyViewHeight =0;
        
        
        for (int i = 0; i < replyArr.count; i++) {
            UILabel *singleReplyLbl = [[UILabel alloc] init];
            singleReplyLbl.numberOfLines = kShowLine;
            NSDictionary *singleCommentDic = replyArr[i];
            
            //遍历已经删除的RowID 如果是 则不执行视图添加
            BOOL noShowOne = false;
            for (NSString *num in deleteArr)
            {
                if ([num intValue] == [[singleCommentDic objectForKey:@"RowID"] intValue]) {
                    noShowOne = true;
                    break;
                }
                //若删除评论,则删除回复改评论的子评论
                if ([num intValue] == [[NSString stringWithFormat:@"%@",[singleCommentDic objectForKey:@"OrderNo"]] intValue])
                {
                    noShowOne = true;
                    break;
                }
            }
            if (noShowOne)
            {
                noShowOne = false;
                continue;
            }
            
            NSString *contentStr = [singleCommentDic objectForKey:@"Content"];
            NSString *commentName = [singleCommentDic objectForKey:@"CommentName"];
//            NSString *createIDStr = [singleCommentDic objectForKey:@"CreateID"];
            NSString *replyToPersonName = [NSString stringWithFormat:@"%@",[singleCommentDic objectForKey:@"IMEINO"]];
            
            NSString *endStr;
            
            if ([replyToPersonName isEqualToString:@""] || [replyToPersonName isEqualToString:@"<null>"])
            {
//                endStr = [NSString stringWithFormat:@"%@:%@",commentName,contentStr];
                if (isShow) {
                    endStr = [NSString stringWithFormat:@"%@:%@(%@) %@",commentName,[singleCommentDic objectForKey:@"Company"],[singleCommentDic objectForKey:@"Createdate"],contentStr];
                }else{
                    endStr = [NSString stringWithFormat:@"%@:%@",commentName,contentStr];
                }
                NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc]initWithString:endStr];
                [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                    value:[UIColor blueColor]
                                    range:NSMakeRange(0, commentName.length)];
                
                [atributeStr addAttribute:NSFontAttributeName             //文字字体
                                    value:[UIFont systemFontOfSize:14]
                                    range:NSMakeRange(0, endStr.length)];
                singleReplyLbl.attributedText = atributeStr;
            }
            else
            {
                endStr = [NSString stringWithFormat:@"%@回复%@:%@",commentName,replyToPersonName,contentStr];
                NSMutableAttributedString *atributeStr = [[NSMutableAttributedString alloc]initWithString:endStr];
                
                [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                    value:[UIColor blueColor]
                                    range:NSMakeRange(0, commentName.length)];
                
                [atributeStr addAttribute:NSForegroundColorAttributeName  //文字颜色
                                    value:[UIColor blueColor]
                                    range:NSMakeRange(commentName.length+2, replyToPersonName.length)];
                
                
                [atributeStr addAttribute:NSFontAttributeName             //文字字体
                                    value:[UIFont systemFontOfSize:14]
                                    range:NSMakeRange(0, endStr.length)];
                singleReplyLbl.attributedText = atributeStr;
                
            }
            singleReplyLbl.font = [UIFont systemFontOfSize:14];
            CGSize maxSingleReplyLblSize = CGSizeMake(kUIScreenSize.width-55-10-20-15, 1000);
            CGSize singleReplySize = [singleReplyLbl sizeThatFits:maxSingleReplyLblSize];
            
            replyViewHeight +=singleReplySize.height+15;
            //判断超过两行
            int lineCount = singleReplySize.height / singleReplyLbl.font.lineHeight;
            if (lineCount >= kShowLine) {
                replyViewHeight += 20;
            }
        }
        
        if (replyViewHeight == 15) {
            return 0.1;
        }
        
        return replyViewHeight+15+5;
    }
}

- (void)deleteOrReplyBtnClick:(SingleReplyButton *)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    senderBtn = sender;
    
    if (sender.isDelete)
    {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除该回复?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
    }
    else
    {
        NSLog(@"reply");
        [self.delegate isDeleteOrReplyComment:NO
                                isSelfArticle:_isSelfArticle
                                    withRowID:[sender.rowID intValue]
                                   withSender:senderBtn];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        return;
    }
    if (buttonIndex == 1) {
        
        
        NSString *netStateStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"networkState"];

        if ([netStateStr isEqualToString:@"当前网络未连接"])
        {
            kAlertShow(netStateStr);
            return;
        }
        
        [self.delegate isDeleteOrReplyComment:YES
                                isSelfArticle:_isSelfArticle
                                    withRowID:[senderBtn.rowID intValue]
                                   withSender:senderBtn];
    }
}

- (void)bottomBtnClick:(UIButton *)sender
{
    NSLog(@"bottomBtn Click");
}

- (void)showAllTitle:(UIButton *)btn{
    NSInteger tag = btn.tag - 9999;
    NSDictionary *singleCommentDic = ReplyArr[tag];
    NSString *contentStr = [singleCommentDic objectForKey:@"Content"];
    if (isShowCompany) {
        contentStr = [NSString stringWithFormat:@"<h3>%@(%@)</h3>%@",[singleCommentDic objectForKey:@"Company"],[singleCommentDic objectForKey:@"Createdate"],[singleCommentDic objectForKey:@"Content"]];
    }
    [SRMModalViewController sharedInstance].delegate = self;
    [SRMModalViewController sharedInstance].enableTapOutsideToDismiss = NO;
    //    [SRMModalViewController sharedInstance].shouldRotate = NO;
    [SRMModalViewController sharedInstance].statusBarStyle = UIStatusBarStyleLightContent;
    MessageView *messageView = [[MessageView alloc]initWithFrame:CGRectMake(0, 0, screenMySize.size.width-60, screenMySize.size.height-100)];
//    [messageView setListData:dic];
    [messageView setShiwStrData:contentStr];
    [messageView setDelegate:self];
    [[SRMModalViewController sharedInstance] showView:messageView];
//    ReplyArr
}
-(void)touchZhiDaoLe:(BOOL)isZhiDaoLe{
    [[SRMModalViewController sharedInstance] hide];
}

- (void)modalViewWillShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidShow:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewWillHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)modalViewDidHide:(SRMModalViewController *)modalViewController {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)disposeModalViewControllerNotification:(NSNotification *)notification {
    NSLog(@"%@", notification.name);
}
@end
