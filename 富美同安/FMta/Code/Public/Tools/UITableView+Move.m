//
//  UITableView+Move.m
//  物业电商
//
//  Created by wx_air on 2017/9/21.
//  Copyright © 2017年 _ADY. All rights reserved.
//

#import "UITableView+Move.h"

@implementation UITableView (Move)

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
}

@end
