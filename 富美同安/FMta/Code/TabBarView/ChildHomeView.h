//
//  ChildHomeView.h
//  同安政务
//
//  Created by wx_air on 16/4/28.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChildHomeViewDelegate <NSObject>
-(void)touchListByRow:(NSInteger)row;//列表点击
-(void)touchBody;
@end

@interface ChildHomeView : UIButton{
    UIImageView *bgImage;
    id <ChildHomeViewDelegate> delegate;//代理
}
@property (nonatomic,retain) id <ChildHomeViewDelegate> delegate;//代理
- (void)setListData:(NSArray *)arr NumberDic:(NSDictionary *)numberDic numberKeyArr:(NSArray *)keyArr;
- (void)setListDataWithFix:(NSArray *)arr NumberDic:(NSDictionary *)numberDic numberKeyArr:(NSArray *)keyArr;

@property (nonatomic,retain) NSString *Title;
@end
