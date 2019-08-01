//
//  CalendarViewController.h
//  文广传媒
//
//  Created by _ADY on 14-9-18.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRGCalendarView.h"
#import "RequestSerive.h"
@protocol CalendarViewDelegat<NSObject>
-(void)getTime:(NSString*)aTag setIndex:(int)index;
@end

@interface CalendarViewController :UIViewController<UIScrollViewDelegate,VRGCalendarViewDelegate,RSeriveDelegate>
{
    VRGCalendarView* calendar;
    RequestSerive *serive;
    
    UIView *selectView;
    int selectedIndex;
    NSArray *sidebarArray;
    NSString *fTime,*eTime;
}
@property (unsafe_unretained) id <CalendarViewDelegat> delegate;
@end
