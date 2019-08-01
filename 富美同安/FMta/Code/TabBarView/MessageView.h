//
//  MessageView.h
//  同安政务
//
//  Created by wx_air on 16/6/27.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
//通知界面
@protocol MessageViewDelegate <NSObject>
-(void)touchZhiDaoLe:(BOOL)isZhiDaoLe;//知道了点击
@end

@interface MessageView : UIView{
    UIImageView *bgImage;
    id <MessageViewDelegate> delegate;//代理
}
@property (nonatomic,retain) id <MessageViewDelegate> delegate;//代理
- (void)setListData:(NSDictionary *)dic;
- (void)setShiwStrData:(NSString *)str;
@end
