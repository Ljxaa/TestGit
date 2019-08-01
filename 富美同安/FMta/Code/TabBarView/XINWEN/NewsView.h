//
//  NewsView.h
//  同安政务
//
//  Created by _ADY on 15/12/25.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewsViewDelegat<NSObject>
-(void)inAction:(int)aTag;
@end

@interface NewsView : UIView<UIScrollViewDelegate>
{
    UIScrollView *taScrollView;
    CGRect aframe;
    int eTimerNum;
    int dicCount;
    NSTimer *ADeTimer;
}
@property (unsafe_unretained) id <NewsViewDelegat> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void)setDic:(NSMutableArray*)dicArray;
@end
