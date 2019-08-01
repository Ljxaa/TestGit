//
//  NewMenuItem.h
//  港务移动信息
//
//  Created by _ADY on 14-11-14.
//  Copyright (c) 2014年 _ADY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDModel.h"
@interface NewMenuItem : BDModel


@property (nonatomic, copy) NSString *RowID;
@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, copy) NSString *ParentId;
@property (nonatomic, copy) NSString *OrderNo;
@property (nonatomic, copy) NSString *ClassLevel;
@property (nonatomic, copy) NSString *Entity;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *Title;


@end
