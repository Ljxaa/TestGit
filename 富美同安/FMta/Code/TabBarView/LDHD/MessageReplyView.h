//
//  MessageReplyView.h
//  同安政务
//
//  Created by _ADY on 16/4/21.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleReplyButton.h"


@protocol MessageReplyViewDelegate <NSObject>

@required

- (void)isDeleteOrReplyComment:(BOOL)isDelete
                 isSelfArticle:(BOOL)isSelf
                     withRowID:(long)rowID
                    withSender:(SingleReplyButton *)sender;

@optional

- (void)replyViewMakeKeyboardDown;

@end


@interface MessageReplyView : UIView
{
    BOOL isDelte;
    SingleReplyButton *senderBtn;
    NSArray *ReplyArr;
}

@property (nonatomic, assign) long int rowID;//评论ID
@property (nonatomic, strong) NSMutableArray *DeleteRowIDArr;
@property (nonatomic, assign) id<MessageReplyViewDelegate> delegate;//代理
@property (nonatomic, assign) BOOL isSelfArticle;//是否是自己发起的评论
@property (nonatomic, copy) NSString *articleID;


//通过回复数据的字典初始化回复视图 及其当前删除未更新所需要隐藏的评论
//- (void)setWithDictionary:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr;
- (void)setWithDictionary:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr isShowCompany:(BOOL)isShow;
//- (instancetype)initWithDictionary:(NSDictionary *)replyDic;

//通过评论条数返回评论视图的高度
//- (float)getReplyViewHeightWith:(NSDictionary *)replyDic;

//+ (float)getReplyViewHeightWith:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr;
+ (float)getReplyViewHeightWith:(NSDictionary *)replyDic withDeleteRowIDArr:(NSArray *)deleteArr isShowCompany:(BOOL)isShow;

- (void)deleteOrReplyBtnClick:(UIButton *)sender;

@end
