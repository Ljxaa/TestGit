//
//  MenuNewsView.h
//  同安政务
//
//  Created by _ADY on 15/12/25.
//  Copyright © 2015年 _ADY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuNewsViewDelegate<NSObject>
-(void)setIntPath:(int)path;
@end

@interface MenuNewsView:UIView <UITableViewDataSource, UITableViewDelegate>
{
    CGRect vFrame;
    UITableView *myTableView;
}
@property (unsafe_unretained) id <MenuNewsViewDelegate> delegate;
@property (nonatomic, retain)  NSMutableArray *MenuLArray;
-(void)reloadDataView;
@end