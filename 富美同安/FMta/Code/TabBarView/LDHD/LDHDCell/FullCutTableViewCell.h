//
//  FullCutTableViewCell.h
//  同安政务
//
//  Created by _ADY on 15/12/21.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullCutModel.h"
#import "ImgScrollView.h"
#import "TapImageView.h"

#define txImageSize 50//头像大小
#define titleHight 15//名字高度
#define agsize 5//离边框距离
#define titleH 50//标题高度
#define timeHight 20//时间高度

#define imageSize (screenMySize.size.width-agsize*2-txImageSize)/3-10

@interface FullCutTableViewCell : UITableViewCell<ImgScrollViewDelegate,TapImageViewDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    int detialInt;//详情高度
    
    NSInteger currentIndex;
    
    UIView *markView;
    UIView *scrollPanel;
    UIScrollView *myScrollView;
    
}
- (void)setEntity:(FullCutModel *)entity withHigth:(int)aAhight;
@end
