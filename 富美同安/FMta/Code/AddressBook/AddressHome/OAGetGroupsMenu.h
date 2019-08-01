//
//  OAGetGroupsMenu.h
//  同安政务
//
//  Created by _ADY on 16/1/20.
//  Copyright © 2016年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"

@interface OAGetGroupsMenu : BDModel
@property (nonatomic, copy) NSString *Guid;
@property (nonatomic, copy) NSString *Id;//当前
@property (nonatomic, copy) NSString *PId;//上一级
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *IsShow;
@property (nonatomic, copy) NSString *OrderNo;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *TreeLevel;
@property (nonatomic, copy) NSString *GroupId;//过滤
@property (nonatomic, copy) NSString *UserAccount;
@end
